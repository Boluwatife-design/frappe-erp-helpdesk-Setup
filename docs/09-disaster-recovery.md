# 9. Disaster recovery runbook

## Keep the VM alive (Windows host)

VirtualBox VMs do not start on their own. Create a Task Scheduler task, trigger "At startup", action:

```
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "YourVMName" --type headless
```

Set Windows power settings to never sleep.

## Rebuild from nothing

1. [00-security-first.md](00-security-first.md) if a device was lost.
2. Sections 1 to 5 to get a bare site with the **same site name** and **same app versions**.
3. Restore (below).
4. Section 6: create a new tunnel and route.
5. Rotate the Administrator password.

## Restore

Copy the backup files to the new VM, then use `scripts/restore.sh`, or manually:

```bash
cd ~/frappe-bench
bench --site helpdesk.example.com restore /path/db.sql.gz \
  --with-public-files /path/files.tar --with-private-files /path/private-files.tar
bench --site helpdesk.example.com migrate
```

Set the old `encryption_key` in the new site's `site_config.json` **before** using the site, or encrypted fields will be broken.

Backups are tied to the version they were made on. Restoring an older version's backup onto a newer one needs `bench migrate` and is effectively one-way.

## Keep a record

Write down: VM specs, the Ubuntu and Frappe versions, the tunnel name, where backups live, and where passwords are stored (a password manager, not this repo).
