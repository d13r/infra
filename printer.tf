resource "cloudflare_dns_record" "printer_djm_me_A" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "printer.djm.me"
  type    = "A"
  content = local.home_printer_ipv4
  ttl     = 1
}
