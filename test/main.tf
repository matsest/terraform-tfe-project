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

data "testing_assertions" "project" {
  subject = "Project module"

  equal "environments" {
    statement = "has expected environments"

    got  = module.project.environments
    want = toset(["qux", "quux"])
  }

  equal "workspaces" {
    statement = "has expected workspaces"

    got  = [for w in module.project.workspaces : w.name]
    want = ["testacc-bar-quux", "testacc-bar-qux", "testacc-foo-quux", "testacc-foo-qux"]
  }
}
