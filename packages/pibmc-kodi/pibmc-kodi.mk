################################################################################
#
# kodi
#
################################################################################

# When updating the version, please also update kodi-jsonschemabuilder
# and kodi-texturepacker
PIBMC_KODI_VERSION = 17.3-Krypton
PIBMC_KODI_SITE = $(call github,xbmc,xbmc,$(PIBMC_KODI_VERSION))
PIBMC_KODI_LICENSE = GPL-2.0
PIBMC_KODI_LICENSE_FILES = LICENSE.GPL
# needed for binary addons
PIBMC_KODI_INSTALL_STAGING = YES
PIBMC_KODI_DEPENDENCIES = \
	bzip2 \
	expat \
	ffmpeg \
	fontconfig \
	freetype \
	host-gawk \
	host-gperf \
	host-kodi-jsonschemabuilder \
	host-kodi-texturepacker \
	host-nasm \
	host-swig \
	host-xmlstarlet \
	host-zip \
	libass \
	libcdio \
	libcrossguid \
	libcurl \
	libfribidi \
	libplist \
	libsamplerate \
	lzo \
	ncurses \
	openssl \
	pcre \
	python \
	readline \
	sqlite \
	taglib \
	tinyxml \
	yajl \
	zlib

PIBMC_KODI_SUBDIR = project/cmake

PIBMC_KODI_LIBDVDCSS_VERSION = 2f12236
PIBMC_KODI_LIBDVDNAV_VERSION = 981488f
PIBMC_KODI_LIBDVDREAD_VERSION = 17d99db

PIBMC_KODI_EXTRA_DOWNLOADS = \
	https://github.com/xbmc/libdvdcss/archive/$(PIBMC_KODI_LIBDVDCSS_VERSION).tar.gz \
	https://github.com/xbmc/libdvdnav/archive/$(PIBMC_KODI_LIBDVDNAV_VERSION).tar.gz \
	https://github.com/xbmc/libdvdread/archive/$(PIBMC_KODI_LIBDVDREAD_VERSION).tar.gz

