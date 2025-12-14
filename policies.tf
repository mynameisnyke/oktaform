# SOC2-compliant sign-on policy for GitHub Enterprise
# Requires managed and registered devices for access
#
# IMPORTANT: catch_all is set to false to ensure device checks are enforced.
# If catch_all=true, it could allow access even when device checks fail.

resource "okta_app_signon_policy" "github_soc2" {
  name        = "GitHub Enterprise - SOC2 Compliant Access"
  description = "Sign-on policy requiring managed and registered devices for GitHub Enterprise access (SOC2 compliance)"
  catch_all   = false # Set to false to enforce device checks - no default allow
}

# Policy Rule: Require managed and registered devices
# This rule only allows access if device is both registered AND managed
# Priority 1 = evaluated first
# Note: Device assurance policies require third-party signal providers (like CrowdStrike)
# For now, we enforce managed devices via device_is_managed check
resource "okta_app_signon_policy_rule" "github_managed_devices" {
  policy_id            = okta_app_signon_policy.github_soc2.id
  name                 = "Require Managed and Registered Devices"
  priority             = 1    # Lower priority = evaluated first
  device_is_registered = true # Device must be registered with Okta
  device_is_managed    = true # Device must be managed (via MDM/domain)
  access               = "ALLOW"
}

# Catch-all deny rule: Deny access to anyone who doesn't match the managed device rule
# Priority 2 = evaluated after the allow rule (before default catch-all at priority 3)
# This ensures that only managed, registered devices can access GitHub Enterprise
resource "okta_app_signon_policy_rule" "github_catch_all_deny" {
  policy_id = okta_app_signon_policy.github_soc2.id
  name      = "Deny All Others"
  priority  = 2 # Runs before default catch-all (priority 3)
  access    = "DENY"
  # No conditions = matches everything that doesn't match previous rules
}

# Assign the sign-on policy to GitHub Enterprise app
resource "okta_app_access_policy_assignment" "github_soc2" {
  app_id    = okta_app_saml.github_enterprise.id
  policy_id = okta_app_signon_policy.github_soc2.id
}

