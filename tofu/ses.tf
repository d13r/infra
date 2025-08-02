resource "aws_sesv2_email_identity" "djm_me" {
  email_identity = "djm.me"
}

resource "aws_sesv2_email_identity" "work_email" {
  email_identity = "dave.miller@maths.ox.ac.uk"
}

resource "aws_sesv2_email_identity_mail_from_attributes" "djm_me" {
  email_identity   = aws_sesv2_email_identity.djm_me.email_identity
  mail_from_domain = "ses.${aws_sesv2_email_identity.djm_me.email_identity}"
}

resource "cloudflare_dns_record" "ses_domainkey_djm_me_CNAME" {
  count = 3

  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "${element(aws_sesv2_email_identity.djm_me.dkim_signing_attributes[0].tokens, count.index)}._domainkey.djm.me"
  type    = "CNAME"
  content = "${element(aws_sesv2_email_identity.djm_me.dkim_signing_attributes[0].tokens, count.index)}.dkim.amazonses.com"
  ttl     = 1
}

resource "cloudflare_dns_record" "ses_djm_me_MX" {
  zone_id  = data.cloudflare_zone.djm_me.zone_id
  name     = aws_sesv2_email_identity_mail_from_attributes.djm_me.mail_from_domain
  type     = "MX"
  priority = 10
  content  = "feedback-smtp.${data.aws_region.default.region}.amazonses.com"
  ttl      = 1
}

resource "cloudflare_dns_record" "ses_djm_me_TXT" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = aws_sesv2_email_identity_mail_from_attributes.djm_me.mail_from_domain
  type    = "TXT"
  content = "\"v=spf1 include:amazonses.com -all\""
  ttl     = 1
}

data "aws_iam_group" "ses_sending" {
  group_name = "AWSSESSendingGroupDoNotRename"
}
