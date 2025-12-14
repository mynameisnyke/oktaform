# SOC2-compliant global policies for Password and Session management
# These policies enforce security controls aligned with SOC2 requirements

# ============================================================================
# PASSWORD POLICIES
# ============================================================================

# PRIV Password Policy - Stricter requirements for privileged accounts
# This policy is evaluated FIRST (highest priority) to catch PRIV users
# Requirements: 14+ chars, complexity, history, shorter rotation (60-90 days)
resource "okta_policy_password" "soc2_priv_password" {
  name        = "SOC2 Password - PRIV Groups"
  description = "Strict SOC2-compliant password policy for PRIV groups with elevated security requirements"
  status      = "ACTIVE"

  # Target PRIV groups only
  groups_included = [
    okta_group.groups["PRIV_OKTA_ADMIN"].id
  ]

  # Stricter password complexity requirements for privileged accounts
  password_min_length    = 14
  password_min_lowercase = 1
  password_min_uppercase = 1
  password_min_number    = 1
  password_min_symbol    = 1

  # Password history - prevent reuse of last 10 passwords
  password_history_count = 10

  # Password expiration - 60 days for privileged accounts (stricter)
  password_expire_warn_days = 7
  password_max_age_days     = 60
  password_min_age_minutes  = 1

  # Account lockout - prevent brute force attacks
  password_lockout_notification_channels = ["EMAIL"]
  password_max_lockout_attempts          = 10
  password_show_lockout_failures         = true
  password_auto_unlock_minutes           = 30

  # Password recovery settings
  email_recovery      = "ACTIVE"
  question_recovery   = "ACTIVE"
  question_min_length = 4
}

# Password Policy Rule: Apply to PRIV groups
resource "okta_policy_rule_password" "soc2_priv_groups_password" {
  policy_id = okta_policy_password.soc2_priv_password.id
  name      = "PRIV Groups - SOC2 Password"
  status    = "ACTIVE"
  priority  = 1
}

# BASE Password Policy - SOC2-compliant requirements for BASE_ALL_EMPLOYEES
# This policy is evaluated SECOND (after PRIV) for BASE users
# Requirements: 12+ chars, complexity, history, rotation (90 days)
resource "okta_policy_password" "soc2_base_password" {
  name        = "SOC2 Password - BASE Groups"
  description = "SOC2-compliant password policy for BASE_ALL_EMPLOYEES with standard security requirements"
  status      = "ACTIVE"

  # Target BASE_ALL_EMPLOYEES group only
  groups_included = [
    okta_group.groups["BASE_ALL_EMPLOYEES"].id
  ]

  # Password complexity requirements
  password_min_length    = 12
  password_min_lowercase = 1
  password_min_uppercase = 1
  password_min_number    = 1
  password_min_symbol    = 1

  # Password history - prevent reuse of last 10 passwords
  password_history_count = 10

  # Password expiration - 90 days for BASE employees
  password_expire_warn_days = 7
  password_max_age_days     = 90
  password_min_age_minutes  = 1

  # Account lockout - prevent brute force attacks
  password_lockout_notification_channels = ["EMAIL"]
  password_max_lockout_attempts          = 10
  password_show_lockout_failures         = true
  password_auto_unlock_minutes           = 30

  # Password recovery settings
  email_recovery      = "ACTIVE"
  question_recovery   = "ACTIVE"
  question_min_length = 4
}

# Password Policy Rule: Apply to BASE_ALL_EMPLOYEES group
resource "okta_policy_rule_password" "soc2_base_employees_password" {
  policy_id = okta_policy_password.soc2_base_password.id
  name      = "BASE_ALL_EMPLOYEES - SOC2 Password"
  status    = "ACTIVE"
  priority  = 1
}

