terraform {
  required_version = "~> 1"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6"
    }
  }

  cloud {
    organization = "mstrzele"

    workspaces {
      name = "mstrzele-io"
    }
  }
}

provider "github" {
  owner = "mstrzele"

  app_auth {
    id              = var.app_id
    installation_id = var.app_installation_id
    pem_file        = var.app_pem_file
  }
}

data "cloudflare_zone" "mstrzele_io" {
  name = "mstrzele.io"
}

resource "github_repository" "mstrzele_github_io" {
  name = "mstrzele.github.io"

  pages {
    build_type = "workflow"
    cname      = data.cloudflare_zone.mstrzele_io.name
  }
}

resource "github_repository_file" "cname" {
  repository = github_repository.mstrzele_github_io.name
  file       = "CNAME"
  content    = data.cloudflare_zone.mstrzele_io.name
}

resource "cloudflare_record" "mstrzele_io" {
  zone_id = data.cloudflare_zone.mstrzele_io.id
  type    = "CNAME"
  name    = data.cloudflare_zone.mstrzele_io.name
  value   = github_repository.mstrzele_github_io.name
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zone.mstrzele_io.id
  type    = "CNAME"
  name    = "www"
  value   = github_repository.mstrzele_github_io.name
  proxied = true
}
