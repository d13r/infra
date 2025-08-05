# DNS
resource "cloudflare_dns_record" "katniss_djm_me_A" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "katniss.djm.me"
  type    = "A"
  content = local.chell_hyperv_ipv4_katniss
  ttl     = 1
}

resource "cloudflare_dns_record" "STAR_katniss_djm_me_CNAME" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "*.katniss.djm.me"
  type    = "CNAME"
  content = "katniss.djm.me"
  ttl     = 1
}

# SMTP user
resource "aws_iam_user" "katniss_ses_postfix" {
  name = "katniss-postfix-ses"
}

resource "aws_iam_user_group_membership" "katniss_ses_postfix_sending" {
  user   = aws_iam_user.katniss_ses_postfix.name
  groups = [data.aws_iam_group.ses_sending.group_name]
}

resource "aws_iam_access_key" "katniss_ses_postfix" {
  user = aws_iam_user.katniss_ses_postfix.name
}

output "katniss_postfix_smtp_username" {
  value = aws_iam_access_key.katniss_ses_postfix.id
}

output "katniss_postfix_smtp_password" {
  value     = aws_iam_access_key.katniss_ses_postfix.ses_smtp_password_v4
  sensitive = true
}

# Cloudflare token for Certbot
resource "cloudflare_api_token" "katniss_certbot" {
  name = "Certbot on katniss.djm.me"
  policies = [
    {
      effect = "allow"
      permission_groups = [
        { id = data.cloudflare_account_api_token_permission_groups_list.zone_write.result[0].id }
      ]
      resources = {
        "com.cloudflare.api.account.zone.${data.cloudflare_zone.djm_me.zone_id}" = "*"
      }
    }
  ]
}

output "katniss_cloudflare_certbot_token" {
  value     = cloudflare_api_token.katniss_certbot.value
  sensitive = true
}
