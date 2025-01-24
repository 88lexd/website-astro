account_id = "f29eb0a77d5d3e96d4e1edfc76813290"
zone_id    = "5cf4cd965a07d20a7a74a14565a2037b"
email      = "alex.dinh@lexdsolutions.com"

hostname_fqdn       = "lexdsolutions.com"
hostname_dns_record = "@" # Cloudflare uses @ to indicate its the root domain

tunnels = [
  {
    tunnel_name     = "astro-dev"
    zone_id         = "5cf4cd965a07d20a7a74a14565a2037b"
    dns_record_name = "dev"
    ingress_rule = {
      hostname = "dev.lexdsolutions.com"
      path     = "/"
      service  = "http://192.168.0.23"
    }
  },
  {
    tunnel_name     = "lexd-solutions"
    zone_id         = "5cf4cd965a07d20a7a74a14565a2037b"
    dns_record_name = "@"
    ingress_rule = {
      hostname = "lexdsolutions.com"
      path     = "/"
      service  = "http://192.168.0.23"
    }
  },
  {
    tunnel_name     = "henry-todo-app"
    zone_id         = "ef52cbbc77074d3566c6687589e98de9"
    dns_record_name = "todo"
    ingress_rule = {
      hostname = "todo.henrydinh.net"
      path     = "/"
      service  = "http://192.168.0.23"
    }
  }
]
