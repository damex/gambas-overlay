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

IUSE="bzip2 mysql postgres  zlib odbc sqlite net curl mime pcre sdl sdlsound libxml xml v4l crypt qt4
	gtk gtk3 opengl x11 keyring pdf cairo imageio imageimlib dbus gsl gmp ncurses media jit httpd openssl openal"

RDEPEND="bzip2? ( app-arch/bzip2 )
	curl? ( net-misc/curl )
	gtk? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	mysql?  ( virtual/mysql )
	postgres? ( virtual/postgresql-base )
	qt4? ( x11-libs/qt:4 )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

autocrap_cleanup() {
	sed -i -e "/^\(AC\|GB\)_CONFIG_SUBDIRS(${1}[,)]/d" \
		"${S}/configure.ac" || die
	sed -i -e "/^ \(@${1}_dir@\|${1}\)/d" \
		"${S}/Makefile.am" || die
}

src_prepare() {
	# Deprecated
	autocrap_cleanup sqlite2

	use_if_iuse bzip2 || autocrap_cleanup bzlib2
	use_if_iuse mysql || autocrap_cleanup mysql
	use_if_iuse postgres || autocrap_cleanup postgresql
	use_if_iuse sqlite || autocrap_cleanup sqlite
	use_if_iuse zlib || autocrap_cleanup zlib

	sed -i -e "s/gb_enable_\$1=yes/gb_enable_\$1=no/" \
		"${S}/acinclude.m4" || die

	eautoreconf
}

src_configure() {
	econf --config-cache \
		$(use_enable bzip2 bzlib2) \
		$(use_enable zlib) \
		$(use_enable mysql) \
		$(use_enable odbc) \
		$(use_enable postgres postgresql) \
		$(use_enable sqlite sqlite3) \
		$(use_enable net) \
		$(use_enable curl) \
		$(use_enable mime) \
		$(use_enable pcre) \
		$(use_enable sdl) \
		$(use_enable sdlsound) \
		$(use_enable libxml) \
		$(use_enable xml) \
		$(use_enable v4l) \
		$(use_enable crypt) \
		$(use_enable qt4) \
		$(use_enable gtk) \
		$(use_enable gtk3) \
		$(use_enable opengl) \
		$(use_enable x11) \
		$(use_enable keyring) \
		$(use_enable pdf) \
		$(use_enable cairo) \
		$(use_enable imageio) \
		$(use_enable imageimlib) \
		$(use_enable dbus) \
		$(use_enable gsl) \
		$(use_enable gmp) \
		$(use_enable ncurses) \
		$(use_enable media) \
		$(use_enable jit) \
		$(use_enable httpd) \
		$(use_enable openssl) \
		$(use_enable openal)
}

src_install() {
	emake DESTDIR="${D}" install
}
