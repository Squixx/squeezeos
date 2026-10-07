SECTION = "libs"
DESCRIPTION = "libogg is the bitstream and framing library \
for the Ogg project. It provides functions which are \
necessary to codec libraries like libvorbis."
LICENSE = "BSD"
PR = "r0"

SRC_URI = "http://downloads.xiph.org/releases/ogg/libogg-${PV}.tar.gz \
"

inherit autotools_stage pkgconfig

ARM_INSTRUCTION_SET = "arm"

do_configure () {
	${S}/configure \
	--build=${BUILD_SYS} \
	--host=${HOST_SYS} \
	--target=${TARGET_SYS} \
	--prefix=${prefix} \
	--exec_prefix=${exec_prefix} \
	--bindir=${bindir} \
	--sbindir=${sbindir} \
	--libexecdir=${libexecdir} \
	--datadir=${datadir} \
	--sysconfdir=${sysconfdir} \
	--sharedstatedir=${sharedstatedir} \
	--localstatedir=${localstatedir} \
	--libdir=${libdir} \
	--includedir=${includedir} \
	--oldincludedir=${oldincludedir} \
	--infodir=${infodir} \
	--mandir=${mandir} \
	${EXTRA_OECONF} \
}

do_stage() {
    autotools_stage_all
}

