# Group rules to propagate membership from HRIS groups to BASE groups
# This separates HRIS lifecycle management from access control (Okta)
#
# IMPORTANT: Rules referencing custom attributes (like employeeStatus) require a two-step apply:
# If you encounter "Invalid property employeeStatus" errors, apply in two steps:
#   1. terraform apply -target=okta_user_schema_property.employee_status
#   2. terraform apply
# This ensures the custom attribute is fully created before Okta validates the group rule expressions.
# Note: 'department' is a built-in Okta attribute, so no custom schema property is needed.

# Rule: Populate HRIS_US_FULL_TIME based on employeeStatus attribute from HRIS
# This rule assigns users to HRIS_US_FULL_TIME if their employeeStatus is "FULL_TIME"
# HRIS system will sync this attribute via SCIM/API
# Note: Custom attributes are accessed via their index name in SpEL (user.employeeStatus)
resource "okta_group_rule" "hris_full_time" {
  name              = "HRIS → HRIS_US_FULL_TIME"
  status            = "ACTIVE"
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "user.employeeStatus == \"FULL_TIME\""
  group_assignments = [okta_group.groups["HRIS_US_FULL_TIME"].id]

  # Ensure the custom attribute exists before creating the rule
  depends_on = [okta_user_schema_property.employee_status]
}

# Rule: Populate HRIS_CONTRACTORS based on employeeStatus attribute from HRIS
resource "okta_group_rule" "hris_contractors" {
  name              = "HRIS → HRIS_CONTRACTORS"
  status            = "ACTIVE"
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "user.employeeStatus == \"CONTRACTOR\""
  group_assignments = [okta_group.groups["HRIS_CONTRACTORS"].id]

  # Ensure the custom attribute exists before creating the rule
  depends_on = [okta_user_schema_property.employee_status]
}

# Rule: Add all members of HRIS_US_FULL_TIME to BASE_ALL_EMPLOYEES
# This ensures all full-time employees get base access to apps
# SpEL expression checks if user is a member of the HRIS group by ID
resource "okta_group_rule" "hris_to_base_all_employees" {
  name              = "HRIS_US_FULL_TIME → BASE_ALL_EMPLOYEES"
  status            = "ACTIVE"
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "isMemberOfAnyGroup(\"${okta_group.groups["HRIS_US_FULL_TIME"].id}\")"
  group_assignments = [okta_group.groups["BASE_ALL_EMPLOYEES"].id]
}

# Rule: Populate DEPT_ENGINEERING based on department attribute from HRIS
# This rule assigns users to DEPT_ENGINEERING if their department is "Engineering"
# HRIS system will sync this attribute via SCIM/API
# Note: 'department' is a built-in Okta attribute, so no custom schema property is needed
resource "okta_group_rule" "department_engineering" {
  name              = "HRIS → DEPT_ENGINEERING"
  status            = "ACTIVE"
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "user.department == \"Engineering\""
  group_assignments = [okta_group.groups["DEPT_ENGINEERING"].id]
}

# Rule: Populate APP_GITHUB_ENTERPRISE from DEPT_ENGINEERING
# This ensures all Engineering department members get GitHub Enterprise access
# SpEL expression checks if user is a member of the DEPT_ENGINEERING group by ID
resource "okta_group_rule" "engineering_to_github" {
  name              = "DEPT_ENGINEERING → APP_GITHUB_ENTERPRISE"
  status            = "ACTIVE"
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "isMemberOfAnyGroup(\"${okta_group.groups["DEPT_ENGINEERING"].id}\")"
  group_assignments = [okta_group.groups["APP_GITHUB_ENTERPRISE"].id]
}

# Rule: Populate APP_SLACK_USERS from BASE_ALL_EMPLOYEES
# This ensures all full-time employees get Slack access
# SpEL expression checks if user is a member of the BASE_ALL_EMPLOYEES group by ID
resource "okta_group_rule" "base_to_slack" {
  name              = "BASE_ALL_EMPLOYEES → APP_SLACK_USERS"
  status            = "ACTIVE"
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "isMemberOfAnyGroup(\"${okta_group.groups["BASE_ALL_EMPLOYEES"].id}\")"
  group_assignments = [okta_group.groups["APP_SLACK_USERS"].id]
}

# Rule: Populate APP_GOOGLE_WORKSPACE from BASE_ALL_EMPLOYEES
# This ensures all full-time employees get Google Workspace access
# SpEL expression checks if user is a member of the BASE_ALL_EMPLOYEES group by ID
resource "okta_group_rule" "base_to_google_workspace" {
  name              = "BASE_ALL_EMPLOYEES → APP_GOOGLE_WORKSPACE"
  status            = "ACTIVE"
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "isMemberOfAnyGroup(\"${okta_group.groups["BASE_ALL_EMPLOYEES"].id}\")"
  group_assignments = [okta_group.groups["APP_GOOGLE_WORKSPACE"].id]
}

