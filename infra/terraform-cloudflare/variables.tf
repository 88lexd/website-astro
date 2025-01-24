variable "account_id" {
  description = "The account id for Cloudflare"
  type        = string
}

variable "zone_id" {
  description = "The DNS zone id for Cloudflare"
  type        = string
}

variable "email" {
  description = "The email to send notifications"
  type        = string
}

variable "tunnels" {
  description = <<EOF
A list of tunnel to be created.
Changing tunnel_name will DESTROY and re-create resources
EOF
  type = list(object({
    tunnel_name     = string # DO NOT CHANGE; Otherwise TF will destroy and recreate!
    zone_id         = string
    dns_record_name = string
    ingress_rule = object({
      hostname = string
      path     = string
      service  = string
    })
  }))
}