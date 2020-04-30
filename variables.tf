variable "name_prefix" {
  type        = string
  description = "Creates a unique name beginning with the specified prefix."
}

variable "organization" {
  type        = string
  description = "The name of the organization."
}

variable "environments" {
  type        = set(string)
  description = "A set of distinct environment names to be used in the project."
}

variable "workspaces" {
  type = list(object({
    name      = string
    repo      = string
    variables = map(string)
  }))
  description = "A list of `workspaces` objects to be used in the project."
}

variable "oauth_token_id" {
  type        = string
  description = "The token ID of the VCS Connection (OAuth Conection Token) to use in Terraform Cloud."
}

locals {
  # The "tfe_workspace" resource only deal with one workspace at a time,
  # so we need to flatten these.
  workspaces = flatten([
    for w in var.workspaces : [
      for e in var.environments : {
        name      = format("%s-%s-%s", var.name_prefix, w.name, e)
        repo      = w.repo
        variables = w.variables
      }
    ]
  ])

  # The "tfe_variable" resource only deal with one variable at a time,
  # so we need to flatten these.
  variables = flatten([
    for w in local.workspaces : [
      for k, v in w.variables : {
        workspace = w.name
        key       = k
        value     = v
      }
    ]
  ])
}
