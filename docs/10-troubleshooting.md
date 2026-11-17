# 10. Troubleshooting (errors that actually happened)

| Error | Cause | Fix |
|---|---|---|
| `Unsupported file ./wkhtmltox_*.deb` | The .deb was never downloaded | `wget` it first ([02](02-install-prerequisites.md)) |
| `bash: .../99-frappe.cnf: No such file` | Path was run as a command | Create the file with `tee` or `cp` |
| `mysql_secure_installation: command not found` | Renamed in newer MariaDB | `sudo mariadb-secure-installation` |
| `externally-managed-environment` | Ubuntu 24.04+/26.04 blocks system pip | Use `uv tool install frappe-bench` |
| `bench: command not found` | bench is installed per user | Switch with `su - frappe`; `source ~/.local/bin/env` |
| `Failed to build mysqlclient` | Missing headers | `sudo apt install python3.14-dev libmariadb-dev pkg-config` |
| Node / yarn errors in `bench init` | Node is not 24 | `nvm install 24 && nvm alias default 24` |
| `Site ... already exists` | Earlier `new-site` was interrupted | Drop and recreate; see below |
| MySQL `1698 Access denied for user '_xxxx'` | Half-created site DB user | Drop the site and the leftover `_xxxx` database/user |
| MySQL `1045/1698 Access denied for 'frappe'` or another name | A name was typed at `Enter mysql super user [root]:` | Press Enter to accept `root`. The password comes on the next prompt |
| `supervisorctl restart frappe: ... no such group` | Production is not set up yet | Ignore until section 5 |
| Redis `Connection refused 127.0.0.1:11000` during install | Redis not running yet | Ignore; `clear-cache` after production |
| `does not satisfy required version '>=17.0.0-dev'` and `@framework/ui/EmailAccounts` build error | Helpdesk default branch targets Frappe v17 | `bench remove-app helpdesk`, then `bench get-app helpdesk --branch main` |
| `Required frappe-dependency 'telephony' not found` | Helpdesk needs Telephony | `bench get-app telephony` and install it |
| `supervisorctl status` is empty | Supervisor config not linked | See [05](05-production-setup.md) |
| `node-socketio` BACKOFF | Supervisor cannot find nvm's Node | `sudo ln -sf "$(which node)" /usr/local/bin/node` and restart it |
| `ufw: Could not find a profile matching 'openSSH'` | Profile names are case-sensitive | `sudo ufw allow OpenSSH` |
| Two identical users on login screen | Full name of `frappe` equals your own | `sudo chfn -f "Frappe" frappe` |

## Clean up a half-created site

```bash
bench drop-site helpdesk.example.com --force     # root user: press Enter, then the root password
# if that fails:
rm -rf ~/frappe-bench/sites/helpdesk.example.com
sudo mariadb -e "SHOW DATABASES;"
sudo mariadb -e "DROP DATABASE IF EXISTS \`_xxxxxxxx\`; DROP USER IF EXISTS '_xxxxxxxx'@'localhost'; FLUSH PRIVILEGES;"
```

Only drop databases starting with an underscore. Never drop `mysql`, `sys`, `information_schema`, `performance_schema`.
