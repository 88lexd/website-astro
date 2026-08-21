account_id = "f29eb0a77d5d3e96d4e1edfc76813290"
zone_id    = "5cf4cd965a07d20a7a74a14565a2037b"
email      = "alex.dinh@lexdsolutions.com"

tunnels = [
  {
    tunnel_name     = "astro-dev"
    zone_id         = "5cf4cd965a07d20a7a74a14565a2037b"
    dns_record_name = "dev"
    ingress_rule = {
      hostname = "dev.lexdsolutions.com"
      path     = "/"
      service  = "http://192.168.0.45"
    }
  },
  {
    tunnel_name     = "lexd-solutions"
    zone_id         = "5cf4cd965a07d20a7a74a14565a2037b"
    dns_record_name = "@"
    ingress_rule = {
      hostname = "lexdsolutions.com"
      path     = "/"
      service  = "http://192.168.0.45"
    }
  },
  {
    tunnel_name     = "henry-todo-app"
    zone_id         = "ef52cbbc77074d3566c6687589e98de9"
    dns_record_name = "todo"
    ingress_rule = {
      hostname = "todo.henrydinh.net"
      path     = "/"
      service  = "http://192.168.0.45"
    }
  }
]
