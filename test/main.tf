module "project" {
  source = "../"

  organization = var.organization

  name_prefix = var.name_prefix

  environments = [
    "dev",
    "test",
    "prod",
  ]

  workspaces = [
    {
      name = "databricks"
      repo = "innovationnorway/terraform-dataplatform-databricks"
      variables = {
        sku = "premium"
      }
    },
    {
      name = "network"
      repo = "innovationnorway/terraform-infrastructure-network"
      variables = {
        cidr_block = "10.128.0.0/16"
      }
    },
    {
      name = "monitoring"
      repo = "innovationnorway/terraform-infrastructure-monitoring"
      variables = {
        retention_days = 30
      }
    },
  ]

  run_triggers = {
    databricks = ["network"]
    monitoring = ["databricks", "network"]
  }

  queue_runs = ["network"]

  oauth_token_id = var.oauth_token_id
}

output "project" {
  value = module.project
}
