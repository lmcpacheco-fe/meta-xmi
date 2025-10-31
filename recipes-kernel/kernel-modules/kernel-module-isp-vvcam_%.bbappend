DESCRIPTION = "Add AR0830 Camera Module enablement in isp-vvcam"

SRC_AR0830 = "git://github.com/nxp-imx-support/imx-camera-sw-pack-source.git;protocol=https"
SRC_BRANCH = "LF6.6.52_P24.4"

SRC_URI += " \
        ${SRC_AR0830};branch=${SRC_BRANCH};destsuffix=src_ar0830;fsl-eula=true;name=ar0830;subpath=imx8mp-camera-sw-pack-ar0830\
"
SRCREV_FORMAT = "ar0830"
SRCREV_ar0830 = "8b8c433bf388de41763aa04834dce7f131f31ed9"

S_AR0830 = "${WORKDIR}/src_ar0830/isp-vvcam"
PATCHTOOL = "git"
do_compile:append () {

        cp -r ${S_AR0830}/v4l2/* ${S}/
        cp ${S_AR0830}/ar0830_kernel-module-isp-vvcam.patch ${S}/../

        cd ${S}/../
        git apply ar0830_kernel-module-isp-vvcam.patch
        cd ${S}
        module_do_compile
}
