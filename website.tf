data "netlify_site" "djm_me" {
  name = "djm"
}

resource "netlify_site_domain_settings" "djm_me" {
  site_id       = data.netlify_site.djm_me.id
  custom_domain = "djm.me"

  domain_aliases = [
    "davejamesmiller.com",
    "www.davejamesmiller.com",
  ]

  # Workaround for https://github.com/netlify/terraform-provider-netlify/pull/121
  branch_deploy_custom_domain  = ""
  deploy_preview_custom_domain = ""
}

resource "cloudflare_dns_record" "djm_me_CNAME" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "djm.me"
  type    = "CNAME"
  content = "djm.netlify.app"
  ttl     = 1
}

resource "cloudflare_dns_record" "www_djm_me_CNAME" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "www.djm.me"
  type    = "CNAME"
  content = "djm.netlify.app"
  ttl     = 1
}

resource "cloudflare_dns_record" "davejamesmiller_com_CNAME" {
  zone_id = data.cloudflare_zone.davejamesmiller_com.zone_id
  name    = "davejamesmiller.com"
  type    = "CNAME"
  content = "djm.netlify.app"
  ttl     = 1
}

resource "cloudflare_dns_record" "www_davejamesmiller_com_CNAME" {
  zone_id = data.cloudflare_zone.davejamesmiller_com.zone_id
  name    = "www.davejamesmiller.com"
  type    = "CNAME"
  content = "djm.netlify.app"
  ttl     = 1
}
