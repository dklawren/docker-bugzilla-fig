#!/bin/bash

# Create the DB user
groupadd -g $MYSQL_GROUP_ID $MYSQL_USER
useradd -u $MYSQL_USER_ID -g $MYSQL_GROUP_ID $MYSQL_USER

# Initial DB setup
rm -rf /var/lib/mysql/*
mysql_install_db --user=$MYSQL_USER --datadir=/var/lib/mysql
chown -R $MYSQL_USER:$MYSQL_USER /var/lib/mysql
chown -R $MYSQL_USER:$MYSQL_USER /var/run/mysqld

# Start the DB
mysqld_safe &
sleep 5

# Create the Bugzilla DB and set permissions
mysql -u root -e "CREATE DATABASE IF NOT EXISTS $BUGS_DB_NAME CHARACTER SET = 'utf8';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO $BUGS_DB_USER@'%' IDENTIFIED BY '$BUGS_DB_PASS'; FLUSH PRIVILEGES;"

exit
