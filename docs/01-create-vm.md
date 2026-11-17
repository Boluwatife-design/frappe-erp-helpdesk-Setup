# 1. Create the VM (VirtualBox)

| Setting | Value |
|---|---|
| ISO | Ubuntu Server (or Desktop) **26.04 LTS** |
| RAM | 4 GB minimum, 8 GB better |
| CPUs | 2 or more |
| Disk | 60 GB, dynamically allocated |
| Network | **Bridged Adapter** (NAT also works, the tunnel is outbound only) |

During install, enable **OpenSSH server** if offered.

After first boot:

```bash
sudo apt update && sudo apt upgrade -y
sudo timedatectl set-timezone Africa/Lagos   # use your own timezone
lsb_release -a && python3 --version          # expect 26.04 and Python 3.14.x
```

Keep the VM running 24/7 (see [09-disaster-recovery.md](09-disaster-recovery.md) for autostart on Windows).
