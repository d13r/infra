# Hyper-V Setup

Create DNS records and so on:

```bash
vim tofu/example.tf
bin/tofu apply
```

Create the VM:

```bash
vim hyper-v/host.ps1
bin/hyperv
```

Start the VM and install Ubuntu:

- Language
    - Select "English (UK)"
- Installer update
    - If prompted, update to the new installer
- Keyboard configuration
    - Check layout and variant are set to "English (UK)"
- Choose type of install
    - Leave the default selection, "Ubuntu Server"
- Network connections
    - Select "eth1", then "Edit IPv4"
        - Select method "Manual"
        - Enter subnet "192.168.5.0/24"
        - Enter address "192.168.5.2" (make sure the last part is unique for each VM)
        - Leave the other fields blank
- Configure proxy
    - Leave it blank
- Configure Ubuntu archive mirror
    - Leave the default value
- Guided storage configuration
    - Leave the default selection, "Use An Entire Disk"
- Storage configuration
    - Change "ubuntu-lv" to use all available space (just enter "999")
    - Select "Done", then "Continue"
- Profile setup
    - Enter your name
    - Enter the server name (local part only - e.g. "kara")
    - Choose a username and password that you will use to log in
- Upgrade to Ubuntu Pro
    - Skip
- SSH Setup
    - Tick "Install OpenSSH Server"
    - Optionally select "Import SSH identity from GitHub" and enter your username to import your SSH key
- Featured Server Snaps
    - Don't select any
- Installing system
    - Wait for it to finish
- Installation complete!
    - Select "Reboot Now"
    - When prompted, press Enter to reboot (the virtual DVD is ejected automatically - ignore any "Failed unmounting cdrom" errors)

Take a snapshot (optional).

Close the window and the main Hyper-V window.

Set up SSH for the root user:

```bash
ssh dave@example
wget djm.me/cfg
. cfg
setup root
exit
```

Provision software:

```bash
vim ansible/inventory.ini
vim ansible/provision-example.yml
bin/provision example
```

Add it to dotfiles (optional):

```bash
vim ~/.ssh/config
```
