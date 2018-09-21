#!/bin/bash
set -e

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