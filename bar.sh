#!/bin/sh
# Example Bar Action Script for OpenBSD-current.
#

print_date() {
	# The date is printed to the status bar by default.
	# To print the date through this script, set clock_enabled to 0
	# in spectrwm.conf.  Uncomment "print_date" below.
	FORMAT="%b %d %R"
	DATE=`date "+${FORMAT}"`
	echo -n "${DATE}"
}

print_mem() {
	echo -n $(free --mebi | sed -n '2{p;q}' | awk '{printf ("Mem|%2.2fGiB|\n", ( $3 / 1024), ($2 / 1024))}')
}

print_bat() {
	BAT_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
	BAT_STATUS=$(cat /sys/class/power_supply/BAT0/status)

	if [ $BAT_STATUS == "Charging" ]; then
		echo -n "Bat|$BAT_LEVEL%(C)|"
	else
		echo -n "Bat|$BAT_LEVEL%(D)|"
	fi
}

print_vol() {
	VOL=$(pamixer --get-volume)
	echo -n "Vol|$VOL%|"
}

print_internet() {
	if [ $(cat /sys/class/net/wlp2s0/operstate) == "up" ]; then
		echo -n "Wifi|Up|"
	else
		echo -n "Wifi|Down|"
	fi

}

print_cpu() {
	echo -n $(mpstat | awk '$3 ~ /CPU/ { for(i=1;i<=NF;i++) { if ($i ~ /%idle/) field=i } } $3 ~ /all/ { printf("CPU|%d%%|",100 - $field) }')
}

I=0
while :; do

	print_date
	echo -n "    "
	print_mem
	echo -n "    "
	print_bat 
	echo -n "    "
	print_vol
	echo -n "    "
	print_internet
	echo -n "    "
	print_cpu
	echo ""
	I=$(( ( ${I} + 1 ) % 11 ))
	sleep 0.5s
done
