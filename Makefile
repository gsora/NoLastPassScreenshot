TARGET := iphone:8.4:7.0
ARCHS := armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = NoLastPassScreenshot
NoLastPassScreenshot_FILES = Tweak.xm
NoLastPassScreenshot_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp -R Resources $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NoLastPassScreenshot$(ECHO_END)
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) -name .DS_Store | xargs rm -rf$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
