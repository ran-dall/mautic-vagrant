#! /usr/bin/env bash

# Install Git
apt-get install git -y

# Install Composer
apt-get install composer -y

# Download Mautic
git clone https://github.com/mautic/mautic.git /var/www/mautic

# Install Mautic
cd /var/www/mautic/
composer install

# Fix Ownership of Mautic
chown -R www-data:www-data /var/www/mautic/
chmod -R 755 /var/www/mautic/

# Enable Mautic
cd /etc/apache2/
a2ensite mautic.conf
a2ensite mautic-ssl.conf
a2dissite 000-default.conf
a2enmod rewrite
a2enmod ssl
systemctl reload apache2.service

# Restart Apache2
systemctl restart apache2.service
