ARCHS = armv7
TARGET = iphone:clang:9.3:6.0
INSTALL_TARGET_PROCESSES = SpringBoard
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iOS27IPad2
iOS27IPad2_FILES = Tweak.xm
iOS27IPad2_FRAMEWORKS = UIKit QuartzCore CoreGraphics
iOS27IPad2_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
