module "project" {
  source = "../"

  organization = var.organization

  name_prefix = var.name_prefix

  environments = [
    "qux",
    "quux",
    "quuz"
  ]

  workspaces = [
    {
      name              = "foo"
      repo              = "innovationnorway/terraform-module-acctest"
      working_directory = ""
      variables = {
        name_prefix = var.name_prefix
      }
    },
    {
      name              = "bar"
      repo              = "innovationnorway/terraform-module-acctest"
      working_directory = ""
      variables = {
        name_prefix = var.name_prefix
      }
    },
    {
      name              = "baz"
      repo              = "innovationnorway/terraform-module-acctest"
      working_directory = ""
      variables = {
        name_prefix = var.name_prefix
      }
    },
  ]

  run_triggers = {
    foo = ["bar"]
    baz = ["foo", "bar"]
  }

  queue_runs = ["bar"]

  oauth_token_id = var.oauth_token_id

  terraform_version = "0.13.3"
}

data "testing_assertions" "project" {
  subject = "Project module"

  equal "environments" {
    statement = "has expected environments"

    got = module.project.environments
    want = toset([
      "quux",
      "quuz",
      "qux",
    ])
  }

  equal "workspaces" {
    statement = "has expected workspace names"

    got = keys(module.project.workspaces)
    want = [
      "${var.name_prefix}-bar-quux",
      "${var.name_prefix}-bar-quuz",
      "${var.name_prefix}-bar-qux",
      "${var.name_prefix}-baz-quux",
      "${var.name_prefix}-baz-quuz",
      "${var.name_prefix}-baz-qux",
      "${var.name_prefix}-foo-quux",
      "${var.name_prefix}-foo-quuz",
      "${var.name_prefix}-foo-qux",
    ]
  }
}
