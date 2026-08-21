resource "newrelic_one_dashboard_json" "dashboard" {
  json = file("${path.module}/dashboard.json")
}

