# 2. Install prerequisites

Run as your normal sudo-capable user. `scripts/01-system-prereqs.sh` does the package part for you.

## Packages

```bash
sudo apt install -y git python3-dev python3-setuptools python3-pip python3-venv \
  python3.14-dev python3.14-venv libmariadb-dev pkg-config \
  redis-server software-properties-common mariadb-server mariadb-client \
  xvfb libfontconfig curl cron supervisor nginx fail2ban ufw
```

`python3.14-dev` and `libmariadb-dev` are required. Without them `bench init` fails building `mysqlclient`.

## wkhtmltopdf (PDF printing)

```bash
cd ~
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb
sudo apt install -y ./wkhtmltox_0.12.6.1-2.jammy_amd64.deb
wkhtmltopdf --version        # should mention "with patched qt"
```

Download the file first. Running `apt install ./wkhtmltox_*.deb` before downloading gives `Unsupported file`.
If dependencies are missing: `sudo apt --fix-broken install -y`.

## MariaDB character set

Create the config **file** (do not run its path as a command, and do not `mkdir` it):

```bash
sudo cp config/99-frappe.cnf /etc/mysql/mariadb.conf.d/99-frappe.cnf
sudo systemctl restart mariadb
```

## Secure MariaDB

On current MariaDB the command is `mariadb-secure-installation` (the old `mysql_secure_installation` is gone).

```bash
sudo mariadb-secure-installation
```

| Question | Answer |
|---|---|
| Current root password | Enter (none yet) |
| Switch to unix_socket authentication | **n** |
| Change root password | **Y**, set a strong one, store it in a password manager |
| Remove anonymous users | Y |
| Disallow root login remotely | Y |
| Remove test database | Y |
| Reload privilege tables | Y |

If bench later cannot log in as root, set the password explicitly:

```bash
sudo mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('YOUR_PASSWORD'); FLUSH PRIVILEGES;"
```

Check the character set: `sudo mariadb -e "SHOW VARIABLES LIKE 'character_set_server';"` should show `utf8mb4`.
