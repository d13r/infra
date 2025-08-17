# Hyper-V Setup

This is partially scripted using PowerShell, which needs to be run as Administrator. The `bin/hyperv` script will handle UAC automatically.

While there is a [Terraform provider](https://github.com/taliesins/terraform-provider-hyperv) available, it looks like it requires a lot of manual setup.

At some point I might look into setting up [Cloud-init for Subiquity](https://canonical-subiquity.readthedocs-hosted.com/en/latest/explanation/cloudinit-autoinstall-interaction.html) to automate the installation too, or maybe [these scripts](https://github.com/schtritoff/hyperv-vm-provisioning) to adapt the Ubuntu cloud image to skip installation altogether.

## Setting up a new VM

Create DNS records and so on using OpenTofu:

```bash
vim tofu/EXAMPLE.tf
bin/tofu apply
```

Create the VM:

```bash
vim hyper-v/HOST.ps1
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
    - Enter the server name (local part only - e.g. "example")
    - Choose a username and password that you will use to log in
- Upgrade to Ubuntu Pro
    - Skip
- SSH Setup
    - Tick "Install OpenSSH Server"
    - Select "Import SSH identity from GitHub" - enter `d13r`
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
ssh dave@EXAMPLE
wget djm.me/cfg
. cfg
setup-root-ssh
exit
```

Provision software:

```bash
vim ansible/inventory.ini
vim ansible/provision-EXAMPLE.yml
bin/provision EXAMPLE
```

Add it to dotfiles (optional):

```bash
vim ~/.ssh/config
```
