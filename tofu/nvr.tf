resource "cloudflare_dns_record" "nvr_djm_me_A" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "nvr.djm.me"
  type    = "A"
  content = local.home_nvr_ipv4
  ttl     = 1
}
