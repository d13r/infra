locals {
  cloudflare_account_id = "14bcf968d51e4493e05864e68bd355f2"
}

data "cloudflare_account_api_token_permission_groups_list" "zone_write" {
  account_id = local.cloudflare_account_id
  scope      = "com.cloudflare.api.account.zone"
  name       = "DNS Write"
}
