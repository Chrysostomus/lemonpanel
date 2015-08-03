# Contributor: Chrysostomus


pkgname=lemonpanel
_pkgname=lemonpanel
pkgver=0.1
pkgrel=1
pkgdesc="Panel script for bspwm using patched dmenu and lemonbar"
arch=(any)
url="https://github.com/Chrysostomus/lemonpanel"
license=("MIT")
depends=('dmenu-manjaro' 'lemonbar-xft-clicky-git' 'xdotool' 'wmctrl' 'pulseaudio-ctl' 'rxvt-unicode' 'networkmanager-dmenu-git' 'conky-cli' 'xorg-xdpyinfo' 'xtitle')
optdepends=('bspwm' 'bspwm-scripts')
makedepends=("git")
l=$_pkgname.install
source=(git://github.com/Chrysostomus/lemonpanel)
md5sums=('SKIP')


pkgver() {
  cd "$_pkgname"
  git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/v//'
}


# vim:set ts=2 sw=2 et:
package () {
    cd "$srcdir"
    install -d -m755 "$pkgdir/usr/bin"
    install -m755 "$srcdir/$pkgname/lemonpanel" "$pkgdir/usr/bin/lemonpanel"
	install -m755 "$srcdir/$pkgname/bspwm-menu" "$pkgdir/usr/bin/bspwm-menu"
	install -m755 "$srcdir/$pkgname/BspwmDesktopMenu" "$pkgdir/usr/bin/BspwmDesktopMenu"
	install -m755 "$srcdir/$pkgname/BspwmWindowMenu" "$pkgdir/usr/bin/BspwmWindowMenu"
	install -m755 "$srcdir/$pkgname/dbright" "$pkgdir/usr/bin/dbright"
	install -m755 "$srcdir/$pkgname/dlogoutmenu" "$pkgdir/usr/bin/dlogoutmenu"
	install -m755 "$srcdir/$pkgname/dmainmenu.sh" "$pkgdir/usr/bin/dmainmenu.sh"
	install -m755 "$srcdir/$pkgname/dvol" "$pkgdir/usr/bin/dvol"
	install -m755 "$srcdir/$pkgname/panel_bar" "$pkgdir/usr/bin/panel_bar"
	install -m755 "$srcdir/$pkgname/networkmenuplacer.sh" "$pkgdir/usr/bin/networkmenuplacer.sh"
	install -m755 "$srcdir/$pkgname/dmouse" "$pkgdir/usr/bin/dmouse"
	install -m755 "$srcdir/$pkgname/MonocleSwitcher" "$pkgdir/usr/bin/MonocleSwitcher"
	install -m755 "$srcdir/$pkgname/terminal" "$pkgdir/usr/bin/terminal"
	install -m755 "$srcdir/$pkgname/volume" "$pkgdir/usr/bin/volume"
	install -m755 "$srcdir/$pkgname/volume_status.sh" "$pkgdir/usr/bin/volume_status.sh"
}
