DESCRIPTION = "DejaVu fonts are a font family based on the Vera Fonts"
SECTION = "libs"
LICENSE = "Public domain"

PR="r0"

SRC_URI="http://sourceforge.net/projects/dejavu/files/dejavu/${PV}/${PN}-${PV}.tar.bz2"

S = "${WORKDIR}/${PN}-${PV}/ttf"

do_install() {
	mkdir -p ${D}/${datadir}/jive/fonts
	install -m 0644 DejaVuSansCondensed.ttf ${D}/${datadir}/jive/fonts/FreeSans.ttf
	install -m 0644 DejaVuSansCondensed-Bold.ttf ${D}/${datadir}/jive/fonts/FreeSansBold.ttf
}

FILES_${PN} += "${datadir}"
