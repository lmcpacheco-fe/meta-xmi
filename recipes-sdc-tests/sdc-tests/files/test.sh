##!/bin/bash

PASS=0

function evaluatetest {
	local RESULT
	read -p "$1 (y/n) " RESULT
	if [ "${RESULT,,}" == "y" ]
	then
		((PASS++))
		echo "######################################"
		printf "# Number of tests passed so far %-2d   #\n" $PASS
		echo "######################################"
	fi
}

echo "#######################################"
echo "# Checking kernel logs for errors     #"
echo "#######################################"
ERRORS=$(dmesg 2>/dev/null | grep -i "error")
if [ -n "$ERRORS" ]; then
    echo "Kernel errors detected:"
    echo "$ERRORS"
else
    echo "No kernel errors found in kernel logs"
fi
evaluatetest "Did the kernel log test pass?"

# echo "#######################################"
# echo "# Testing Analog to Digital Converter #"
# echo "#######################################"
# ADCDIR=$(find /sys/devices/platform -name iio:device*)
# # usually /sys/devices/platform/soc@0/30800000.bus/30800000.spba-bus/30820000.spi/spi_master/spi1/spi1.1/iio:device0
# # but sometimes slightly different
# cat $ADCDIR/in_voltage*_raw
# evaluatetest "Were the numbers printed correct?"

echo "########################"
echo "# Testing DDR Memory   #"
echo "########################"
echo "Running memtester..."
memtester 128M 1
evaluatetest "Did the DDR memtester pass?"

# echo "######################################"
# echo "# Testing Microphone - Say Something #"
# echo "#      Press Enter To Continue       #"
# echo "######################################"
# read
# # this shouldn't be bodged in test, but properly fixed
# # mv /etc/asound.conf /etc/asound.conf.bak
# # should sometimes be hw:1,0
# # I'm not sure how to fix that
# arecord -D hw:2,0 -f S32_LE -d 5 out.wav

# echo "###################################"
# echo "# Playing Back the Recorded Audio #"
# echo "###################################"
# aplay out.wav
# evaluatetest "Did you hear the recorded audio playing back?"

# echo "##########################################"
# echo "# Testing Speaker - Playing Sample Audio #"
# echo "#        Press Enter To Continue         #"
# echo "##########################################"
# read
# aplay -d 4 /etc/sdc/Moldova.wav
# evaluatetest "Did the Speaker test pass?"

echo "########################################"
echo "# Testing WiFi - Connecting to Network #"
echo "########################################"
read -p "Please enter the WiFi SSID: " WIFI_NAME
read -s -p "Please enter the WiFi password: " PASSWORD
echo
echo "#       Press Enter To Continue        #"
read
modprobe moal mod_para=nxp/wifi_mod_para.conf
connmanctl enable wifi >/dev/null 2>&1
connmanctl scan wifi >/dev/null 2>&1
echo "Available WiFi services:"
connmanctl services

SERVICE=$(connmanctl services | awk -v ssid="$WIFI_NAME" '$1 == ssid {print $NF; exit}')

if [ -z "$SERVICE" ]; then
    echo "WiFi service for SSID '$WIFI_NAME' not found"
else
    echo "Connecting to $WIFI_NAME ..."
    expect <<EOF
spawn connmanctl
expect "connmanctl> "
send "agent on\r"
expect "connmanctl> "
send "connect $SERVICE\r"
expect {
    "Passphrase? " {
        send "$PASSWORD\r"
        expect "connmanctl> "
    }
    "connmanctl> " {
    }
}
send "quit\r"
expect eof
EOF
    echo
    echo "########################"
    echo "# Pinging google.com   #"
    echo "########################"
    sleep 5
    ping -c 4 google.com
fi
evaluatetest "Did the WiFi test pass?"

echo "#####################"
echo "# Testing Bluetooth #"
echo "#####################"
systemctl start bluetooth.service
modprobe btnxpuart
hciconfig hci0 up
expect -c '
	spawn bluetoothctl
	expect "\[bluetooth\]# "
	send "agent on\r"
	expect "\[bluetooth\]# "
	send "scan on\r"
	sleep 10
	send "scan off\r"
	expect "\[bluetooth\]# "
	send "quit\r"
	expect eof
'
echo
evaluatetest "Did the Bluetooth test pass?"

# echo "################"
# echo "# Testing LEDs #"
# echo "################"
# echo 255 > /sys/class/leds/pca963x\:red/brightness
# echo 255 > /sys/class/leds/pca963x\:green/brightness
# echo 255 > /sys/class/leds/pca963x\:blue/brightness
# sleep 1
# echo 0 > /sys/class/leds/pca963x\:red/brightness
# sleep 1
# echo 255 > /sys/class/leds/pca963x\:red/brightness
# echo 0 > /sys/class/leds/pca963x\:green/brightness
# sleep 1
# echo 0 > /sys/class/leds/pca963x\:red/brightness
# sleep 1
# echo 255 > /sys/class/leds/pca963x\:red/brightness
# echo 255 > /sys/class/leds/pca963x\:green/brightness
# echo 0 > /sys/class/leds/pca963x\:blue/brightness
# sleep 1
# echo 0 > /sys/class/leds/pca963x\:red/brightness
# sleep 1
# echo 255 > /sys/class/leds/pca963x\:red/brightness
# echo 0 > /sys/class/leds/pca963x\:green/brightness
# sleep 1
# echo 0 > /sys/class/leds/pca963x\:red/brightness
# sleep 1
# evaluatetest "Did the LED test pass?"

echo "#######################"
echo "# Testing Temperature #"
echo "#######################"
if [ -d /sys/class/thermal ]; then
    for zone in /sys/class/thermal/thermal_zone*; do
        [ -f "$zone/temp" ] || continue

        NAME=$(cat "$zone/type" 2>/dev/null)
        TEMP=$(cat "$zone/temp" 2>/dev/null)

        case "$TEMP" in
            ''|*[!0-9]*)
                echo "$NAME: N/A"
                continue
                ;;
        esac

        if [ "$TEMP" -ge 1000 ]; then
            INT=$(( TEMP / 1000 ))
            DEC=$(( (TEMP % 1000) / 100 ))
            printf "%s: %d.%01d °C\n" "$NAME" "$INT" "$DEC"
        else
            printf "%s: %d °C\n" "$NAME" "$TEMP"
        fi
    done
else
    echo "No thermal zones found"
fi
evaluatetest "Did the temperature test pass?"
