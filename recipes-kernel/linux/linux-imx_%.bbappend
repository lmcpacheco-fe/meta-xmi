FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_AR0830 = "git://github.com/nxp-imx-support/imx-camera-sw-pack-source.git;protocol=https"
SRC_BRANCH = "LF6.6.52_P24.4"

SRC_URI:append = " \
    file://add-drivers-for-rpi-7in-display.patch \
    file://defconfig \
    file://0001-Add-NXP-UWM-drivers-for-the-SR1xx-UWB-radio-in-the-M.patch \
    file://xmi-imx8mp.dts \
    file://xmi-imx8mp-imx219.dts \
    file://xmi-imx8mp-ar0144.dts \
    file://Makefile \
    file://0001-remove-message-warning-about-hblank-data.patch \
    file://0001-tty-serial-add-Exar-XRM1280-support.patch \
    ${SRC_AR0830};branch=${SRC_BRANCH};destsuffix=src_ar0830;fsl-eula=true;name=ar0830;subpath=imx8mp-camera-sw-pack-ar0830\
"

SRCREV_FORMAT = "ar0830"
SRCREV_ar0830 = "8b8c433bf388de41763aa04834dce7f131f31ed9"

S_AR0830 = "${WORKDIR}/src_ar0830/linux-imx"
PATCHTOOL = "git"

do_patch:append() {
        cp ${S_AR0830}/ar0830_linux-imx.patch ${S}/
        cd ${S}
        git apply ar0830_linux-imx.patch
}

# Override meta-imx's KBUILD_DEFCONFIG,
# thus ensuring "file://defconfig" is used
unset KBUILD_DEFCONFIG

do_override_files () {
    # custom defconfig
    install -Dm 0644 ${WORKDIR}/defconfig ${S}/arch/arm64/configs/imx_v8_defconfig

    # device-tree customizations
    install -Dm 0644 ${WORKDIR}/xmi-imx8mp.dts ${S}/arch/arm64/boot/dts/freescale/xmi-imx8mp.dts
    install -Dm 0644 ${WORKDIR}/xmi-imx8mp-imx219.dts ${S}/arch/arm64/boot/dts/freescale/xmi-imx8mp-imx219.dts
    install -Dm 0644 ${WORKDIR}/xmi-imx8mp-ar0144.dts ${S}/arch/arm64/boot/dts/freescale/xmi-imx8mp-ar0144.dts
    install -Dm 0644 ${WORKDIR}/Makefile ${S}/arch/arm64/boot/dts/freescale/Makefile
}
addtask override_files after do_kernel_configme before do_configure

# deltask kernel_localversion
deltask merge_delta_config
