resource "cloudflare_record" "origin" {
  zone_id = var.cloudflare_zone_id
  type    = "A"
  name    = var.cloudflare_zone
  value   = digitalocean_droplet.web.ipv4_address
  ttl     = "1"
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = var.cloudflare_zone_id
  type    = "CNAME"
  name    = "www"
  value   = cloudflare_record.origin.hostname
  ttl     = "1"
  proxied = true
}

resource "cloudflare_zone_settings_override" "zone_settings" {
  zone_id = var.cloudflare_zone_id
  settings {
    always_use_https         = "on"
    automatic_https_rewrites = "on"
    always_online            = "on"
    http3                     = "on"
    min_tls_version          = "1.2"
    brotli                   = "on"
    ssl                      = "flexible"
    minify {
      css  = "on"
      js   = "on"
      html = "on"
    }
  }
}

# Nifty trick to get the IPv4 address that Terraform runs from. If you run it from your home then this is your IP

data "http" "myip" {
  url = "https://api.ipify.org/"
}

# Uncomment the below two resources if you want to lockdown the ghost admin path to the IP sourced by the data.http.myip object

#resource "cloudflare_filter" "self_ip_lockdown" {
#  zone_id     = var.cloudflare_zone_id
#  description = "Firewall filter using the data.http.myip object to set up a cheap security solution for the ghost admin endpoint"
#  expression  = "(lower(http.request.uri.path) eq \"/ghost\" and ip.src ne ${chomp(data.http.myip.body)})"
#}
#
#resource "cloudflare_firewall_rule" "ip_lockdown" {
#  zone_id     = var.cloudflare_zone_id
#  description = "Lockdown /ghost to a specific IP"
#  filter_id   = cloudflare_filter.self_ip_lockdown.id
#  action      = "block"
#}

/*
 * Access policy if I decide to go that route
 */

resource "cloudflare_access_application" "ghost_admin" {
  zone_id          = var.cloudflare_zone_id
  name             = "Access protection for Ghost login"
  domain           = "${var.cloudflare_zone}/ghost"
  session_duration = "1h"
}

resource "cloudflare_access_policy" "ghost_policy" {
  application_id = cloudflare_access_application.ghost_admin.id
  zone_id        = var.cloudflare_zone_id
  name           = "Login protection for Ghost admin"
  precedence     = "1"
  decision       = "allow"

  include {
    email = [var.cloudflare_email]
  }
}
