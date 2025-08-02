resource "cloudflare_dns_record" "router_djm_me_A" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "router.djm.me"
  type    = "A"
  content = local.home_router_ipv4
  ttl     = 1
}
