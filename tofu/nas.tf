resource "cloudflare_dns_record" "nas_djm_me_A" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "nas.djm.me"
  type    = "A"
  content = local.home_nas_ipv4
  ttl     = 1
}
