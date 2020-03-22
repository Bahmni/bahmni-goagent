#!/bin/bash
set -e

ansible-playbook /scripts/startup-services.yml --extra-vars="mysql_password=P@ssw0rd postgres_version=9.6 postgres_bin_version=96" -vvv

wget https://github.com/odoo/odoo/archive/10.0.zip
unzip 10.0.zip
mv odoo-10.0/* .
sudo python setup.py -q install || true

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
   systemctl start mysqld
else
   echo "File /etc/my.cnf does not exist."
fi


if [ -f /var/lib/pgsql/.bash_profile ]; then
    systemctl restart postgresql-9.6
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

bash -lc ./docker-entrypoint.sh