PIBMC_KODI_CONF_OPTS += \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) $(PIBMC_KODI_C_FLAGS)" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) $(PIBMC_KODI_CXX_FLAGS)" \
	-DENABLE_CCACHE=OFF \
	-DENABLE_DVDCSS=ON \
	-DENABLE_INTERNAL_CROSSGUID=OFF \
	-DENABLE_INTERNAL_FFMPEG=OFF \
	-DPIBMC_KODI_DEPENDSBUILD=OFF \
	-DENABLE_OPENSSL=ON \
	-DNATIVEPREFIX=$(HOST_DIR) \
	-DDEPENDS_PATH=$(@D) \
	-DWITH_TEXTUREPACKER=$(HOST_DIR)/bin/TexturePacker \
	-DLIBDVDCSS_URL=$(DL_DIR)/$(PIBMC_KODI_LIBDVDCSS_VERSION).tar.gz \
	-DLIBDVDNAV_URL=$(DL_DIR)/$(PIBMC_KODI_LIBDVDNAV_VERSION).tar.gz \
	-DLIBDVDREAD_URL=$(DL_DIR)/$(PIBMC_KODI_LIBDVDREAD_VERSION).tar.gz

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
PIBMC_KODI_CONF_OPTS += -DCORE_SYSTEM_NAME=rbpi
PIBMC_KODI_DEPENDENCIES += rpi-userland
# These CPU-specific options are only used on rbpi:
# https://github.com/xbmc/xbmc/blob/Krypton/project/cmake/scripts/rbpi/ArchSetup.cmake#L13
ifeq ($(BR2_arm1176jzf_s)$(BR2_cortex_a7)$(BR2_cortex_a53),y)
PIBMC_KODI_CONF_OPTS += -DWITH_CPU=$(BR2_GCC_TARGET_CPU)
endif
else
ifeq ($(BR2_arceb)$(BR2_arcle),y)
PIBMC_KODI_CONF_OPTS += -DWITH_ARCH=arc -DWITH_CPU=arc
else ifeq ($(BR2_armeb),y)
PIBMC_KODI_CONF_OPTS += -DWITH_ARCH=arm -DWITH_CPU=arm
else ifeq ($(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
PIBMC_KODI_CONF_OPTS += \
	-DWITH_ARCH=mips$(if $(BR2_ARCH_IS_64),64) \
	-DWITH_CPU=mips$(if $(BR2_ARCH_IS_64),64)
else ifeq ($(BR2_powerpc)$(BR2_powerpc64le),y)
PIBMC_KODI_CONF_OPTS += \
	-DWITH_ARCH=powerpc$(if $(BR2_ARCH_IS_64),64) \
	-DWITH_CPU=powerpc$(if $(BR2_ARCH_IS_64),64)
else ifeq ($(BR2_powerpc64)$(BR2_sparc64)$(BR2_sh4)$(BR2_xtensa),y)
PIBMC_KODI_CONF_OPTS += -DWITH_ARCH=$(BR2_ARCH) -DWITH_CPU=$(BR2_ARCH)
else
# Kodi auto-detects ARCH, tested: arm, aarch64, i386, x86_64
# see project/cmake/scripts/linux/ArchSetup.cmake
PIBMC_KODI_CONF_OPTS += -DWITH_CPU=$(BR2_ARCH)
endif
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
PIBMC_KODI_CONF_OPTS += -D_SSE_OK=ON -D_SSE_TRUE=ON
else
PIBMC_KODI_CONF_OPTS += -D_SSE_OK=OFF -D_SSE_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_SSE2),y)
PIBMC_KODI_CONF_OPTS += -D_SSE2_OK=ON -D_SSE2_TRUE=ON
else
PIBMC_KODI_CONF_OPTS += -D_SSE2_OK=OFF -D_SSE2_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_SSE3),y)
PIBMC_KODI_CONF_OPTS += -D_SSE3_OK=ON -D_SSE3_TRUE=ON
else
PIBMC_KODI_CONF_OPTS += -D_SSE3_OK=OFF -D_SSE3_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_SSSE3),y)
PIBMC_KODI_CONF_OPTS += -D_SSSE3_OK=ON -D_SSSE3_TRUE=ON
else
PIBMC_KODI_CONF_OPTS += -D_SSSE3_OK=OFF -D_SSSE3_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_SSE4),y)
PIBMC_KODI_CONF_OPTS += -D_SSE41_OK=ON -D_SSE41_TRUE=ON
else
PIBMC_KODI_CONF_OPTS += -D_SSE41_OK=OFF -D_SSE41_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_SSE42),y)
PIBMC_KODI_CONF_OPTS += -D_SSE42_OK=ON -D_SSE42_TRUE=ON
else
PIBMC_KODI_CONF_OPTS += -D_SSE42_OK=OFF -D_SSE42_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_AVX),y)
PIBMC_KODI_CONF_OPTS += -D_AVX_OK=ON -D_AVX_TRUE=ON
else
PIBMC_KODI_CONF_OPTS += -D_AVX_OK=OFF -D_AVX_TRUE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_AVX2),y)
PIBMC_KODI_CONF_OPTS += -D_AVX2_OK=ON -D_AVX2_TRUE=ON
else
PIBMC_KODI_CONF_OPTS += -D_AVX2_OK=OFF -D_AVX2_TRUE=OFF
endif

