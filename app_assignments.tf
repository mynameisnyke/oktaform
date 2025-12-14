# Assign APP groups to applications
# APP groups are populated from BASE groups via group rules
# This separates HRIS lifecycle management from app access control

resource "okta_app_group_assignment" "google_workspace" {
  app_id   = okta_app_saml.google_workspace.id
  group_id = okta_group.groups["APP_GOOGLE_WORKSPACE"].id
}

resource "okta_app_group_assignment" "github_enterprise" {
  app_id   = okta_app_saml.github_enterprise.id
  group_id = okta_group.groups["APP_GITHUB_ENTERPRISE"].id
}

resource "okta_app_group_assignment" "slack" {
  app_id   = okta_app_saml.slack.id
  group_id = okta_group.groups["APP_SLACK_USERS"].id
}

