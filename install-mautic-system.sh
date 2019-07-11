#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# "unofficial" bash strict mode
# See: http://redsymbol.net/articles/unofficial-bash-strict-mode
set -o errexit  # Exit when simple command fails               'set -e'
set -o errtrace # Exit on error inside any functions or subshells.
set -o nounset  # Trigger error when expanding unset variables 'set -u'
set -o pipefail # Do not hide errors within pipes              'set -o pipefail'
IFS=$'\n\t'

# Update system
apt-get -qq update -y
apt-get -qq upgrade -y

# Install Apache2
apt-get -qq install apache2 -y

sed -i "
    # Disable directory listing globally
    s|Options Indexes FollowSymLinks|Options FollowSymLinks|;

    # Allow Apache2 override to all
    s|AllowOverride None|AllowOverride All|g
    " /etc/apache2/apache2.conf

# Copy Mautic Apache2 .conf files
cp -f /vagrant/provisioners/mautic.conf /etc/apache2/sites-available/mautic.conf
cp -f /vagrant/provisioners/mautic-ssl.conf /etc/apache2/sites-available/mautic-ssl.conf

# Start Apache2
systemctl stop apache2.service
systemctl start apache2.service
systemctl enable apache2.service

# Install PHP
apt-get install php libapache2-mod-php libapache2-mod-php php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-tidy php-mysql php-cli php-mcrypt php-ldap php-zip php-curl php-sqlite3 php-amqplib php-imap -y

sed -i "
    # Enable PHP Error Reporting
    s|error_reporting = .*|error_reporting = E_ALL|g;
    s|display_errors = .*|display_errors = On|g;

    # Set Recommended Mautic PHP Settings
    s|file_uploads = .*|file_uploads = On|g;
    s|allow_url_fopen = .*|allow_url_fopen = On|g;
    s|short_open_tag = .*|short_open_tag = On|g;
    s|memory_limit = .*|memory_limit = 512M|g;
    s|upload_max_filesize = .*|upload_max_filesize = 100M|g;
    s|max_execution_time = .*|max_execution_time = 360|g

    # Set PHP Time Zone
    s|.*date.timezone =.*|date.timezone = /$TIMEZONE/|g;
    " /etc/php/7.0/apache2/php.ini

# Restart Apache2
systemctl restart apache2.service
