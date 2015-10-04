
# Maintainer: Bernhard Landauer <oberon@manjaro.org>
# Maintainer: Chrysostomus

pkgname=lemonpanel
_ver=0.6
pkgver=0.6.r64.91e6036
pkgrel=1
pkgdesc="Panel script for bspwm using patched dmenu and lemonbar"
arch=any
url=https://github.com/Chrysostomus/lemonpanel
license=MIT
depends=('dmenu-manjaro'
	'lemonbar-xft-clicky'
	'xdotool'
	'wmctrl'
	'pulseaudio-ctl'
	'rxvt-unicode'
	'networkmanager-dmenu'
	'conky-cli'
	'xorg-xdpyinfo'
	'xtitle'
	'ttf-dejavu-sans-mono-powerline'
	'bdf-zevv-peep'
	'ttf-ionicons'
	'zenity'
	'xdg-utils')
makedepends=git
source="git://github.com/Chrysostomus/lemonpanel"
md5sums=('SKIP')

pkgver() {
	cd $pkgname
	printf "$_ver.r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package () {
	cd $srcdir
	install -Dm755 $srcdir/$pkgname/lemonpanel $pkgdir/usr/bin/lemonpanel
	cp -r $srcdir/$pkgname/bin $pkgdir/usr
	chmod a+x $pkgdir/usr/bin/*
}
