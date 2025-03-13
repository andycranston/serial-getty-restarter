#!/bin/bash
#
# @(!--#) @(#) Install.sh, sversion 0.1.0, fversion 002, 13-march-2025
#
# install the serial getty restart bash shell script and the service file.
# enable and start the service.
# also ensure /usr/lib/systemd/system/serial-getty@.service has the edit to run
# at 115200 baud.
#

set -u

PATH=/bin:/usr/bin
export PATH

g_progname=`basename $0`

username=`id | cut -d'(' -f2 | cut -d')' -f1`

if [ "$username" != "root" ]
then
  echo "$g_progname: must run this script as root user - try: sudo ./$g_progname" 1>&2
  exit 2
fi

cmp -s /usr/lib/systemd/system/serial-getty@.service serial-getty@.service.115200-baud
retcode=$?

case $retcode in
  0) echo "file /usr/lib/systemd/system/serial-getty@.service already edited for 115200 baud"
     ;;
  1) cmp -s /usr/lib/systemd/system/serial-getty@.service serial-getty@.service.install
     retcode2=$?

     case $retcode2 in
       0) echo "copying 115200 baud version of file /usr/lib/systemd/system/serial-getty@.service into place"
          cp serial-getty@.service.115200-baud /usr/lib/systemd/system/serial-getty@.service
          retcode3=$?
          if [ $retcode3 -ne 0 ]
          then
            echo "$g_progname: problem with copy operation - see previous errors - giving up" 1>&2
            exit 2
          fi
          ;;
       1) echo "$g_progname: the /usr/lib/systemd/system/serial-getty@.service file is not from a stock/default OS install - giving up" 1>&2
          exit 2
          ;;
       *) echo "$g_progname: unable to successfully compare /usr/lib/systemd/system/serial-getty@.service with serial-getty@.service.install - giving up" 1>&2
          exit 2
          ;;
     esac
     ;;
  *) echo "$g_progname: unable to successfully compare /usr/lib/systemd/system/serial-getty@.service with serial-getty@.service.115200-baud - giving up" 1>&2
     exit 2
     ;;
esac

cp -p serial-getty-restarter.sh /usr/local/bin/serial-getty-restarter.sh
chown root:root                 /usr/local/bin/serial-getty-restarter.sh
chmod u=rwx,go=r                /usr/local/bin/serial-getty-restarter.sh

cp -p serial-getty-restarter.service /etc/systemd/system/serial-getty-restarter.service
chown root:root                      /etc/systemd/system/serial-getty-restarter.service
chmod u=rw,go=r                      /etc/systemd/system/serial-getty-restarter.service

systemctl daemon-reload

systemctl enable serial-getty-restarter.service
systemctl stop   serial-getty-restarter.service
systemctl start  serial-getty-restarter.service
sleep 1
systemctl status serial-getty-restarter.service | cat

exit 0

# end of file: Install.sh
