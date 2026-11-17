# 3. frappe user, Node 24, uv and bench

## Create the user

```bash
sudo adduser frappe
sudo usermod -aG sudo frappe
su - frappe
```

> The login screen shows the user's *full name*. If you typed your own name at the adduser prompt you will see two identical entries. Fix with `sudo chfn -f "Frappe" frappe`.

From here on, **do all Frappe work as `frappe`**. nvm, uv and bench are installed per user.

## Node 24 (not 18)

Frappe v16 needs Node 24.

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install 24
nvm alias default 24
npm install -g yarn
node --version     # v24.x
```

## uv and bench

Ubuntu 26.04 blocks system-wide `pip` (externally-managed-environment) and Frappe v16 uses uv.

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc
uv tool install frappe-bench
bench --version
```

If `bench` is not found: `source ~/.local/bin/env`.

## Initialize

```bash
cd ~
bench init --frappe-branch version-16 frappe-bench
```

Takes 5 to 15 minutes. Do not close the terminal. Expect "Bench frappe-bench initialized".
