#!/usr/bin/env bash
# Copies backups and site config to a home PC over Tailscale. Run from cron as 'frappe'.
# Prerequisite: SSH key login from this VM to the home PC (ssh-copy-id).
set -euo pipefail

SITE="${SITE:-helpdesk.example.com}"
DEST="${DEST:-youruser@100.x.y.z:/path/to/erp-backups/}"   # home PC's Tailscale IP

BENCH=/home/frappe/frappe-bench
rsync -avz --delete-after "$BENCH/sites/$SITE/private/backups/" "$DEST"
rsync -avz "$BENCH/sites/$SITE/site_config.json" "$BENCH/sites/common_site_config.json" "$DEST/config/"
echo "$(date -Is) offsite backup finished"
