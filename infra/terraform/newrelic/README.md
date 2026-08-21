# New Relic

This directory contains the Terraform IaC to manage New Relic resources, including observability dashboards exported from New Relic.

## Configuration

### Authentication
The New Relic provider authenticates using environment variables:

```bash
export NEW_RELIC_ACCOUNT_ID="your-account-id"
export NEW_RELIC_API_KEY="your-api-key"
export NEW_RELIC_REGION="US" # or EU depending on your account
```

### Terraform Backend
The Terraform state is stored in AWS S3:

```shell
# Authenticate into AWS if needed
export AWS_PROFILE=lexd-admin

# Initialize Terraform backend
terraform init
```

## Dashboard Deployment

The dashboard definition is maintained in `dashboard.json` and provisioned using the `newrelic_one_dashboard_json` resource in `dashboard.tf`.

### Deploying Changes

```bash
terraform plan -out tfplan.out
terraform apply tfplan.out
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.8 |
| <a name="requirement_newrelic"></a> [newrelic](#requirement\_newrelic) | ~> 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_newrelic"></a> [newrelic](#provider\_newrelic) | ~> 3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [newrelic_one_dashboard_json.dashboard](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/one_dashboard_json) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dashboard_guid"></a> [dashboard\_guid](#output\_dashboard\_guid) | The unique entity identifier of the dashboard in New Relic |
| <a name="output_dashboard_url"></a> [dashboard\_url](#output\_dashboard\_url) | The URL for viewing the dashboard |
<!-- END_TF_DOCS -->

