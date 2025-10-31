DESCRIPTION = "Add AR0830 Camera Module enablement in isp-imx"

inherit fsl-eula-unpack

SRC_AR0830 = "git://github.com/nxp-imx-support/imx-camera-sw-pack-source.git;protocol=https"
SRC_BRANCH = "LF6.6.52_P24.4"

SRC_URI += " \
	${SRC_AR0830};branch=${SRC_BRANCH};destsuffix=src_ar0830;fsl-eula=true;name=ar0830;subpath=imx8mp-camera-sw-pack-ar0830\
"
SRCREV_FORMAT = "ar0830"
SRCREV_ar0830 = "8b8c433bf388de41763aa04834dce7f131f31ed9"


FILES_SOLIBS_VERSIONED += " \
    ${libdir}/libar0830.so \
"

S_AR0830 = "${WORKDIR}/src_ar0830/isp-imx"
PATCHTOOL = "git"
do_compile:append () {
	
        cp -r ${S_AR0830}/*  ${S}/
	cd ${S}/
	git apply  ar0830_isp-imx.patch 
	
        cd ${B}/
        cmake_do_compile
}
