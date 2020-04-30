output "name_prefix" {
  value       = var.name_prefix
  description = "Echoes back the `name_prefix` input variable value, for convenience if passing the result of this module elsewhere as an object."
}

output "environments" {
  value       = var.environments
  description = "Echoes back the `environments` input variable value, for convenience if passing the result of this module elsewhere as an object."
}

output "workspaces" {
  value       = { for w in local.workspaces : w.name => w }
  description = "A mapping from each workspace name to an object describing the workspace and it's variables."
}
