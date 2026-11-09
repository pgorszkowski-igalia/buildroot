################################################################################
#
# libmanette
#
################################################################################

# Patches for each version live in package/libmanette/<LIBMANETTE_VERSION>/.

ifeq ($(BR2_PACKAGE_LIBMANETTE_1_0),y)
# No 1.0 release yet: development snapshot (meson version 1.0.alpha).
LIBMANETTE_VERSION = 006e17b2184a3098a14081d50d2b5303c5cf172c
LIBMANETTE_SITE = https://gitlab.gnome.org/GNOME/libmanette.git
LIBMANETTE_SITE_METHOD = git
LIBMANETTE_SOURCE = libmanette-$(LIBMANETTE_VERSION).tar.gz
else
LIBMANETTE_VERSION_MAJOR = 0.2
ifeq ($(BR2_PACKAGE_LIBMANETTE_0_2_13),y)
LIBMANETTE_VERSION = $(LIBMANETTE_VERSION_MAJOR).13
else
LIBMANETTE_VERSION = $(LIBMANETTE_VERSION_MAJOR).7
endif
LIBMANETTE_SOURCE = libmanette-$(LIBMANETTE_VERSION).tar.xz
LIBMANETTE_SITE = https://download.gnome.org/sources/libmanette/$(LIBMANETTE_VERSION_MAJOR)
endif

LIBMANETTE_LICENSE = LGPL-2.1+
LIBMANETTE_LICENSE_FILES = COPYING
LIBMANETTE_INSTALL_STAGING = YES
LIBMANETTE_DEPENDENCIES = \
	libevdev \
	libglib2 \
	$(TARGET_NLS_DEPENDENCIES)

# 0.2.9+ has a HID backend (Steam Deck) that needs hidapi-hidraw >= 0.13
# (hid_get_device_info(), hid_device_info.bus_type).
ifneq ($(BR2_PACKAGE_LIBMANETTE_0_2_7),y)
LIBMANETTE_DEPENDENCIES += hidapi
endif

LIBMANETTE_LDFLAGS = $(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)

LIBMANETTE_CONF_OPTS = \
	-Ddemos=false \
	-Dbuild-tests=false \
	-Dinstall-tests=false \
	-Ddoc=false \
	-Dvapi=false

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
LIBMANETTE_CONF_OPTS += -Dintrospection=true
LIBMANETTE_DEPENDENCIES += gobject-introspection
else
LIBMANETTE_CONF_OPTS += -Dintrospection=false
endif

ifeq ($(BR2_PACKAGE_LIBGUDEV),y)
LIBMANETTE_CONF_OPTS += -Dgudev=enabled
LIBMANETTE_DEPENDENCIES += libgudev
else
LIBMANETTE_CONF_OPTS += -Dgudev=disabled
endif

$(eval $(meson-package))
