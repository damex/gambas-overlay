# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools eutils fdo-mime

SLOT="3"
MY_PN="${PN}${SLOT}"

DESCRIPTION="Gambas is a free development environment based on a Basic interpreter with object extensions"
HOMEPAGE="http://gambas.sourceforge.net"

SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL2"
KEYWORDS="*"

IUSE="+curl +net +qt4 +x11
	bzip2 cairo crypt dbus examples gmp gnome gsl gtk2 gtk3 httpd imageimlib imageio jit libxml media mime
	mysql ncurses odbc openal opengl openssl pcre pdf pop3 postgres sdl sdl-sound sqlite v4l xml zlib"

REQUIRED_USE="gnome? ( x11 )
	gtk2? ( x11 )
	gtk3? ( x11 )
	net? ( curl
		pop3? ( mime ) )
	pdf? ( || ( gtk2 gtk3 qt4 sdl ) )
	qt4? ( x11 )
	sdl? ( x11 )
	sdl-sound? ( sdl )"

RDEPEND="bzip2? ( app-arch/bzip2 )
	cairo? ( x11-libs/cairo )
	curl? ( net-misc/curl )
	dbus? ( sys-apps/dbus )
	gnome? ( gnome-base/gnome-keyring )
	gmp? ( dev-libs/gmp )
	gsl? ( sci-libs/gsl )
	gtk2? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	jit? ( sys-devel/llvm )
	imageimlib? ( media-libs/imlib2 )
	imageio? ( dev-libs/glib
		x11-libs/gdk-pixbuf )
	libxml? ( dev-libs/libxml2 )
	media? ( media-libs/gstreamer
		media-libs/gst-plugins-base )
	mime? ( dev-libs/gmime )
	mysql?  ( virtual/mysql )
	ncurses? ( sys-libs/ncurses )
	odbc? ( dev-db/unixODBC )
	openal? ( media-libs/openal )
	opengl? ( media-libs/mesa )
	openssl? ( dev-libs/openssl )
	pcre? ( dev-libs/libpcre )
	pdf? ( virtual/poppler )
	postgres? ( virtual/postgresql-base )
	qt4? ( opengl? ( dev-qt/qtopengl:4[qt3support] )
		dev-qt/qtcore:4[qt3support]
		dev-qt/qtgui:4[qt3support]
		dev-qt/qtsvg:4 )
	sdl? ( media-libs/sdl-image )
	sdl-sound? ( media-libs/sdl-mixer )
	v4l? ( virtual/jpeg
		media-libs/libpng )
	x11? ( x11-libs/libX11
		x11-libs/libXtst )
	xml? ( dev-libs/libxml2
		dev-libs/libxslt )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	virtual/libintl"

S="${WORKDIR}/${MY_PN}-${PV}"

autocrap_cleanup() {
	sed -i -e "/^\(AC\|GB\)_CONFIG_SUBDIRS(${1}[,)]/d" \
		"${S}/configure.ac" || die
	sed -i -e "/^ \(@${1}_dir@\|${1}\)/d" \
		"${S}/Makefile.am" || die
}

