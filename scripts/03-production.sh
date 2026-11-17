#!/usr/bin/env bash
# Run as 'frappe' (needs sudo). Usage: SITE=helpdesk.example.com ./03-production.sh
set -euo pipefail
: "${SITE:?Set SITE, e.g. SITE=helpdesk.example.com}"
export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"
export PATH="$HOME/.local/bin:$PATH"
cd ~/frappe-bench

sudo apt install -y ansible
sudo env "PATH=$PATH" bench setup production frappe
sudo chmod -R o+rx /home/frappe/

# Supervisor cannot see nvm's Node, so link it (fixes node-socketio BACKOFF)
sudo ln -sf "$(which node)" /usr/local/bin/node
sudo supervisorctl restart frappe-bench-web:frappe-bench-node-socketio || true

bench --site "$SITE" clear-cache
bench --site "$SITE" migrate

sudo ufw allow OpenSSH      # case-sensitive
sudo ufw --force enable

sudo supervisorctl status
curl -I -H "Host: $SITE" http://localhost
echo
echo "NEXT: create the Cloudflare Tunnel (docs/06-cloudflare-tunnel.md)"
