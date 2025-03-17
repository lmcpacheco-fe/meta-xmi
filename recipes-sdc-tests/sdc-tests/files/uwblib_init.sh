#!/bin/sh

FILE=/etc/sdc/uwblib_init.done
if test -f "$FILE"; then
        echo "UWB lib init already done."
        exit 0
fi

cp /etc/sdc/* /root
mv /root/SE05x-MW-v04.03.01.zip.txt /root/SE05x-MW-v04.03.01.zip
mv /root/UWBIOT_SR150_v04.06.00_libuwbd.zip.txt /root/UWBIOT_SR150_v04.06.00_libuwbd.zip
mv /root/UWBIOT_SR150_v04.06.00_Linux.zip.txt /root/UWBIOT_SR150_v04.06.00_Linux.zip
mv /root/bin.zip.txt /root/bin.zip
mv /root/uwb.zip.txt /root/uwb.zip
mv /root/uwb-se.zip.txt /root/uwb-se.zip
mv /root/bluetooth.service /lib/systemd/system/
mv /root/uwb_api.zip.txt /root/uwb_api.zip
cd /root/
unzip -o bin.zip
unzip -o uwb.zip
mkdir /usr/local
unzip -o uwb-se.zip -d /usr/local
unzip -o uwb_api.zip -d /usr/local/uwbiot
# python3 simw-top/scripts/create_cmake_projects.py
# cd /root/simw-top_build/imx_native_se050_t1oi2c
# cmake --build .
# make install
# clean up
rm /root/*.zip
rm /root/uwblib_init.sh

ldconfig /usr/local/lib

ex_ecc "/dev/i2c-2:0x48"

ldconfig /usr/local/uwbiot/uwb_api/

touch /etc/sdc/uwblib_init.done
