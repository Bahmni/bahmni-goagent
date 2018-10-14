#!/bin/bash
set -e

chmod 777 /tmp/.X99-lock
dbus-uuidgen > /var/lib/dbus/machine-id
Xvfb :99 & export DISPLAY=:99
export $(dbus-launch)

if [ -f /etc/my.cnf ]; then
   chown -R mysql:mysql /var/lib/mysql
   service mysqld start
else
   echo "File /etc/my.cnf does not exist."
fi


if [ -f /var/lib/pgsql/.bash_profile ]; then
    service postgresql-9.2 restart
else
   echo "File /var/lib/pgsql/.bash_profile does not exist."
fi
