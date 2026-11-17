#!/usr/bin/env bash
# Restore a backup onto a freshly created site (docs 02-05 done, same site name and versions).
# Usage: SITE=helpdesk.example.com ./restore.sh /path/db.sql.gz /path/files.tar /path/private-files.tar
set -euo pipefail
: "${SITE:?Set SITE}"
DB="${1:?db.sql.gz path}"; PUB="${2:?public files tar}"; PRIV="${3:?private files tar}"
export PATH="$HOME/.local/bin:$PATH"
cd ~/frappe-bench

bench --site "$SITE" restore "$DB" --with-public-files "$PUB" --with-private-files "$PRIV"
echo
echo "MANUAL: make encryption_key in sites/$SITE/site_config.json match the OLD site's value."
read -r -p "Done? Press Enter to migrate..." _
bench --site "$SITE" migrate
bench --site "$SITE" clear-cache
