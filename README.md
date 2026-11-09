# iOS 27 for iPad 2 (iOS 6.1.3)

Theme/tweak kiểu glass cho iPad 2, kèm repo Cydia.

## Cách dùng
1. Upload toàn bộ thư mục này lên một repo GitHub (nhánh `main`).
2. Settings > Actions > General > Workflow permissions > **Read and write permissions**.
3. Tab Actions: chạy workflow "Build and update repo" (hoặc push 1 commit).
4. Settings > Pages > Deploy from a branch > `main` / root.
5. Cydia > Sources > Edit > Add: `https://<user>.github.io/<repo>/`

Tên ivar `_backgroundView` / `_iconImageView` có thể khác trên iPad 2; tweak đã bọc try/catch nên không crash.
Icon app: thêm file 72x72 vào `tweak/layout/Library/Themes/iOS27.theme/Icons/<bundleID>.png`.
