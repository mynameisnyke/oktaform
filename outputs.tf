output "okta_group_ids" {
  description = "Map of group name => Okta group ID."
  value       = { for name, g in okta_group.groups : name => g.id }
}

output "okta_app_ids" {
  description = "Map of app name => Okta app ID."
  value = {
    google_workspace  = okta_app_saml.google_workspace.id
    github_enterprise = okta_app_saml.github_enterprise.id
    slack             = okta_app_saml.slack.id
  }
}

output "github_soc2_policy_id" {
  description = "ID of the SOC2-compliant sign-on policy for GitHub Enterprise."
  value       = okta_app_signon_policy.github_soc2.id
}

output "group_rule_ids" {
  description = "Map of group rule name => Okta group rule ID."
  value = {
    hris_full_time             = okta_group_rule.hris_full_time.id
    hris_contractors           = okta_group_rule.hris_contractors.id
    hris_to_base_all_employees = okta_group_rule.hris_to_base_all_employees.id
    department_engineering     = okta_group_rule.department_engineering.id
    engineering_to_github      = okta_group_rule.engineering_to_github.id
    base_to_slack              = okta_group_rule.base_to_slack.id
    base_to_google_workspace   = okta_group_rule.base_to_google_workspace.id
  }
}

output "employee_status_attribute" {
  description = "Custom user schema property for HRIS employee status."
  value = {
    index = okta_user_schema_property.employee_status.index
    title = okta_user_schema_property.employee_status.title
  }
}

output "soc2_priv_password_policy_id" {
  description = "ID of the SOC2-compliant password policy for PRIV groups."
  value       = okta_policy_password.soc2_priv_password.id
}

output "soc2_base_password_policy_id" {
  description = "ID of the SOC2-compliant password policy for BASE_ALL_EMPLOYEES group."
  value       = okta_policy_password.soc2_base_password.id
}

output "soc2_priv_session_policy_id" {
  description = "ID of the SOC2-compliant session policy for PRIV groups."
  value       = okta_policy_signon.soc2_priv_session.id
}

output "soc2_base_session_policy_id" {
  description = "ID of the SOC2-compliant session policy for BASE_ALL_EMPLOYEES group."
  value       = okta_policy_signon.soc2_base_session.id
}

output "standard_password_policy_id" {
  description = "ID of the standard password policy for all employees."
  value       = okta_policy_password.all_employees_password.id
}

output "standard_session_policy_id" {
  description = "ID of the standard session policy for all employees."
  value       = okta_policy_signon.all_employees_session.id
}


