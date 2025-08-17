# Ansible

I use [Ansible](https://docs.ansible.com/ansible/latest/index.html) to provision servers, including creating user accounts, installing & configuring software, and setting up projects/websites.

I considered using [Puppet](https://www.puppet.com/), which we use at work, but I don't want the complexity or overhead of running a server. I could try [Bolt](https://github.com/puppetlabs/bolt), but the recent [licence controversy](https://en.wikipedia.org/w/index.php?title=Puppet_(software)&oldid=1305543261#Controversy) puts me off. Maybe when [OpenBolt](https://github.com/OpenVoxProject/openbolt) is more mature I'll give that a go...

The benefits over shell scripts, which I used before this, are:

- Ansible modules are often simpler to use than the equivalent shell commands
- I can define dependencies between roles (without causing them to be run more than once)
- I can use [Jinja](https://jinja.palletsprojects.com/en/stable/) templates to generate files

## Usage

Provisioning servers:

```bash
bin/provision host1,host2 [-t role1,role2]
```

Lower-level commands:

```bash
bin/ansible -m ping all
bin/ansible-playbook playbook.yml [-l running] [-t tag1]
```

Other helpers:

```bash
bin/ping [-l host1,host2]
bin/facts [-l host1,host2]
bin/encrypt
bin/decrypt host_vars/host1.yml [varname]
```
