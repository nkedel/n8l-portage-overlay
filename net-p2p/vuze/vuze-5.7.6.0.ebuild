# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="source"

inherit eutils fdo-mime java-pkg-2 java-ant-2 versionator

MY_PV=$(replace_all_version_separators "")
MY_SRC="Vuze_${MY_PV}"

DESCRIPTION="BitTorrent client in Java, formerly called Azureus"
HOMEPAGE="http://www.vuze.com/"
SRC_URI="mirror://sourceforge/azureus/${PN}/${MY_SRC}/${MY_SRC}_source.zip"
LICENSE="GPL-2 BSD"

SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

# bundles parts of http://www.programmers-friend.org/
# bundles bcprov - 1.37 required but not in the tree
RDEPEND="
	dev-java/commons-cli:1
	dev-java/commons-lang:2.1
	dev-java/json-simple:0
	dev-java/log4j:0
	dev-java/swt:4.7[cairo]
	>=virtual/jre-1.8:1.8"

DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/desktop-file-utils
	>=virtual/jdk-1.8:1.8"

PDEPEND="~net-p2p/vuze-coreplugins-${PV}"

src_unpack() {
	mkdir -p "${S}" && cd "${S}"
	unpack ${A}

	# build.xml disappeared from 4.4.0.0 although it was there in 4.3.1.4
	[[ -f build.xml ]] && die "upstream has build.xml again, don't overwrite"
	cp "${FILESDIR}"/build.xml "${S}" || die "failed to copy build.xml"
}

java_prepare() {
	# upstream likes randomly changing a subset of files to CRLF every release
	edos2unix $(find "${S}" -type f -name "*.java")

	epatch "${FILESDIR}"/${PN}-5.3.0.0-java5.patch
	epatch "${FILESDIR}"/${PN}-5.3.0.0-remove-classpath.patch
	epatch "${FILESDIR}"/${PN}-5.3.0.0-disable-shared-plugins.patch
	epatch "${FILESDIR}"/${PN}-5.7.2.0-disable-osx.patch
	epatch "${FILESDIR}"/${PN}-5.3.0.0-disable-updaters.patch
	epatch "${FILESDIR}"/${PN}-5.3.0.0-unbundle-commons.patch
	epatch "${FILESDIR}"/${PN}-5.3.0.0-unbundle-json.patch
	epatch "${FILESDIR}"/${PN}-5.6.0.0-commons-lang-entities.patch
#	epatch "${FILESDIR}"/${PN}-5.6.0.0-invalid-characters.patch
        epatch "${FILESDIR}"/disable-donation-nags.patch
#	epatch "${FILESDIR}"/${P}-use-jdk-cipher-only.patch # bcprov

        # remove donation nag
	rm "${S}"/org/gudy/azureus2/ui/swt/donations/DonationWindow.java

        # Non-US languages
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_ar_SA.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_ko_KR.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_bg_BG.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_li_NL.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_bs_BA.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_lt_LT.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_ca_AD.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_mk_MK.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_cs_CZ.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_ms_SG.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_da_DK.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_nl_NL.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_de_DE.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_no_NO.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_el_GR.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_oc.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_en_GB.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_pl_PL.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_es_ES.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_pt_BR.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_eu.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_pt_PT.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_fi_FI.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_ro_RO.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_fr_FR.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_ru_RU.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_fy_NL.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_sk_SK.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_gl_ES.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_sl_SI.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_hu_HU.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_sr_Latin.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_hy_AM.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_sr.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_in_ID.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_sv_SE.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_it_IT.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_th_TH.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_iw_IL.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_tr_TR.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_ja_JP.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_uk_UA.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_ka_GE.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_zh_CN.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_km_KH.properties
        rm "${S}"/org/gudy/azureus2/internat/MessagesBundle_zh_TW.properties

	# OSX / Windows
	rm "${S}"/org/gudy/azureus2/ui/swt/osx/CarbonUIEnhancer.java
	rm "${S}"/org/gudy/azureus2/ui/swt/osx/Start.java
	rm "${S}"/org/gudy/azureus2/ui/swt/win32/Win32UIEnhancer.java

	# Tree2 file does not compile on linux
#	rm -rf "${S}"/org/eclipse || die
	# Bundled apache
	rm -rf "${S}"/org/apache || die
	# Bundled json
	rm -rf "${S}"/org/json || die
	# Bundled bcprov
	# currently disabled - requires bcprov 1.37
	#rm -rf "${S}"/org/bouncycastle || die

	rm -rf "${S}"/org/gudy/azureus2/ui/console/multiuser/TestUserManager.java || die
	mkdir -p "${S}"/build/libs || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="swt-4.7,json-simple,log4j,commons-cli-1 commons-lang-2.1"

src_compile() {
	local mem
	export ANT_OPTS="-Xmx512m"
	java-pkg-2_src_compile

	# bug #302058 - build.xml excludes .txt but upstream jar has it...
	jar uf dist/Azureus2.jar ChangeLog.txt || die
}

src_install() {
	java-pkg_dojar dist/Azureus2.jar
	dodoc ChangeLog.txt

	java-pkg_dolauncher "${PN}" \
		--main org.gudy.azureus2.ui.common.Main -pre "${FILESDIR}/${PN}-4.1.0.0-pre" \
		--java_args '-Dazureus.install.path=/usr/share/vuze/ ${JAVA_OPTIONS}' \
		--pkg_args '--ui=${UI}'
	dosym vuze /usr/bin/azureus

	# https://bugs.gentoo.org/show_bug.cgi?id=204132
#	java-pkg_register-environment-variable MOZ_PLUGIN_PATH /usr/lib/nsbrowser/plugins

	newicon "${S}"/org/gudy/azureus2/ui/icons/a32.png vuze.png
	domenu "${FILESDIR}"/${PN}.desktop

	use source && java-pkg_dosrc "${S}"/{com,edu,org}
}

pkg_postinst() {
	ewarn "Running Vuze as root is not supported and may result in untracked"
	ewarn "updates to shared components and then collisions on updates"
	echo
	elog "Vuze was formerly called Azureus and many references to the old name remain."
	elog
	elog "After running Vuze for the first time, configuration options will be"
	elog "placed in '~/.azureus/gentoo.config'."
	elog
	elog "If you need to change some startup options, you should modify this file"
	elog "rather than the startup script.  You can enable the console UI by"
	elog "editing this config file."
	echo
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
