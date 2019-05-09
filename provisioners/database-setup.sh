#! /usr/bin/env bash

# Install MariaDB
apt-get install mariadb-server mariadb-client -y

# Start MariaDB
systemctl stop mariadb.service
systemctl start mariadb.service
systemctl enable mariadb.service

# Create MariaDB database for Mautic
mysql -h "$DBHOST" -u root "-p$DBPASSWD" -e "CREATE DATABASE $DBNAME";
mysql -h "$DBHOST" -u root "-p$DBPASSWD" -e "CREATE USER '$DBUSER'@$DBHOST IDENTIFIED BY '$DBPASSWD'";
mysql -h "$DBHOST" -u root "-p$DBPASSWD" -e "GRANT ALL ON $DBNAME.* TO '$DBUSER'@$DBHOST; FLUSH PRIVILEGES;"

# Restart Apache2
systemctl restart apache2.service