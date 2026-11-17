# 3. frappe user, Node 24, uv and bench

## Create the user

```bash
sudo adduser frappe
sudo usermod -aG sudo frappe
su - frappe
```
<img width="744" height="517" alt="Screenshot 2026-11-16 113421" src="https://github.com/user-attachments/assets/2a180294-b929-46a4-923e-78af558ad95e" />

> The login screen shows the user's *full name*. If you typed your own name at the adduser prompt you will see two identical entries. Fix with `sudo chfn -f "Frappe" frappe`.
<img width="606" height="427" alt="Screenshot 2026-11-16 130440" src="https://github.com/user-attachments/assets/8bcd467f-6df2-4cd4-8664-6fedb58a9364" />


From here on, **do all Frappe work as `frappe`**. nvm, uv and bench are installed per user.

## Node 24 (not 18)
<img width="927" height="693" alt="image" src="https://github.com/user-attachments/assets/625e6561-ef56-46cc-a8ce-88dba8813c3d" />

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
<img width="1032" height="764" alt="image" src="https://github.com/user-attachments/assets/8b53d62a-774c-4950-b208-51f99ecd0858" />

If `bench` is not found: `source ~/.local/bin/env`.

## Initialize

```bash
cd ~
bench init --frappe-branch version-16 frappe-bench
```
<img width="723" height="694" alt="Screenshot 2026-11-16 114250" src="https://github.com/user-attachments/assets/2d4241ca-8fff-4f5b-96a1-bed2b4e5327e" />, <img width="1026" height="776" alt="Screenshot 2026-11-16 114755" src="https://github.com/user-attachments/assets/72d7261c-2302-4122-bb0e-bcad4170ec63" />, <img width="1034" height="753" alt="Screenshot 2026-11-16 114809" src="https://github.com/user-attachments/assets/8c56998c-915e-4e39-84a7-1695bf92236d" />




Takes 5 to 15 minutes. Do not close the terminal. Expect "Bench frappe-bench initialized".
