# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools eutils

SLOT="3"
MY_PN="${PN}${SLOT}"

DESCRIPTION="Gambas is a free development environment based on a Basic interpreter with object extensions"
HOMEPAGE="http://gambas.sourceforge.net"

SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL2"
KEYWORDS="*"

IUSE="bzip2 zlib mysql odbc postgresql sqlite2 sqlite3 net curl mime pcre sdl sdlsound libxml xml v4l crypt qt4
	gtk gtk3 opengl x11 keyring pdf cairo imageio imageimlib dbus gsl gmp ncurses media jit httpd opessl openal"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	for useflags in ${IUSE} ; do
		if ! use_if_iuse ${useflags} ; then
			sed -i -e "/^\(AC\|GB\)_CONFIG_SUBDIRS(${useflags}[,)]/d" \
				"${S}/configure.ac" || die
			sed -i -e "/^ \(@${useflags}_dir@\|${useflags}\)/d" \
				"${S}/Makefile.am" || die
		fi
	done

	eautoreconf
}

src_configure() {
	econf "$(use_enable bzlib2)
		$(use_enable zlib)
		$(use_enable mysql)
		$(use_enable odbc)
		$(use_enable postgresql)
		$(use_enable sqlite2)
		$(use_enable sqlite3)
		$(use_enable net)
		$(use_enable curl)
		$(use_enable mime)
		$(use_enable pcre)
		$(use_enable sdl)
		$(use_enable sdlsound)
		$(use_enable libxml)
		$(use_enable xml)
		$(use_enable v4l)
		$(use_enable crypt)
		$(use_enable qt4)
		$(use_enable gtk)
		$(use_enable gtk3)
		$(use_enable opengl)
		$(use_enable x11)
		$(use_enable keyring)
		$(use_enable pdf)
		$(use_enable cairo)
		$(use_enable imageio)
		$(use_enable imageimlib)
		$(use_enable dbus)
		$(use_enable gsl)
		$(use_enable gmp)
		$(use_enable ncurses)
		$(use_enable media)
		$(use_enable jit)
		$(use_enable httpd)
		$(use_enable openssl)
		$(use_enable openal)"
}
