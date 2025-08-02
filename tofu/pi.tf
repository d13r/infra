resource "cloudflare_dns_record" "pi_djm_me_A" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "pi.djm.me"
  type    = "A"
  content = local.home_pi_ipv4
  ttl     = 1
}
