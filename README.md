# Infrastructure

- [OpenTofu (Terraform)](tofu/) for DNS, cloud VMs and other cloud resources
- PowerShell scripts for local [Hyper-V](hyper-v/) VMs
- [Ansible](ansible/) for software provisioning

## Why automate these?

Given the small scale, I could easily manage these resources manually. However, automation makes it easier to:

- Set up new dev/test environments, ensuring consistency between them.
- Replace a VM, e.g. to try a different cloud provider or operating system.
- Delete resources and API keys when they're no longer needed.

It also serves as documentation and a history of changes.

## Setup

```bash
git clone git@github.com:d13r/infra.git
cd infra
bin/setup
vim .env
```

## Usage

See the README in each folder, linked above.
