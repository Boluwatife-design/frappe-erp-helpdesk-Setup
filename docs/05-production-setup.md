# 5. Production setup

```bash
cd ~/frappe-bench
sudo apt install -y ansible
sudo env "PATH=$PATH" bench setup production frappe
sudo chmod -R o+rx /home/frappe/
bench --site helpdesk.example.com clear-cache
bench --site helpdesk.example.com migrate
```

## Check services

```bash
sudo supervisorctl status
```

All of these should be RUNNING: redis-cache, redis-queue, frappe-web, node-socketio, long/short workers, schedule.

If the list is **empty**:

```bash
bench setup supervisor --yes
sudo ln -sf ~/frappe-bench/config/supervisor.conf /etc/supervisor/conf.d/frappe-bench.conf
sudo supervisorctl reread && sudo supervisorctl update
```

If `node-socketio` is **BACKOFF** (Supervisor cannot see nvm's Node):

```bash
tail -20 ~/frappe-bench/logs/node-socketio.error.log
sudo ln -sf "$(which node)" /usr/local/bin/node
sudo supervisorctl restart frappe-bench-web:frappe-bench-node-socketio
```

## Test locally

```bash
curl -I -H "Host: helpdesk.example.com" http://localhost
```

Expect 200 or 301/302. The `Host` header is required, plain `localhost` is rejected.

## Firewall

The tunnel is outbound only, so only SSH needs to be open. The profile name is case-sensitive:

```bash
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status
```

## Reboot test

```bash
sudo reboot
# after boot:
sudo supervisorctl status
```
