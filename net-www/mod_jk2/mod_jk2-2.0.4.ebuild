# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="An Apache2 DSO providing the JK2 Tomcat connector"
HOMEPAGE="http://jakarta.apache.org/tomcat/tomcat-4.1-doc/jk2/"

SRC_URI="mirror://apache/jakarta/tomcat-connectors/jk2/source/jakarta-tomcat-connectors-jk2-${PV}-src.tar.gz"
DEPEND="
	>=virtual/jdk-1.4 
	>=www-servers/tomcat-4.1 
	>=net-www/apache-2
	dev-libs/libpcre"

LICENSE="Apache-1.1"
KEYWORDS="x86"
IUSE=""
SLOT="0"
S=${WORKDIR}/jakarta-tomcat-connectors-jk2-${PV}-src/jk/native2

detectapache() {
    local domsg=
    [ -n "$1" ] && domsg=1
    HAVE_APACHE1=
    HAVE_APACHE2=
    has_version '=net-www/apache-1*' && HAVE_APACHE1=1
    has_version '=net-www/apache-2*' && HAVE_APACHE2=1

    [ -n "${HAVE_APACHE1}" ] && APACHEVER=1
    [ -n "${HAVE_APACHE2}" ] && APACHEVER=2
    [ -n "${HAVE_APACHE1}" ] && [ -n "${HAVE_APACHE2}" ] && APACHEVER='both'

    case "${APACHEVER}" in
    1) [ -n "${domsg}" ] && einfo 'Apache1 only detected' ;;
    2) [ -n "${domsg}" ] && einfo 'Apache2 only detected';;
    both)
        if [ "`use apache2`" ]; then
            [ -n "${domsg}" ] && einfo "Multiple Apache versions detected, using Apache2 (USE=apache2)"
            APACHEVER=2
        else
            [ -n "${domsg}" ] && einfo 'Multiple Apache versions detected, using Apache1 (USE=-apache2)'
            APACHEVER=1
        fi ;;
    *) if [ -n "${domsg}" ]; then
            MSG="Unknown Apache version!"; eerror $MSG ; die $MSG
       else
            APACHEVER=0
       fi; ;;
    esac
}

src_compile() {

	detectapache

	case "${APACHEVER}" in
    	1) APXS="--with-apxs=`which apxs`" ;;
	    2) APXS="--with-apxs2=`which apxs2`" ;;
	esac

	has_version '=net-www/tomcat-4.0*' && TOMCAT4="--with-tomcat40=/opt/tomcat"
	has_version '=net-www/tomcat-4.1*' && TOMCAT4="--with-tomcat41=/opt/tomcat"

	# JNI support in JK2 requires APR, which is provded in Apache 2.0
	[ -n "${HAVE_APACHE2}" ] && JNI="--with-jni"
	
	myconf="${APXS} \
		${TOMCAT4} \
		${JNI} \
		--with-java-home=$JAVA_HOME \
		--with-pcre"

	cd ${S} || die
	sh buildconf.sh || die
	econf ${myconf} || die "configure failed"
	emake || die "problem compiling mod_jk2"
}

src_install() {
	cd ${S} || die
	
	#copy jkjni.so mod_jk2.so mods to extramodules
	dodir /usr/lib/apache2-extramodules
	cp ../build/jk2/apache2/*.so ${D}/usr/lib/apache2-extramodules

	# install apache directive to load mod jk2
	insinto /etc/apache2/conf/modules.d
	doins ${FILESDIR}/105_mod_jk2.conf

	# copy basic workers2.properties file
	insinto /etc/apache2/conf
	doins ${FILESDIR}/workers2.properties

}

pkg_postinst() {
	einfo
	einfo "Please add \"-D JK2\" to your /etc/conf.d/apache2 file to"
	einfo "allow apache2 to recognize and load the mod_jk2 module."
	einfo
	einfo "A basic workers2.properties file has been created in"
	einfo "/etc/apache2/conf/.  Modify it before loding mod_jk2."
	einfo
}