# mips: uses __atomic_load_8
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
PIBMC_KODI_CXX_FLAGS += -latomic
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_MYSQL),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_MYSQLCLIENT=ON
PIBMC_KODI_DEPENDENCIES += mysql
else
PIBMC_KODI_CONF_OPTS += -DENABLE_MYSQLCLIENT=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_NONFREE),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_NONFREE=ON
PIBMC_KODI_LICENSE := $(PIBMC_KODI_LICENSE), unrar
PIBMC_KODI_LICENSE_FILES += lib/UnrarXLib/license.txt
else
PIBMC_KODI_CONF_OPTS += -DENABLE_NONFREE=OFF
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
PIBMC_KODI_CONF_OPTS += -DCORE_SYSTEM_NAME=rbpi
PIBMC_KODI_DEPENDENCIES += rpi-userland
else
# Kodi considers "rpbi" and "linux" as two separate platforms. The
# below options, defined in
# project/cmake/scripts/linux/ArchSetup.cmake are only valid for the
# "linux" platforms. The "rpbi" platform has a different set of
# options, defined in project/cmake/scripts/rbpi/
PIBMC_KODI_CONF_OPTS += -DENABLE_LDGOLD=OFF
ifeq ($(BR2_PACKAGE_LIBAMCODEC),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_AML=ON
PIBMC_KODI_DEPENDENCIES += libamcodec
else
PIBMC_KODI_CONF_OPTS += -DENABLE_AML=OFF
endif
ifeq ($(BR2_PACKAGE_IMX_VPUWRAP),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_IMX=ON
PIBMC_KODI_DEPENDENCIES += imx-vpuwrap
else
PIBMC_KODI_CONF_OPTS += -DENABLE_IMX=OFF
endif
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_UDEV=ON
PIBMC_KODI_DEPENDENCIES += udev
else
PIBMC_KODI_CONF_OPTS += -DENABLE_UDEV=OFF
ifeq ($(BR2_PACKAGE_PIBMC_KODI_LIBUSB),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_LIBUSB=ON
PIBMC_KODI_DEPENDENCIES += libusb-compat
endif
endif

ifeq ($(BR2_PACKAGE_UPOWER),y)
PIBMC_KODI_DEPENDENCIES += upower
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_CAP=ON
PIBMC_KODI_DEPENDENCIES += libcap
else
PIBMC_KODI_CONF_OPTS += -DENABLE_CAP=OFF
endif

ifeq ($(BR2_PACKAGE_LIBXML2)$(BR2_PACKAGE_LIBXSLT),yy)
PIBMC_KODI_CONF_OPTS += -DENABLE_XSLT=ON
PIBMC_KODI_DEPENDENCIES += libxml2 libxslt
else
PIBMC_KODI_CONF_OPTS += -DENABLE_XSLT=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_BLUEZ),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_BLUETOOTH=ON
PIBMC_KODI_DEPENDENCIES += bluez5_utils
else
PIBMC_KODI_CONF_OPTS += -DENABLE_BLUETOOTH=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_DBUS),y)
PIBMC_KODI_DEPENDENCIES += dbus
PIBMC_KODI_CONF_OPTS += -DENABLE_DBUS=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_DBUS=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_EVENTCLIENTS),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_EVENTCLIENTS=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_EVENTCLIENTS=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_ALSA_LIB),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_ALSA=ON
PIBMC_KODI_DEPENDENCIES += alsa-lib
else
PIBMC_KODI_CONF_OPTS += -DENABLE_ALSA=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_GL_EGL),y)
PIBMC_KODI_DEPENDENCIES += libegl libglu libgl xlib_libX11 xlib_libXext \
	xlib_libXrandr libdrm
PIBMC_KODI_CONF_OPTS += -DENABLE_OPENGL=ON -DENABLE_X11=ON -DENABLE_OPENGLES=OFF
else
PIBMC_KODI_CONF_OPTS += -DENABLE_OPENGL=OFF -DENABLE_X11=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_EGL_GLES),y)
PIBMC_KODI_DEPENDENCIES += libegl libgles
PIBMC_KODI_CONF_OPTS += \
	-DENABLE_OPENGLES=ON
PIBMC_KODI_C_FLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags --libs egl`
PIBMC_KODI_CXX_FLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags --libs egl`
else
PIBMC_KODI_CONF_OPTS += -DENABLE_OPENGLES=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_LIBMICROHTTPD),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_MICROHTTPD=ON
PIBMC_KODI_DEPENDENCIES += libmicrohttpd
else
PIBMC_KODI_CONF_OPTS += -DENABLE_MICROHTTPD=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_LIBSMBCLIENT),y)
PIBMC_KODI_DEPENDENCIES += samba4
PIBMC_KODI_CONF_OPTS += -DENABLE_SMBCLIENT=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_SMBCLIENT=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_LIBNFS),y)
PIBMC_KODI_DEPENDENCIES += libnfs
PIBMC_KODI_CONF_OPTS += -DENABLE_NFS=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_NFS=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_LIBBLURAY),y)
PIBMC_KODI_DEPENDENCIES += libbluray
PIBMC_KODI_CONF_OPTS += -DENABLE_BLURAY=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_BLURAY=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_LIBSHAIRPLAY),y)
PIBMC_KODI_DEPENDENCIES += libshairplay
PIBMC_KODI_CONF_OPTS += -DENABLE_AIRTUNES=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_AIRTUNES=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_LIBSSH),y)
PIBMC_KODI_DEPENDENCIES += libssh
PIBMC_KODI_CONF_OPTS += -DENABLE_SSH=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_SSH=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_AVAHI),y)
PIBMC_KODI_DEPENDENCIES += avahi
PIBMC_KODI_CONF_OPTS += -DENABLE_AVAHI=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_AVAHI=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_LIBCEC),y)
PIBMC_KODI_DEPENDENCIES += libcec
PIBMC_KODI_CONF_OPTS += -DENABLE_CEC=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_CEC=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_LCMS2),y)
PIBMC_KODI_DEPENDENCIES += lcms2
PIBMC_KODI_CONF_OPTS += -DENABLE_LCMS2=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_LCMS2=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_LIRC),y)
PIBMC_KODI_DEPENDENCIES += lirc-tools
PIBMC_KODI_CONF_OPTS += -DENABLE_LIRC=ON -DHAVE_LIRC=1
else
PIBMC_KODI_CONF_OPTS += -DENABLE_LIRC=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_LIBTHEORA),y)
PIBMC_KODI_DEPENDENCIES += libtheora
endif

