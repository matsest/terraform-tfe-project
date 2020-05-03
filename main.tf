resource "tfe_workspace" "main" {
  for_each     = { for w in local.workspaces : w.name => w }
  name         = each.key
  organization = var.organization

  queue_all_runs = contains(local.queue_runs, each.key) ? true : false

  vcs_repo {
    identifier     = each.value.repo
    oauth_token_id = var.oauth_token_id
  }
}

resource "tfe_variable" "main" {
  for_each     = { for v in local.variables : "${v.workspace}-${v.key}" => v }
  key          = each.value.key
  value        = each.value.value
  category     = "terraform"
  workspace_id = tfe_workspace.main[each.value.workspace].id
}

resource "tfe_run_trigger" "main" {
  for_each = {
    for t in local.run_triggers : "${t.workspace}-${t.sourceable}" => t
  }
  workspace_external_id = tfe_workspace.main[each.value.workspace].id
  sourceable_id         = tfe_workspace.main[each.value.sourceable].id
}
