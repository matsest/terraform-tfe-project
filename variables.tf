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
    name              = string
    repo              = string
    working_directory = string
    variables         = map(string)
  }))
  description = "A list of `workspaces` objects to be used in the project."
}

variable "run_triggers" {
  type        = map(list(string))
  default     = {}
  description = "A mapping from each workspace name to a list of sourceable workspace names."
}

variable "queue_runs" {
  type        = list(string)
  default     = []
  description = "A list of workspace names for which all runs should be queued."
}

variable "oauth_token_id" {
  type        = string
  description = "The token ID of the VCS Connection (OAuth Conection Token) to use in Terraform Cloud."
}

variable "terraform_version" {
  type        = string
  description = "The version of Terraform to use for workspaces."
  default     = "0.13.3"
}

locals {
  queue_runs = [
    for p in setproduct(var.queue_runs, var.environments) :
    format("%s-%s-%s", var.name_prefix, p[0], p[1])
  ]

  # The "tfe_workspace" resource only deal with one workspace at a time,
  # so we need to flatten these.
  workspaces = flatten([
    for w in var.workspaces : [
      for e in var.environments : {
        name              = format("%s-%s-%s", var.name_prefix, w.name, e)
        repo              = w.repo
        working_directory = w.working_directory
        variables         = w.variables
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

  # The "tfe_run_trigger" resource only deal with one variable at a time,
  # so we need to flatten these.
  run_triggers = flatten([
    for k, v in var.run_triggers : [
      for p in setproduct(v, var.environments) : {
        workspace  = format("%s-%s-%s", var.name_prefix, k, p[1])
        sourceable = format("%s-%s-%s", var.name_prefix, p[0], p[1])
      }
    ]
  ])
}
