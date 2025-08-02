terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.5.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.7.1"
    }

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.51.0"
    }

    netlify = {
      source  = "netlify/netlify"
      version = "0.2.2"
    }

  }
}
