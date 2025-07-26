resource "cloudflare_dns_record" "kuma_djm_me_CNAME" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "kuma.djm.me"
  type    = "CNAME"
  content = "silver.djm.me"
  ttl     = 1
}

resource "aws_iam_user" "kuma_ses" {
  name = "kuma-ses"
}

resource "aws_iam_access_key" "kuma_ses" {
  user = aws_iam_user.kuma_ses.name
}

output "kuma_smtp_username" {
  value = aws_iam_access_key.kuma_ses.id
}

output "kuma_smtp_password" {
  value     = aws_iam_access_key.kuma_ses.ses_smtp_password_v4
  sensitive = true
}

