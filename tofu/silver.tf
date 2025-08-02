# VM
resource "hcloud_server" "silver" {
  name         = "silver.djm.me"
  server_type  = "cx22" # 2 vCPU (Intel), 4 GB RAM, 40 GB SSD, 20 TB traffic
  image        = "debian-12"
  location     = "hel1"
  backups      = true
  firewall_ids = [hcloud_firewall.web_server.id]
  ssh_keys     = [hcloud_ssh_key.personal.id]

  lifecycle {
    ignore_changes = [ssh_keys]
  }
}

# DNS
resource "cloudflare_dns_record" "silver_djm_me_A" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "silver.djm.me"
  type    = "A"
  content = hcloud_server.silver.ipv4_address
  ttl     = 1
}

resource "cloudflare_dns_record" "silver_djm_me_AAAA" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "silver.djm.me"
  type    = "AAAA"
  content = hcloud_server.silver.ipv6_address
  ttl     = 1
}

# Reverse DNS
resource "hcloud_rdns" "silver_ipv4" {
  server_id  = hcloud_server.silver.id
  ip_address = hcloud_server.silver.ipv4_address
  dns_ptr    = "silver.djm.me"
}

resource "hcloud_rdns" "silver_ipv6" {
  server_id  = hcloud_server.silver.id
  ip_address = hcloud_server.silver.ipv6_address
  dns_ptr    = "silver.djm.me"
}

# SMTP user
resource "aws_iam_user" "silver_ses_postfix" {
  name = "silver-postfix-ses"
}

resource "aws_iam_user_group_membership" "silver_ses_postfix_sending" {
  user   = aws_iam_user.silver_ses_postfix.name
  groups = [data.aws_iam_group.ses_sending.group_name]
}

resource "aws_iam_access_key" "silver_ses_postfix" {
  user = aws_iam_user.silver_ses_postfix.name
}

output "silver_postfix_smtp_username" {
  value = aws_iam_access_key.silver_ses_postfix.id
}

output "silver_postfix_smtp_password" {
  value     = aws_iam_access_key.silver_ses_postfix.ses_smtp_password_v4
  sensitive = true
}
