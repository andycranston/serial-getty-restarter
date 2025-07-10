#!/bin/bash
#
# @(!--#) @(#) Install.sh, sversion 0.1.0, fversion 003, 10-july-2025
#
# install the serial getty restart bash shell script and the service file.
# enable and start the service.
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
