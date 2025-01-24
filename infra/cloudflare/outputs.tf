output "tunnel_names" {
  description = "The names of the tunnels"
  value       = [for k, v in cloudflare_zero_trust_tunnel_cloudflared.tunnel : v.name]
}
