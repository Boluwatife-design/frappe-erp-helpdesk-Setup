# 4. Create the site and install apps

The site name **must equal the public hostname**, because Frappe routes by hostname.

```bash
cd ~/frappe-bench
bench new-site helpdesk.example.com
```

Prompts:

| Prompt | What to enter |
|---|---|
| `Enter mysql super user [root]:` | Just press **Enter**. This asks for a *username*, not a password. |
| `MySQL root password:` | The MariaDB root password from section 2 |
| `Set Administrator password:` | A new strong password for the ERP login |

Do not restart the VM while this runs. If interrupted, see troubleshooting ("Site already exists").

## Download apps

```bash
bench get-app --branch version-16 erpnext
bench get-app telephony
bench get-app helpdesk --branch main
```

**Use `--branch main` for Helpdesk.** Helpdesk's default branch (`develop`) now targets Frappe v17 and fails to build on v16.
Helpdesk depends on the Telephony app, so fetch it too.

A "no such group" / `supervisorctl restart frappe:` error at the end of `get-app` is harmless before production setup.

## Install on the site

```bash
bench --site helpdesk.example.com install-app erpnext
bench --site helpdesk.example.com install-app telephony
bench --site helpdesk.example.com install-app helpdesk
bench --site helpdesk.example.com set-config host_name "https://helpdesk.example.com"
bench --site helpdesk.example.com enable-scheduler
bench --site helpdesk.example.com list-apps
```

Expected: `frappe`, `erpnext`, `telephony`, `helpdesk`. A Redis "connection refused" on port 11000 during install is expected before production setup.
