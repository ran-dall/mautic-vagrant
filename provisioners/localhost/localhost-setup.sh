#! /usr/bin/env bash

# Install LocalHost SSL-Cert
apt-get install ssl-cert -y
make-ssl-cert generate-default-snakeoil --force-overwrite

# Restart Apache2
systemctl restart apache2.service
