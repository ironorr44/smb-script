## SMB Setup Script for Linux
#### Purpose
Provides a quick CLI method for setting up an SMB share to a locally hosted server/NAS
#### Details
Asks for IP/Hostname of the server, the share, and the user credentials. The share is mounted to a directory of the same name as the share at /mnt/smb.

Copy/Paste the following command into the terminal:
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/ironorr44/smb-script/refs/heads/main/smb-setup.sh)"
```
