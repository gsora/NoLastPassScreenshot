TARGET := iphone:8.4:7.0
ARCHS := armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = NoLastPassScreenshot
NoLastPassScreenshot_FILES = Tweak.xm
NoLastPassScreenshot_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
