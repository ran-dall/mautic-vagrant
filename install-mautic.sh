#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# "unofficial" bash strict mode
# See: http://redsymbol.net/articles/unofficial-bash-strict-mode
set -o errexit  # Exit when simple command fails               'set -e'
set -o errtrace # Exit on error inside any functions or subshells.
set -o nounset  # Trigger error when expanding unset variables 'set -u'
set -o pipefail # Do not hide errors within pipes              'set -o pipefail'
IFS=$'\n\t'

declare mautic_root='/var/www/mautic'
declare mautic_version='2.15.1'
declare www_user='www-data'

# Install Git
apt-get -qq install git -y

# Install Composer
apt-get -qq install composer -y

# Download Mautic
git clone https://github.com/mautic/mautic.git --single-branch --branch release-"${mautic_version}" "${mautic_root}"

# Install Mautic
pushd "${mautic_root}" > /dev/null || false
composer install
popd > /dev/null || false

# Fix ownership and permissions of Mautic files
chown -fR "${www_user}":"${www_user}" "${mautic_root}"
find "${mautic_root}" -type d \! -perm /o+x -exec chmod -f 755 '{}' \;
find "${mautic_root}" -type f \! -perm /o+r -exec chmod -c 644 '{}' \;
chmod -f 755 "${mautic_root}/app/console"
chmod -f 664 "${mautic_root}/.php_cs"
find \
  "${mautic_root}/media/"         \
  "${mautic_root}/themes/"        \
  "${mautic_root}/app/cache/"     \
  "${mautic_root}/app/logs/"      \
  "${mautic_root}/app/config/"    \
  "${mautic_root}/translations/"  \
  -exec chmod -fR ug+w '{}' \;

# Enable Mautic website
pushd /etc/apache2 > /dev/null || false
a2ensite mautic.conf
a2ensite mautic-ssl.conf
a2dissite 000-default.conf
a2enmod rewrite
a2enmod ssl
popd > /dev/null || false
systemctl reload apache2.service

# Restart Apache2
systemctl restart apache2.service
