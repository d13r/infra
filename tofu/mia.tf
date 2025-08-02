resource "cloudflare_dns_record" "mia_djm_me_A" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "mia.djm.me"
  type    = "A"
  content = local.chell_hyperv_ipv4_mia
  ttl     = 1
}

resource "cloudflare_dns_record" "STAR_mia_djm_me_CNAME" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "*.mia.djm.me"
  type    = "CNAME"
  content = "mia.djm.me"
  ttl     = 1
}

resource "aws_iam_user" "mia_ses_postfix" {
  name = "mia-postfix-ses"
}

resource "aws_iam_user_group_membership" "mia_ses_postfix_sending" {
  user   = aws_iam_user.mia_ses_postfix.name
  groups = [data.aws_iam_group.ses_sending.group_name]
}

resource "aws_iam_access_key" "mia_ses_postfix" {
  user = aws_iam_user.mia_ses_postfix.name
}

output "mia_postfix_smtp_username" {
  value = aws_iam_access_key.mia_ses_postfix.id
}

output "mia_postfix_smtp_password" {
  value     = aws_iam_access_key.mia_ses_postfix.ses_smtp_password_v4
  sensitive = true
}
