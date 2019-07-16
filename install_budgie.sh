#!/usr/bin/env sh

set -e

git clone https://github.com/solus-project/budgie-desktop
cd budgie-desktop
git checkout 10.5
git submodule update --init

sudo pkg install \
	accountsservice \
	alsa-lib \
	glib \
	gnome-desktop \
	gnome-settings-daemon \
	gobject-introspection \
	gtk3 \
	ibus \
	libgnome \
	libnotify \
	libpeas \
	pulseaudio \
	libwnck3 \
	meson \
	mutter \
	polkit \
	upower \
	pkgconf \
	vala \
	gtk-doc \
	sassc \
	cmake \
	e2fsprogs-libuuid \
	gettext \
	gnome-menus \
	intltool

sed -i '' -e "s/'-Werror-implicit-function-declaration',//g" meson.build
#sed -i '' -e 's/UUIDFlags.TIME_SAFE_TYPE/UUIDFlags.TIME_TYPE/g' src/panel/panel.vala
sed -i '' -e 's/LibUUID.generate_time_safe/LibUUID.generate_time/g' src/panel/uuid.vala
meson build --prefix=/usr --sysconfdir=/etc -Dwith-bluetooth=false
ninja -j$(($(getconf _NPROCESSORS_ONLN)+1)) -C build
sudo ninja install -C build
