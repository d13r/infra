data "cloudflare_zone" "davejamesmiller_com" {
  filter = {
    name = "davejamesmiller.com"
  }
}

resource "cloudflare_dns_record" "davejamesmiller_com_CNAME" {
    zone_id = data.cloudflare_zone.davejamesmiller_com.zone_id
    name    = "davejamesmiller.com"
    type    = "CNAME"
    content = "artemis.djm.me"
    ttl     = 1
}

resource "cloudflare_dns_record" "www_davejamesmiller_com_CNAME" {
    zone_id = data.cloudflare_zone.davejamesmiller_com.zone_id
    name    = "www.davejamesmiller.com"
    type    = "CNAME"
    content = "artemis.djm.me"
    ttl     = 1
}

resource "cloudflare_dns_record" "davejamesmiller_com_TXT_spf1" {
  zone_id = data.cloudflare_zone.davejamesmiller_com.zone_id
  name    = "davejamesmiller.com"
  type    = "TXT"
  # https://app.fastmail.com/settings/domains/2092152/dns
  content = "\"v=spf1 include:spf.messagingengine.com -all\""
  ttl     = 1
}

resource "cloudflare_dns_record" "davejamesmiller_com_TXT_dmarc1" {
  zone_id = data.cloudflare_zone.davejamesmiller_com.zone_id
  name    = "_dmarc.davejamesmiller.com"
  type    = "TXT"
  content = "\"v=DMARC1; p=reject; sp=reject; adkim=r; aspf=r; pct=100;\""
  ttl     = 1
}

resource "cloudflare_dns_record" "davejamesmiller_com_CAA_issue" {
  zone_id = data.cloudflare_zone.davejamesmiller_com.zone_id
  name    = "davejamesmiller.com"
  type    = "CAA"
  ttl     = 1

  data = {
    flags = 0
    tag   = "issue"
    value = "letsencrypt.org"
  }
}

resource "cloudflare_dns_record" "davejamesmiller_com_CAA_iodef" {
  zone_id = data.cloudflare_zone.davejamesmiller_com.zone_id
  name    = "davejamesmiller.com"
  type    = "CAA"
  ttl     = 1

  data = {
    flags = 0
    tag   = "iodef"
    value = "mailto:d@djm.me"
  }
}
