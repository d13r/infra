data "cloudflare_zone" "djm_me" {
  filter = {
    name = "djm.me"
  }
}

resource "cloudflare_dns_record" "djm_me_TXT_spf1" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "djm.me"
  type    = "TXT"
  # https://app.fastmail.com/settings/domains/2092152/dns
  # https://docs.aws.amazon.com/ses/latest/dg/mail-from.html
  content = "\"v=spf1 include:spf.messagingengine.com include:amazonses.com -all\""
  ttl     = 1
}

resource "cloudflare_dns_record" "djm_me_TXT_dmarc1" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "_dmarc.djm.me"
  type    = "TXT"
  content = "\"v=DMARC1; p=reject; sp=reject; adkim=r; aspf=r; pct=100;\""
  ttl     = 1
}

resource "cloudflare_dns_record" "djm_me_CAA_issue" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "djm.me"
  type    = "CAA"
  ttl     = 1

  data = {
    flags = 0
    tag   = "issue"
    value = "letsencrypt.org"
  }
}

resource "cloudflare_dns_record" "djm_me_CAA_iodef" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "djm.me"
  type    = "CAA"
  ttl     = 1

  data = {
    flags = 0
    tag   = "iodef"
    value = "mailto:d@djm.me"
  }
}
