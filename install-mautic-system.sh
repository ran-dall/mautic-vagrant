#! /usr/bin/env bash

# Update system
apt-get update -y
apt-get -qq upgrade -y

# Install Apache2
apt-get install apache2 -y

# Disable directory listing globally
sed -i "s|Options Indexes FollowSymLinks|Options FollowSymLinks|" /etc/apache2/apache2.conf
# Allow Apache2 override to all
sed -i "s|AllowOverride None|AllowOverride All|g" /etc/apache2/apache2.conf

# Copy Mautic Apache2 .conf files
cp -f /vagrant/provisioners/mautic.conf /etc/apache2/sites-available/mautic.conf
cp -f /vagrant/provisioners/mautic-ssl.conf /etc/apache2/sites-available/mautic-ssl.conf

# Start Apache2
systemctl stop apache2.service
systemctl start apache2.service
systemctl enable apache2.service

# Install PHP
apt-get install php libapache2-mod-php libapache2-mod-php php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-tidy php-mysql php-cli php-mcrypt php-ldap php-zip php-curl php-sqlite3 php-amqplib php-imap -y

# Enable PHP Error Reporting
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini

# Set Recommended Mautic PHP Settings
sed -i "s|file_uploads = .*|file_uploads = On|" /etc/php/7.0/apache2/php.ini
sed -i "s|allow_url_fopen = .*|allow_url_fopen = On|" /etc/php/7.0/apache2/php.ini
sed -i "s|short_open_tag = .*|short_open_tag = On|" /etc/php/7.0/apache2/php.ini
sed -i "s|memory_limit = .*|memory_limit = 512M|" /etc/php/7.0/apache2/php.ini
sed -i "s|upload_max_filesize = .*|upload_max_filesize = 100M|" /etc/php/7.0/apache2/php.ini
sed -i "s|max_execution_time = .*|max_execution_time = 360|" /etc/php/7.0/apache2/php.ini

# Set PHP Time Zone
sed -i "s|.*date.timezone =.*|date.timezone = /$TIMEZONE/|" /etc/php/7.0/apache2/php.ini

# Restart Apache2
systemctl restart apache2.service
