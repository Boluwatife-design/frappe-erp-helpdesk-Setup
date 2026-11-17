#!/usr/bin/env bash
# Run as the 'frappe' user. Usage: SITE=helpdesk.example.com ./02-frappe-user-setup.sh
# bench will prompt for the MariaDB root password and the Administrator password.
# At "Enter mysql super user [root]:" just press Enter.
set -euo pipefail
: "${SITE:?Set SITE, e.g. SITE=helpdesk.example.com}"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"
nvm install 24 && nvm alias default 24
npm install -g yarn

curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
uv tool install frappe-bench

cd ~
[ -d frappe-bench ] || bench init --frappe-branch version-16 frappe-bench
cd frappe-bench

bench new-site "$SITE"
bench get-app --branch version-16 erpnext
bench get-app telephony
bench get-app helpdesk --branch main   # NOT the default branch (targets Frappe v17)

bench --site "$SITE" install-app erpnext
bench --site "$SITE" install-app telephony
bench --site "$SITE" install-app helpdesk
bench --site "$SITE" set-config host_name "https://$SITE"
bench --site "$SITE" enable-scheduler
bench --site "$SITE" list-apps
