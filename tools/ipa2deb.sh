#!/bin/bash
# Dùng: ipa2deb.sh <file.ipa> <thư-mục-xuất>
set -e
IPA="$1"; OUT="$2"
W=$(mktemp -d)
unzip -q "$IPA" -d "$W/x"
APP=$(ls -d "$W"/x/Payload/*.app | head -1)

read -r BID VER EXE NAME < <(python3 - "$APP/Info.plist" <<'PY'
import plistlib, sys
p = plistlib.load(open(sys.argv[1], 'rb'))
name = p.get('CFBundleDisplayName', p.get('CFBundleName', 'App')).replace(' ', '_')
ver = str(p.get('CFBundleShortVersionString', p.get('CFBundleVersion', '1.0'))).replace(' ', '_')
print(p['CFBundleIdentifier'], ver, p['CFBundleExecutable'], name)
PY
)
NAME=${NAME//_/ }

# Ký giả (fake-sign) để chạy được trên iPhone/iPad đã jailbreak
LDID=$(command -v ldid || find "$THEOS" -name ldid -type f 2>/dev/null | head -1)
if [ -n "$LDID" ]; then
  "$LDID" -S "$APP/$EXE" || true
else
  echo "Cảnh báo: không tìm thấy ldid, bỏ qua bước ký"
fi
chmod 755 "$APP/$EXE"

P="$W/pkg"
mkdir -p "$P/Applications" "$P/DEBIAN"
cp -R "$APP" "$P/Applications/"

cat > "$P/DEBIAN/control" <<EOF
Package: $BID
Name: $NAME
Version: $VER
Architecture: iphoneos-arm
Section: Applications
Depends: firmware (>= 6.0)
Description: $NAME (đóng gói từ IPA)
Author: iOS27 Repo
Maintainer: iOS27 Repo
EOF

printf '#!/bin/bash\nuicache\nexit 0\n' > "$P/DEBIAN/postinst"
printf '#!/bin/bash\nuicache\nexit 0\n' > "$P/DEBIAN/postrm"
chmod 755 "$P/DEBIAN/postinst" "$P/DEBIAN/postrm"

mkdir -p "$OUT"
dpkg-deb -Zgzip -b "$P" "$OUT/${BID}_${VER}_iphoneos-arm.deb"
rm -rf "$W"
