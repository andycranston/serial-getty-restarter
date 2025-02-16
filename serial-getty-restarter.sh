#!/bin/bash
#
# @(!--#) @(#) serial-getty-restarter.sh, sversion 0.1.0, fversion 002, 16-february-2025
#
# watch dmesg output for USB serial devices and restart the serial-getty service associated with it
#

# fail on undefined variables
set -u

# fix a standard PATH
PATH=/bin:/usr/bin:/sbin:/usr/sbin
export PATH

# set the name of the program
g_progname=`basename $0`

# workout the username the program/script is running as
username=`id | cut -d'(' -f2 | cut -d')' -f1`

# check we are running as root user - if not then error message and exit
if [ "$username" != "root" ]
then
  msg="must run as root"
  logger "$msg"
  echo "$g_progname: $msg" 1>&2
  exit 2
fi

# read output from dmesg "forever" a line at a time
dmesg -W | while read line
do
  # if it a line indicating a serial USB device has been plugged in?
  device=`echo "$line" | grep " now attached to " | awk '{ print $NF }'`

  # is the device a non-null string?
  if [ "$device" != "" ]
  then
    case "$device" in
      # if it is in the format ttyUSBn where n is a number in hte range 0 to 9 then restart the serial getty service
      ttyUSB[0-9])
        logger "Got a USB tty - $device"
        cmd="sudo systemctl restart serial-getty@${device}.service"
        logger "$cmd"
        $cmd
        ;;
      # log other device names for information purposes
      *)
        logger "Ignoring device \"$device\""
        ;;
    esac
  fi
done

# control should never get here!
exit 0

# end of file: serial-getty-restarter.sh
