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
<img width="434" height="340" alt="image" src="https://github.com/user-attachments/assets/c0a30a0c-c905-4b42-9ae5-d00e94d74fd2" />

If the list is **empty**:

```bash
bench setup supervisor --yes
sudo ln -sf ~/frappe-bench/config/supervisor.conf /etc/supervisor/conf.d/frappe-bench.conf
sudo supervisorctl reread && sudo supervisorctl update
```
<img width="1069" height="839" alt="Screenshot 2026-11-16 140727" src="https://github.com/user-attachments/assets/6270dd44-2951-43fb-b495-e85600d0343b" />

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
<img width="439" height="65" alt="image" src="https://github.com/user-attachments/assets/625f54c7-c5f7-4a39-9d86-1a3471b13d0e" />

## Reboot test

```bash
sudo reboot
# after boot:
sudo supervisorctl status
```
