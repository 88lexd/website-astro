output "dashboard_url" {
  description = "The URL for viewing the dashboard"
  value       = newrelic_one_dashboard_json.dashboard.permalink
}

output "dashboard_guid" {
  description = "The unique entity identifier of the dashboard in New Relic"
  value       = newrelic_one_dashboard_json.dashboard.guid
}

