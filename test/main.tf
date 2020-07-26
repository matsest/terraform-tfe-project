module "project" {
  source = "../"

  organization = var.organization

  name_prefix = var.name_prefix

  environments = [
    "qux",
    "quux",
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
    foo = ["bar"]
  }

  queue_runs = ["bar"]

  oauth_token_id = var.oauth_token_id
}

output "project" {
  value = module.project
}
