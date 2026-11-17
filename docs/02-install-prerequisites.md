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
<img width="976" height="630" alt="Screenshot 2026-11-16 113957" src="https://github.com/user-attachments/assets/be5fa6b2-ddf0-488a-a50b-e1aa77e22aa2" />
<img width="1019" height="798" alt="Screenshot 2026-11-16 113102" src="https://github.com/user-attachments/assets/79d42d0b-b2fa-4f31-8fe7-5433bb345575" />

## wkhtmltopdf (PDF printing)

```bash
cd ~
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb
sudo apt install -y ./wkhtmltox_0.12.6.1-2.jammy_amd64.deb
wkhtmltopdf --version        # should mention "with patched qt"
```
<img width="744" height="517" alt="Screenshot 2026-11-16 113421" src="https://github.com/user-attachments/assets/5f01d007-ef5d-4756-b060-d9802b40228b" />

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
<img width="929" height="756" alt="Screenshot 2026-11-16 113046" src="https://github.com/user-attachments/assets/85564f01-9163-4770-9a83-f667de3a92bc" />

If bench later cannot log in as root, set the password explicitly:

```bash
sudo mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('YOUR_PASSWORD'); FLUSH PRIVILEGES;"
```

Check the character set: `sudo mariadb -e "SHOW VARIABLES LIKE 'character_set_server';"` should show `utf8mb4`.
