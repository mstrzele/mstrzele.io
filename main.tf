terraform {
  required_version = "~> 1"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }

  cloud {
    organization = "mstrzele"

    workspaces {
      name = "mstrzele-io"
    }
  }
}

data "cloudflare_zone" "mstrzele_io" {
  name = "mstrzele.io"
}

resource "cloudflare_record" "mstrzele_io" {
  zone_id = data.cloudflare_zone.mstrzele_io.id
  type    = "CNAME"
  name    = "mstrzele.io"
  value   = "mstrzele.github.io"
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zone.mstrzele_io.id
  type    = "CNAME"
  name    = "www"
  value   = "mstrzele.github.io"
  proxied = true
}