# Looser password policy for all employees (default/fallback)
# Less strict requirements for general users
resource "okta_policy_password" "all_employees_password" {
  name        = "All Employees - Standard Password"
  description = "Standard password policy for all employees with relaxed requirements"
  status      = "ACTIVE"

  # No groups_included means it applies to all users by default
  # This will be evaluated after the BASE/PRIV policy

  # Less strict complexity requirements
  password_min_length    = 8
  password_min_lowercase = 1
  password_min_uppercase = 1
  password_min_number    = 1
  password_min_symbol    = 0 # Optional special characters

  # Shorter password history
  password_history_count = 5

  # Longer password expiration (180 days)
  password_expire_warn_days = 14
  password_max_age_days     = 180
  password_min_age_minutes  = 0

  # Account lockout
  password_lockout_notification_channels = ["EMAIL"]
  password_max_lockout_attempts          = 10
  password_show_lockout_failures         = true
  password_auto_unlock_minutes           = 30

  # Password recovery settings
  email_recovery      = "ACTIVE"
  question_recovery   = "ACTIVE"
  question_min_length = 4
}

# Password Policy Rule: Apply to all users (default)
resource "okta_policy_rule_password" "all_employees_password_rule" {
  policy_id = okta_policy_password.all_employees_password.id
  name      = "All Employees - Standard Password"
  status    = "ACTIVE"
  priority  = 1
}

# ============================================================================
# SESSION POLICIES (Sign-On Policies)
# ============================================================================

# PRIV Session Policy - Stricter requirements for privileged accounts
# This policy is evaluated FIRST (highest priority) to catch PRIV users
resource "okta_policy_signon" "soc2_priv_session" {
  name        = "SOC2 Session - PRIV Groups"
  description = "Strict SOC2-compliant session policy for PRIV groups with elevated security requirements"
  status      = "ACTIVE"

  # Target PRIV groups only
  groups_included = [
    okta_group.groups["PRIV_OKTA_ADMIN"].id
  ]
}

# Session Policy Rule: Apply to PRIV groups
resource "okta_policy_rule_signon" "soc2_priv_groups_session" {
  policy_id = okta_policy_signon.soc2_priv_session.id
  name      = "PRIV Groups - SOC2 Session"
  status    = "ACTIVE"
  priority  = 1

  # Stricter session timeout - 15 minutes of inactivity for admin users
  session_idle = 15

  # Maximum session lifetime - 8 hours
  session_lifetime = 480
}

# BASE Session Policy - SOC2-compliant requirements for BASE_ALL_EMPLOYEES
# This policy is evaluated SECOND (after PRIV) for BASE users
resource "okta_policy_signon" "soc2_base_session" {
  name        = "SOC2 Session - BASE Groups"
  description = "SOC2-compliant session policy for BASE_ALL_EMPLOYEES with standard security requirements"
  status      = "ACTIVE"

  # Target BASE_ALL_EMPLOYEES group only
  groups_included = [
    okta_group.groups["BASE_ALL_EMPLOYEES"].id
  ]
}

# Session Policy Rule: Apply to BASE_ALL_EMPLOYEES group
resource "okta_policy_rule_signon" "soc2_base_employees_session" {
  policy_id = okta_policy_signon.soc2_base_session.id
  name      = "BASE_ALL_EMPLOYEES - SOC2 Session"
  status    = "ACTIVE"
  priority  = 1

  # Session timeout - 15 minutes of inactivity
  session_idle = 15

  # Maximum session lifetime - 8 hours
  session_lifetime = 480
}

# Looser session policy for all employees (default/fallback)
# More relaxed session timeout for general users
resource "okta_policy_signon" "all_employees_session" {
  name        = "All Employees - Standard Session"
  description = "Standard session policy for all employees with relaxed timeout requirements"
  status      = "ACTIVE"

  # No groups_included means it applies to all users by default
}

# Session Policy Rule: Apply to all users (default)
resource "okta_policy_rule_signon" "all_employees_session_rule" {
  policy_id = okta_policy_signon.all_employees_session.id
  name      = "All Employees - Standard Session"
  status    = "ACTIVE"
  priority  = 1

  # Longer session timeout - 60 minutes of inactivity
  session_idle = 60

  # Maximum session lifetime - 12 hours
  session_lifetime = 720

  # MFA optional for standard users (can be required by MFA policy)
  mfa_required = false
}
