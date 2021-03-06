# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nntp/tin/tin-1.7.8.ebuild,v 1.1 2005/05/16 17:01:25 swegener Exp $

inherit eutils versionator

DESCRIPTION="A threaded NNTP and spool based UseNet newsreader"
HOMEPAGE="http://www.tin.org/"
SRC_URI="ftp://ftp.tin.org/pub/news/clients/tin/v$(get_version_component_range 1-2)/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~arm ~amd64 ~ia64 ~ppc-macos"
IUSE="crypt debug ipv6 ncurses nls X"

DEPEND="ncurses? ( sys-libs/ncurses )
	X? ( virtual/x11 )
	nls? ( sys-devel/gettext )
	crypt? ( app-crypt/gnupg )"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	local myconf=""
	econf \
		--verbose \
		--with-domain-name=sfchat.org \
		--with-nntp-default-server=localhost \
		--with-ispell=/usr/bin/ispell \
		--with-metamail=/usr/bin/metamail \
		--with-editor=/usr/bin/joe \
		--with-mailer=/usr/bin/mutt \
		--with-shell=/bin/bash \
		--enable-nntp-only \
		--enable-prototypes \
		--disable-echo \
		--disable-mime-strict-charset \
		--with-coffee  \
		$(use_enable ncurses curses) \
		$(use_with ncurses) \
		$(use_enable ipv6) \
		$(use_enable debug) \
		$(use_with X x) \
		$(use_enable crypt pgp-gpg) \
		$(use_enable nls) \
		${myconf} || die "econf failed"
	emake build || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc doc/{CHANGES{,.old},CREDITS,TODO,WHATSNEW,*.sample,*.txt} || die "dodoc failed"
	insinto /etc/tin
	doins doc/tin.defaults || die "doins failed"
}
