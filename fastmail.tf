# https://app.fastmail.com/settings/domains/2092152/dns?u=fea140e9
locals {
  fastmail_domains = {
    "djm.me"              = data.cloudflare_zone.djm_me.zone_id
    "davejamesmiller.com" = data.cloudflare_zone.davejamesmiller_com.zone_id
  }
}

resource "cloudflare_dns_record" "fastmail_MX" {
  for_each = merge([
    for domain, zone_id in local.fastmail_domains : {
      for priority, mx in { 10 = "in1-smtp", 20 = "in2-smtp" } :
      "${domain} ${priority}" => {
        domain   = domain
        zone_id  = zone_id
        priority = priority
        mx       = mx
      }
    }
  ]...)

  zone_id  = each.value.zone_id
  name     = each.value.domain
  type     = "MX"
  priority = each.value.priority
  content  = "${each.value.mx}.messagingengine.com"
  ttl      = 1
}

resource "cloudflare_dns_record" "fastmail_domainkey_CNAME" {
  for_each = merge([
    for domain, zone_id in local.fastmail_domains : {
      for subdomain in ["fm1", "fm2", "fm3", "mesmtp"] :
      "${subdomain}._domainkey.${domain}" => {
        domain    = domain
        zone_id   = zone_id
        subdomain = subdomain
      }
    }
  ]...)

  zone_id = each.value.zone_id
  name    = "${each.value.subdomain}._domainkey.${each.value.domain}"
  type    = "CNAME"
  content = "${each.value.subdomain}.${each.value.domain}.dkim.fmhosted.com"
  ttl     = 1
}

resource "cloudflare_dns_record" "fastmail_SRV" {
  for_each = merge([
    for domain, zone_id in local.fastmail_domains : {
      for subdomain, data in {
        "_caldav._tcp"     = { priority = 0, weight = 0, port = 0, target = "." }
        "_caldavs._tcp"    = { priority = 0, weight = 1, port = 443, target = "caldav.fastmail.com" }
        "_carddav._tcp"    = { priority = 0, weight = 0, port = 0, target = "." }
        "_carddavs._tcp"   = { priority = 0, weight = 1, port = 443, target = "carddav.fastmail.com" }
        "_imap._tcp"       = { priority = 0, weight = 0, port = 0, target = "." }
        "_imaps._tcp"      = { priority = 0, weight = 1, port = 993, target = "imap.fastmail.com" }
        "_jmap._tcp"       = { priority = 0, weight = 1, port = 443, target = "api.fastmail.com" }
        "_pop3._tcp"       = { priority = 0, weight = 0, port = 0, target = "." }
        "_pop3s._tcp"      = { priority = 10, weight = 1, port = 995, target = "pop.fastmail.com" }
        "_submission._tcp" = { priority = 0, weight = 1, port = 587, target = "smtp.fastmail.com" }
      } :
      "${subdomain}.${domain}" => {
        domain    = domain
        zone_id   = zone_id
        subdomain = subdomain
        data      = data
      }
    }
  ]...)

  zone_id  = each.value.zone_id
  name     = "${each.value.subdomain}.${each.value.domain}"
  type     = "SRV"
  priority = each.value.data.priority
  data     = each.value.data
  ttl      = 1
}
