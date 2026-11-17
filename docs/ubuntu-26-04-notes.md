# Ubuntu 26.04 specific notes

Ubuntu 26.04 LTS is newer than most Frappe guides assume. These are the differences that mattered.

| Topic | Older guides (Ubuntu 22.04, Frappe v15) | This build (Ubuntu 26.04, Frappe v16) |
|---|---|---|
| Python | 3.10 / 3.11 | **3.14**. Install `python3.14-dev` and `python3.14-venv` |
| Frappe | `version-15` | **`version-16`** (v15 does not support Python 3.14) |
| Node.js | 18 | **24** |
| Bench install | `sudo pip3 install frappe-bench` | **`uv tool install frappe-bench`** (system pip is blocked) |
| Production setup | `sudo bench setup production frappe` | `sudo apt install ansible`, then `sudo env "PATH=$PATH" bench setup production frappe` |
| Helpdesk branch | default | **`--branch main`** (default `develop` targets Frappe v17) |
| Helpdesk dependency | none | **Telephony** app |
| MariaDB hardening | `mysql_secure_installation` | `mariadb-secure-installation` |
| Supervisor and nvm | worked | `node-socketio` needs Node linked into `/usr/local/bin` |

## The "match the version" rule

Frappe apps must match the Frappe framework version:

```bash
bench version      # shows frappe / erpnext / helpdesk versions and branches
```

If an app warns that Frappe "does not satisfy required version", you are on the wrong branch for that app.
Use `bench remove-app` and `get-app --branch <right-one>` instead of forcing it.

Check current compatibility before installing, because supported branches change:
https://github.com/frappe/helpdesk (compatibility table) and https://docs.frappe.io/helpdesk/installation