# kodi needs libva & libva-glx
ifeq ($(BR2_PACKAGE_PIBMC_KODI_LIBVA)$(BR2_PACKAGE_MESA3D_DRI_DRIVER),yy)
PIBMC_KODI_DEPENDENCIES += mesa3d libva
PIBMC_KODI_CONF_OPTS += -DENABLE_VAAPI=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_VAAPI=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_LIBVDPAU),y)
PIBMC_KODI_DEPENDENCIES += libvdpau
PIBMC_KODI_CONF_OPTS += -DENABLE_VDPAU=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_VDPAU=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_UPNP),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_UPNP=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_UPNP=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_OPTICALDRIVE),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_OPTICAL=ON
else
PIBMC_KODI_CONF_OPTS += -DENABLE_OPTICAL=OFF
endif

ifeq ($(BR2_PACKAGE_PIBMC_KODI_PULSEAUDIO),y)
PIBMC_KODI_CONF_OPTS += -DENABLE_PULSEAUDIO=ON
PIBMC_KODI_DEPENDENCIES += pulseaudio
else
PIBMC_KODI_CONF_OPTS += -DENABLE_PULSEAUDIO=OFF
endif

# Remove versioncheck addon, updating Kodi is done by building a new
# buildroot image.
PIBMC_KODI_ADDON_MANIFEST = $(TARGET_DIR)/usr/share/kodi/system/addon-manifest.xml
define PIBMC_KODI_CLEAN_UNUSED_ADDONS
	rm -Rf $(TARGET_DIR)/usr/share/kodi/addons/service.xbmc.versioncheck
	$(HOST_DIR)/bin/xml ed -L \
		-d "/addons/addon[text()='service.xbmc.versioncheck']" \
		$(PIBMC_KODI_ADDON_MANIFEST)
endef
PIBMC_KODI_POST_INSTALL_TARGET_HOOKS += PIBMC_KODI_CLEAN_UNUSED_ADDONS

define PIBMC_KODI_INSTALL_BR_WRAPPER
	$(INSTALL) -D -m 0755 package/pibmc-kodi/br-kodi \
		$(TARGET_DIR)/usr/bin/br-kodi
endef
PIBMC_KODI_POST_INSTALL_TARGET_HOOKS += PIBMC_KODI_INSTALL_BR_WRAPPER

# When run from a startup script, Kodi has no $HOME where to store its
# configuration, so ends up storing it in /.kodi  (yes, at the root of
# the rootfs). This is a problem for read-only filesystems. But we can't
# easily change that, so create /.kodi as a symlink where we want the
# config to eventually be. Add synlinks for the legacy XBMC name as well
define PIBMC_KODI_INSTALL_CONFIG_DIR
	# $(INSTALL) -d -m 0755 $(TARGET_DIR)/var/kodi
	# ln -sf /var/kodi $(TARGET_DIR)/.kodi
	# ln -sf /var/kodi $(TARGET_DIR)/var/xbmc
	# ln -sf /var/kodi $(TARGET_DIR)/.xbmc
endef
PIBMC_KODI_POST_INSTALL_TARGET_HOOKS += PIBMC_KODI_INSTALL_CONFIG_DIR

define PIBMC_KODI_INSTALL_INIT_SYSV
        $(INSTALL) -d -m 0755 $(TARGET_DIR)/var/kodi

        ln -sf /var/kodi $(TARGET_DIR)/.kodi
        ln -sf /var/kodi $(TARGET_DIR)/var/xbmc
        ln -sf /var/kodi $(TARGET_DIR)/.xbmc

	$(INSTALL) -D -m 755 package/pibmc-kodi/S50kodi \
		$(TARGET_DIR)/etc/init.d/S50kodi
endef

define PIBMC_KODI_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/pibmc-kodi/kodi.service \
		$(TARGET_DIR)/usr/lib/systemd/system/kodi.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -fs ../../../../usr/lib/systemd/system/kodi.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/kodi.service
endef

$(eval $(cmake-package))
