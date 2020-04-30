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
      name = "network"
      repo = "innovationnorway/terraform-infrastructure-network"
      variables = {
        cidr_block = "10.128.0.0/16"
      }
    },
    {
      name = "databricks"
      repo = "innovationnorway/terraform-dataplatform-databricks"
      variables = {
        sku = "premium"
      }
    },
  ]

  oauth_token_id = var.oauth_token_id
}

output "project" {
  value = module.project
}
