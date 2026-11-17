#!/usr/bin/env bash
# Run as a sudo-capable user. Installs packages, MariaDB config and wkhtmltopdf.
set -euo pipefail

sudo apt update && sudo apt upgrade -y
sudo apt install -y git python3-dev python3-setuptools python3-pip python3-venv \
  python3.14-dev python3.14-venv libmariadb-dev pkg-config \
  redis-server software-properties-common mariadb-server mariadb-client \
  xvfb libfontconfig curl cron supervisor nginx fail2ban ufw

cd "$(dirname "$0")/.."
sudo cp config/99-frappe.cnf /etc/mysql/mariadb.conf.d/99-frappe.cnf
sudo systemctl restart mariadb

cd ~
wget -nc https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb
sudo apt install -y ./wkhtmltox_0.12.6.1-2.jammy_amd64.deb
wkhtmltopdf --version

echo
echo "NEXT (manual): sudo mariadb-secure-installation"
echo "  - unix_socket auth: n   - set a root password and save it in a password manager"
echo "THEN: sudo adduser frappe && sudo usermod -aG sudo frappe && su - frappe"
