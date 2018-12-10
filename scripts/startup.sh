#!/bin/bash
set -e

echo 'Starting Xvfb ...'
Xvfb :99 & export DISPLAY=:99
echo 'Change X99 permission ...'
chmod 777 /tmp/.X99-lock
echo 'exporting dbus launch'
export $(dbus-launch)
echo 'Adding dbus uuid'
dbus-uuidgen > /var/lib/dbus/machine-id


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

if [ -f /home/go/.m2 ]; then
   chown -R go:go /home/go
else
    echo "Path /home/go/.m2 does not exist."
fi

if [ -f /bahmni-apk-signing ]; then
   chown -R go:go /bahmni-apk-signing
else
    echo "Folder /bahmni-apk-signing does not exist."
fi
