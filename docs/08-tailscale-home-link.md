# 8. Link the VM to a home PC (Tailscale)

> Recommended design, not yet verified in this build.

Tailscale gives the VM and your home PC a private network with no port forwarding.

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

Install Tailscale on the home PC as well and sign in to the same account. Then:

- SSH to the VM from anywhere: `ssh user@<vm-tailscale-ip>`
- Push backups to the home PC: `scripts/backup-offsite.sh`

For unattended rsync, set up SSH key login from the VM's `frappe` user to the home PC (`ssh-keygen`, then `ssh-copy-id`).

## Standby server at home

Build a second VM at home with sections 1 to 5, and keep it **off** (or with no tunnel). If the office machine dies:

1. Restore the latest backup on the home VM ([09](09-disaster-recovery.md)).
2. Stop the tunnel connector on the failed server, or delete it in Cloudflare.
3. Start the connector on the home VM.

Only one connector may be active at a time.
