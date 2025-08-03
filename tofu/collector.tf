resource "cloudflare_dns_record" "c_djm_me_CNAME" {
  zone_id = data.cloudflare_zone.djm_me.zone_id
  name    = "c.djm.me"
  type    = "CNAME"
  content = "artemis.djm.me"
  ttl     = 1
}

resource "random_password" "collector_dave_password" {
  length = 13
}

output "collector_dave_password" {
  value     = random_password.collector_dave_password.bcrypt_hash
  sensitive = true
}
