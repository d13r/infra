# https://bsky.app/settings/account
resource "cloudflare_dns_record" "atproto_djm_me_TXT" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "_atproto.djm.me"
  type    = "TXT"
  content = "\"did=did:plc:ikccufypxzw7a4364kzmphqt\""
  ttl     = 1
}
