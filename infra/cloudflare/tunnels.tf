resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  for_each = {for k,v in var.tunnels : v.tunnel_name => v }

  account_id = var.account_id
  name       = each.value.tunnel_name
  secret     = base64encode(random_string.tunnel_secret.result)
}

resource "cloudflare_tunnel_config" "config" {
  for_each = {for k,v in var.tunnels : v.tunnel_name => v }

  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel[each.value.tunnel_name].id

  config {
    ingress_rule {
      hostname = each.value.ingress_rule.hostname
      path     = each.value.ingress_rule.path
      service  = each.value.ingress_rule.service
    }

    ingress_rule {
      service = "http_status:404"
    }
  }
}

resource "cloudflare_record" "record" {
  for_each = {for k,v in var.tunnels : v.tunnel_name => v }

  zone_id = each.value.zone_id
  name    = each.value.dns_record_name
  content = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel[each.value.tunnel_name].id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}
