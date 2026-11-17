# 7. Backups

> This section is the recommended design. Test a restore before relying on it.

## What to back up

1. The database
2. Public and private files
3. `site_config.json`, which holds the **`encryption_key`**. Without it, encrypted fields (passwords, API keys) in a restored site are unreadable.

## Daily backup

`crontab -e` as `frappe`:

```
0 2 * * * cd /home/frappe/frappe-bench && /home/frappe/.local/bin/bench --site helpdesk.example.com backup --with-files >> /home/frappe/backup.log 2>&1
30 3 * * * /home/frappe/backup-offsite.sh >> /home/frappe/backup.log 2>&1
```

Backups land in `sites/helpdesk.example.com/private/backups/`.

## Off-machine copies

A backup on the same VM is not a backup. Keep at least two other copies in different places:

- Home PC over Tailscale: `scripts/backup-offsite.sh` (see [08](08-tailscale-home-link.md))
- Cloud: `rclone` to Google Drive or Backblaze (encrypt with `rclone crypt`)
- A VirtualBox export (File, Export Appliance) after the system works

Store the copy of `site_config.json` somewhere encrypted.

## Restore test

Do this on a spare VM every few months. See [09-disaster-recovery.md](09-disaster-recovery.md).
