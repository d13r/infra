# VM
resource "hcloud_server" "artemis" {
  name         = "artemis.djm.me"
  server_type  = "cx22" # 2 vCPU (Intel), 4 GB RAM, 40 GB SSD, 20 TB traffic
  image        = "ubuntu-24.04"
  location     = "hel1"
  backups      = true
  firewall_ids = [hcloud_firewall.web_server.id]
  ssh_keys     = [hcloud_ssh_key.personal.id]

  lifecycle {
    ignore_changes = [ssh_keys]
  }
}

# DNS
resource "cloudflare_dns_record" "artemis_djm_me_A" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "artemis.djm.me"
  type    = "A"
  content = hcloud_server.artemis.ipv4_address
  ttl     = 1
}

resource "cloudflare_dns_record" "artemis_djm_me_AAAA" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "artemis.djm.me"
  type    = "AAAA"
  content = hcloud_server.artemis.ipv6_address
  ttl     = 1
}

# Reverse DNS
resource "hcloud_rdns" "artemis_ipv4" {
  server_id  = hcloud_server.artemis.id
  ip_address = hcloud_server.artemis.ipv4_address
  dns_ptr    = "artemis.djm.me"
}

resource "hcloud_rdns" "artemis_ipv6" {
  server_id  = hcloud_server.artemis.id
  ip_address = hcloud_server.artemis.ipv6_address
  dns_ptr    = "artemis.djm.me"
}

# SMTP user
resource "aws_iam_user" "artemis_ses_postfix" {
  name = "artemis-postfix-ses"
}

resource "aws_iam_user_group_membership" "artemis_ses_postfix_sending" {
  user   = aws_iam_user.artemis_ses_postfix.name
  groups = [data.aws_iam_group.ses_sending.group_name]
}

resource "aws_iam_access_key" "artemis_ses_postfix" {
  user = aws_iam_user.artemis_ses_postfix.name
}

output "artemis_postfix_smtp_username" {
  value = aws_iam_access_key.artemis_ses_postfix.id
}

output "artemis_postfix_smtp_password" {
  value     = aws_iam_access_key.artemis_ses_postfix.ses_smtp_password_v4
  sensitive = true
}

# Initial password for Ansible (used for sudo)
resource "random_password" "artemis_dave_password" {
  length = 20
}

output "artemis_dave_password" {
  value     = random_password.artemis_dave_password.result
  sensitive = true
}
