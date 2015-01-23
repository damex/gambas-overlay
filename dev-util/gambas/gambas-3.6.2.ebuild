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

IUSE="bzip2 curl examples gtk2 gtk3 mysql ncurses odbc pcre pdf postgres qt4 sqlite zlib net mime sdl sdlsound libxml xml v4l crypt
	opengl x11 keyringcairo imageio imageimlib dbus gsl gmp media jit httpd openssl openal"

REQUIRED_USE="pdf? ( || ( gtk2 gtk3 sdl ) )"

RDEPEND="bzip2? ( app-arch/bzip2 )
	curl? ( net-misc/curl )
	gtk2? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	mysql?  ( virtual/mysql )
	ncurses? ( sys-libs/ncurses )
	odbc? ( dev-db/unixODBC )
	pcre? ( dev-libs/libpcre )
	pdf? ( virtual/poppler )
	postgres? ( virtual/postgresql-base )
	qt4? ( dev-qt/qtgui:4 )
	dbus? ( sys-apps/dbus )
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
	# deprecated
	autocrap_cleanup sqlite2

	use_if_iuse bzip2 || autocrap_cleanup bzlib2
	use_if_iuse curl || autocrap_cleanup curl
	use_if_iuse dbus || autocrap_cleanup dbus
	use_if_iuse examples || autocrap_cleanup examples
	use_if_iuse gtk2 || autocrap_cleanup gtk
	use_if_iuse gtk3 || autocrap_cleanup gtk3
	use_if_iuse mysql || autocrap_cleanup mysql
	use_if_iuse odbc || autocrap_cleanup odbc
	use_if_iuse opengl || autocrap_cleanup opengl
	use_if_iuse pcre || autocrap_cleanup pcre
	use_if_iuse pdf || autocrap_cleanup pdf
	use_if_iuse postgres || autocrap_cleanup postgresql
	use_if_iuse qt4 || autocrap_cleanup qt4
	use_if_iuse sqlite || autocrap_cleanup sqlite
	use_if_iuse zlib || autocrap_cleanup zlib

	sed -i -e "s/gb_enable_\$1=yes/gb_enable_\$1=no/" \
		"${S}/acinclude.m4" || die

	eautoreconf
}

src_configure() {
	econf --config-cache \
		$(use_enable bzip2 bzlib2) \
		$(use_enable curl) \
		$(use_enable examples) \
		$(use_enable gtk2) \
		$(use_enable gtk3) \
		$(use_enable mysql) \
		$(use_enable ncurses) \
		$(use_enable odbc) \
		$(use_enable opengl) \
		$(use_enable pcre) \
		$(use_enable pdf) \
		$(use_enable postgres postgresql) \
		$(use_enable qt4) \
		$(use_enable sqlite sqlite3) \
		$(use_enable zlib) \

		$(use_enable net) \
		$(use_enable mime) \
		$(use_enable pcre) \
		$(use_enable sdl) \
		$(use_enable sdlsound) \
		$(use_enable libxml) \
		$(use_enable xml) \
		$(use_enable v4l) \
		$(use_enable crypt) \
		$(use_enable x11) \
		$(use_enable keyring) \
		$(use_enable cairo) \
		$(use_enable imageio) \
		$(use_enable imageimlib) \
		$(use_enable dbus) \
		$(use_enable gsl) \
		$(use_enable gmp) \
		$(use_enable media) \
		$(use_enable jit) \
		$(use_enable httpd) \
		$(use_enable openssl) \
		$(use_enable openal)
}

src_install() {
	emake DESTDIR="${D}" install
}