src_prepare() {
	# funtoo-ism
	epatch "${FILESDIR}/gambas-3.6.2-app-makefile.am.patch"
	epatch "${FILESDIR}/gambas-3.6.2-main-makefile.am.patch"

	# deprecated
	autocrap_cleanup sqlite2

	use_if_iuse bzip2 || autocrap_cleanup bzlib2
	use_if_iuse cairo || autocrap_cleanup cairo
	use_if_iuse crypt || autocrap_cleanup crypt
	use_if_iuse curl || autocrap_cleanup curl
	use_if_iuse dbus || autocrap_cleanup dbus
	use_if_iuse examples || autocrap_cleanup examples
	use_if_iuse gsl || autocrap_cleanup gsl
	use_if_iuse gmp || autocrap_cleanup gmp
	use_if_iuse gnome || autocrap_cleanup keyring
	use_if_iuse gtk2 || autocrap_cleanup gtk
	use_if_iuse gtk3 || autocrap_cleanup gtk3
	use_if_iuse httpd || autocrap_cleanup httpd
	use_if_iuse imageimlib || autocrap_cleanup imageimlib
	use_if_iuse imageio || autocrap_cleanup imageio
	use_if_iuse jit || autocrap_cleanup jit
	use_if_iuse libxml || autocrap_cleanup libxml
	use_if_iuse media || autocrap_cleanup media
	use_if_iuse mime || autocrap_cleanup mime
	use_if_iuse mysql || autocrap_cleanup mysql
	use_if_iuse ncurses || autocrap_cleanup ncurses
	use_if_iuse net || autocrap_cleanup net
	use_if_iuse odbc || autocrap_cleanup odbc
	use_if_iuse openal || autocrap_cleanup openal
	use_if_iuse opengl || autocrap_cleanup opengl
	use_if_iuse openssl || autocrap_cleanup openssl
	use_if_iuse pcre || autocrap_cleanup pcre
	use_if_iuse pdf || autocrap_cleanup pdf
	use_if_iuse postgres || autocrap_cleanup postgresql
	use_if_iuse qt4 || autocrap_cleanup qt4
	use_if_iuse sdl || autocrap_cleanup sdl
	use_if_iuse sdl-sound || autocrap_cleanup sdlsound
	use_if_iuse sqlite || autocrap_cleanup sqlite
	use_if_iuse v4l || autocrap_cleanup v4l
	use_if_iuse x11 || autocrap_cleanup x11
	use_if_iuse xml || autocrap_cleanup xml
	use_if_iuse zlib || autocrap_cleanup zlib

	eautoreconf
}

src_configure() {
	econf --config-cache \
		$(use_enable bzip2 bzlib2) \
		$(use_enable cairo) \
		$(use_enable crypt) \
		$(use_enable curl) \
		$(use_enable dbus) \
		$(use_enable examples) \
		$(use_enable gmp) \
		$(use_enable gnome keyring) \
		$(use_enable gsl) \
		$(use_enable gtk2) \
		$(use_enable gtk3) \
		$(use_enable httpd) \
		$(use_enable imageimlib) \
		$(use_enable imageio) \
		$(use_enable jit) \
		$(use_enable libxml) \
		$(use_enable media) \
		$(use_enable mime) \
		$(use_enable mysql) \
		$(use_enable ncurses) \
		$(use_enable net) \
		$(use_enable odbc) \
		$(use_enable openal) \
		$(use_enable opengl) \
		$(use_enable openssl) \
		$(use_enable pcre) \
		$(use_enable pdf) \
		$(use_enable postgres postgresql) \
		$(use_enable qt4) \
		$(use_enable sdl) \
		$(use_enable sdl-sound sdlsound) \
		$(use_enable sqlite sqlite3) \
		$(use_enable v4l) \
		$(use_enable x11) \
		$(use_enable xml) \
		$(use_enable zlib)
}

src_install() {
	emake DESTDIR="${D}" install -j1

	dodoc AUTHORS ChangeLog NEWS README

	if use net ; then
		newdoc gb.net/src/doc/README gb.net-README
		newdoc gb.net/src/doc/changes.txt gb.net-ChangeLog
	fi

	if use pcre ; then
		newdoc gb.pcre/src/README gb.pcre-README
	fi

	if use gtk2 || use gtk3 || use qt4 ; then
		newicon -s 128 -c apps -t hicolor app/src/${MY_PN}/img/logo/logo.png ${PN}.png
		make_desktop_entry "${MY_PN}" "Gambas" "/usr/share/icons/hicolor/128x128/apps/${PN}.png" "Development"

		doicon -s 64 -c mimetypes app/mime/application-x-gambasscript.png \
			app/mime/application-x-gambasserverpage.png \
			main/mime/application-x-gambas3.png

		insinto /usr/share/mime/application
		doins app/mime/application-x-gambasscript.xml \
			app/mime/application-x-gambasserverpage.xml \
			main/mime/application-x-gambas3.xml
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
