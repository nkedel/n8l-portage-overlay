# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# ebuild by mobidyc@msn.com
# based on the ebuild from bearingspacer@free.fr

DESCRIPTION="A utility to find and clean various forms of lint on a filesystem."
HOMEPAGE="http://www.pixelbeat.org/fslint/"
SRC_URI="http://www.pixelbeat.org/fslint/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""

DEPEND=">=dev-lang/python-2.0"

RDEPEND="${DEPEND}"

src_unpack() {
	if [ "${A}" != "" ]; then
		unpack ${A}
	fi
}

src_install() {
	echo ${S}
	pwd

# GUI executable
	dodir /usr/X11R6/bin
	exeinto /usr/X11R6/bin
	doexe fslint-gui

# GUI file
	dodir /usr/share/fslint
	insinto /usr/share/fslint
	doins fslint.glade

# other executables
	dodir /usr/share/fslint/bin
	exeinto /usr/share/fslint/bin
	doexe fslint/find* fslint/zipdir fslint/fslint

	dodir /usr/share/fslint/bin/fstool
	exeinto /usr/share/fslint/bin/fstool
	doexe fslint/fstool/*

	dodir /usr/share/fslint/bin/supprt
	exeinto /usr/share/fslint/bin/supprt
	doexe fslint/supprt/get* fslint/supprt/fslver fslint/supprt/md5sum_approx

	dodir /usr/share/fslint/bin/supprt/rmlint
	exeinto /usr/share/fslint/bin/supprt/rmlint
	doexe fslint/supprt/rmlint/*

# icon
	dodir /usr/share/pixmaps
	insinto /usr/share/pixmaps
	doins fslint_icon.png

# shortcut
	dodir /etc/X11/applnk/System
	insinto /etc/X11/applnk/System
	doins fslint.desktop

# locales
	cd po
	emake DESTDIR=${D}/usr DATADIR=share install
	cd ..

# docs
	cd doc
	dodoc FAQ NEWS README TODO
	cd ..

	cd man
	doman fslint-gui.1 fslint.1
	cd ..

# create python init file
# Other option here is to instead edit fslint-gui itself so that:
#   ^liblocation = '/usr/share/fslint/'
#   ^locale_base = None
	python_site=`python -c "import sys ; \
		print '%s/lib/python%s/site-packages' % (sys.exec_prefix,sys.version[:3])"`
	dodir $python_site/fslint
	echo "liblocation = '/usr/share/fslint/'" > ${D}/$python_site/fslint/__init__.py

# link to icon in main fslint dir
	dosym /usr/share/pixmaps/fslint_icon.png /usr/share/fslint/fslint_icon.png
}

pkg_postinst() {
	einfo "Note the fslint tools do a lot of inode access and to speed them"
	einfo "up you can use the following method to not update access times"
	einfo "on disk while gathering inode information:"
	einfo "mount -o remount,noatime mountpoint"
	einfo "fslint or fslint-gui"
	einfo "mount -o remount,atime mountpoint"
	einfo ""
	einfo "Command Line Executables are installed in:"
	einfo "/usr/share/fslint/bin"
	einfo "you may want to add them in your PATH."
}
