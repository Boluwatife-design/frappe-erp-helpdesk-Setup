# 0. Security first (if a machine was lost or stolen)

Do this before rebuilding.

1. **Cloudflare:** change the account password and make sure 2FA is on.
2. **Delete the old tunnel:** Zero Trust, Networks, Tunnels. The lost machine holds its credentials.
3. **Revoke API tokens:** My Profile, API Tokens.
4. **Lock/wipe the lost device** using your OS account's "find my device" feature, and change that account's password.
5. **Rotate the ERP `Administrator` password** once the new system is up. Old sessions may exist.
6. **Delete the old DNS record** for the hostname so the new tunnel can create its own.

Full-disk encryption (BitLocker/FileVault/LUKS) greatly reduces the risk, but still rotate secrets.
