module "project" {
  source = "../"

  organization = var.organization

  name_prefix = var.name_prefix

  environments = [
    "dev",
    "prod",
  ]

  workspaces = [
    {
      name = "foo"
      repo = "innovationnorway/terraform-module-acctest"
      variables = {
        name_prefix = var.name_prefix
      }
    },
    {
      name = "bar"
      repo = "innovationnorway/terraform-module-acctest"
      variables = {
        name_prefix = var.name_prefix
      }
    },
  ]

  run_triggers = {
    bar = ["foo"]
  }

  queue_runs = ["foo"]

  oauth_token_id = var.oauth_token_id
}

output "project" {
  value = module.project
}
