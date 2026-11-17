# Frappe ERPNext + Helpdesk on Ubuntu 26.04 (VirtualBox) with Cloudflare Tunnel

Rebuild guide for a self-hosted **Frappe v16 / ERPNext / Helpdesk** server running in a
VirtualBox VM, published with HTTPS through a **Cloudflare Tunnel** (no open router ports),
with backups and a disaster-recovery plan.

Written after a real rebuild on Ubuntu 26.04 LTS. Every error that came up is in
[docs/10-troubleshooting.md](docs/10-troubleshooting.md).

> Replace `helpdesk.example.com` / `example.com` with your own domain everywhere.
> Never commit passwords, tunnel tokens, `site_config.json` or backup files. See `.gitignore`.

## Versions that worked together

| Component | Version / branch |
|---|---|
| Ubuntu Server | 26.04 LTS (Python 3.14) |
| Frappe | `version-16` (16.56.0) |
| ERPNext | `version-16` (16.55.0) |
| Helpdesk | **`main`** branch (1.32.0) |
| Telephony (Helpdesk dependency) | default branch |
| Node.js | **24** (via nvm) |
| Bench | 5.31.1, installed with **uv** |
| Database | MariaDB (Ubuntu package) |

The important Ubuntu 26.04 specifics (Python 3.14, Node 24, uv, Helpdesk `main`) are collected in
[docs/ubuntu-26-04-notes.md](docs/ubuntu-26-04-notes.md).

## Guide order

| # | Document | What it covers |
|---|---|---|
| 0 | [00-security-first.md](docs/00-security-first.md) | What to lock down first if a machine is lost |
| 1 | [01-create-vm.md](docs/01-create-vm.md) | VirtualBox VM and Ubuntu install |
| 2 | [02-install-prerequisites.md](docs/02-install-prerequisites.md) | Packages, MariaDB, wkhtmltopdf |
| 3 | [03-frappe-user-and-bench.md](docs/03-frappe-user-and-bench.md) | frappe user, Node 24, uv, bench init |
| 4 | [04-site-and-apps.md](docs/04-site-and-apps.md) | Create site, install ERPNext + Helpdesk |
| 5 | [05-production-setup.md](docs/05-production-setup.md) | nginx, Supervisor, firewall |
| 6 | [06-cloudflare-tunnel.md](docs/06-cloudflare-tunnel.md) | HTTPS via Cloudflare Tunnel |
| 7 | [07-backups.md](docs/07-backups.md) | Daily backups, off-machine copies |
| 8 | [08-tailscale-home-link.md](docs/08-tailscale-home-link.md) | Link the VM to a home PC |
| 9 | [09-disaster-recovery.md](docs/09-disaster-recovery.md) | Rebuild and restore runbook |
| 10 | [10-troubleshooting.md](docs/10-troubleshooting.md) | Every error hit, with fixes |
| - | [ubuntu-26-04-notes.md](docs/ubuntu-26-04-notes.md) | Version-specific notes |

## Scripts

| Script | Run as | Purpose |
|---|---|---|
| `scripts/01-system-prereqs.sh` | sudo-capable user | Packages, MariaDB config, wkhtmltopdf |
| `scripts/02-frappe-user-setup.sh` | `frappe` | Node 24, uv, bench, site, apps |
| `scripts/03-production.sh` | `frappe` | Production setup, firewall, socketio fix |
| `scripts/backup-offsite.sh` | `frappe` (cron) | Copy backups to a home PC over Tailscale |
| `scripts/restore.sh` | `frappe` | Restore a backup onto a fresh site |

Read the docs before running scripts. The scripts stop at the points that need your input
(passwords, Cloudflare dashboard).

## Status of each part

- Sections 1 to 6 were done and verified end to end (site loads over HTTPS, Helpdesk works).
- Sections 7 to 9 (backups, Tailscale, standby) are a recommended design. Test them before relying on them.
