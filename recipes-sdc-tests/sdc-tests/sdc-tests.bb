SUMMARY = "sdc-tests"
DESCRIPTION = "SDC test files"
LICENSE = "CLOSED"

SRC_URI = "\
    file://matter-wifi-startup.sh \
    file://Moldova.wav \
    file://starwars.wav \
    file://test.sh \
    file://wifi-bt.sh \
    file://uwblib_init.sh \
    file://SE05x-MW-v04.03.01.zip.txt \
    file://UWBIOT_SR150_v04.06.00_libuwbd.zip.txt \
    file://UWBIOT_SR150_v04.06.00_Linux.zip.txt \
    file://bin.zip.txt \
    file://uwb.zip.txt \
    file://uwb-se.zip.txt \
    file://bluetooth.service \
    file://uwb_api.zip.txt \
"

do_install () {
    install -d ${D}${sysconfdir}/sdc/
    install -m 0755 ${WORKDIR}/matter-wifi-startup.sh ${D}${sysconfdir}/sdc
    install -m 0644 ${WORKDIR}/starwars.wav ${D}${sysconfdir}/sdc
    install -m 0644 ${WORKDIR}/Moldova.wav ${D}${sysconfdir}/sdc
    install -m 0755 ${WORKDIR}/test.sh  ${D}${sysconfdir}/sdc
    install -m 0755 ${WORKDIR}/wifi-bt.sh  ${D}${sysconfdir}/sdc
    install -m 0755 ${WORKDIR}/uwblib_init.sh  ${D}${sysconfdir}/sdc
    install -m 0644 ${WORKDIR}/SE05x-MW-v04.03.01.zip.txt  ${D}${sysconfdir}/sdc
    install -m 0644 ${WORKDIR}/UWBIOT_SR150_v04.06.00_libuwbd.zip.txt ${D}${sysconfdir}/sdc
    install -m 0644 ${WORKDIR}/UWBIOT_SR150_v04.06.00_Linux.zip.txt  ${D}${sysconfdir}/sdc
    install -m 0644 ${WORKDIR}/uwb.zip.txt  ${D}${sysconfdir}/sdc
    install -m 0644 ${WORKDIR}/bin.zip.txt  ${D}${sysconfdir}/sdc
    install -m 0644 ${WORKDIR}/uwb-se.zip.txt  ${D}${sysconfdir}/sdc
    install -m 0644 ${WORKDIR}/bluetooth.service ${D}${sysconfdir}/sdc
    install -m 0644 ${WORKDIR}/uwb_api.zip.txt ${D}${sysconfdir}/sdc
}


