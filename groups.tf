locals {
  okta_groups = {
    # --- 1. HRIS Groups (Lifecycle truth) ---
    # These groups are managed by HRIS system via import/sync
    # Terraform creates the groups, but membership is controlled by HRIS
    HRIS_US_FULL_TIME = {
      description = "Managed by HRIS - Contains all US full-time employees. Membership synced from HRIS system."
    }
    HRIS_CONTRACTORS = {
      description = "Managed by HRIS - Contains all external contractors. Membership synced from HRIS system."
    }

    # --- 2. BASE Groups (Access abstraction) ---
    # These groups propagate from HRIS groups via group rules
    # Used to separate HRIS lifecycle management from access control
    BASE_ALL_EMPLOYEES = {
      description = "Base group for all active, internal employees. Automatically populated from HRIS_US_FULL_TIME via group rule. Used to grant basic access to apps."
    }

    # --- 3. DEPT Groups (Organizational context) ---
    DEPT_FINANCE = {
      description = "Members of the Finance Department."
    }
    DEPT_ENGINEERING = {
      description = "Members of the Engineering Department."
    }

    # --- 4. APP Groups (Standard application access) ---
    APP_SLACK_USERS = {
      description = "Access to the main corporate Slack workspace."
    }
    APP_GOOGLE_WORKSPACE = {
      description = "Access to Google Workspace (Gmail, Drive, Docs, etc.)."
    }
    APP_GITHUB_ENTERPRISE = {
      description = "Access to GitHub Enterprise for code repositories and collaboration."
    }
    APP_JIRA_STANDARD = {
      description = "Standard user access for Jira Software."
    }

    # --- 5. PRIV Groups (Elevated / admin access) ---
    PRIV_OKTA_ADMIN = {
      description = "Elevated access for Okta Super Administrators."
    }

    # --- 6. SEC Groups (Conditional access & security) ---
    SEC_NO_MFA_EXEMPT = {
      description = "Users exempt from specific MFA rules. Use with caution."
    }

    # --- 7. TEMP Groups (Time-bound exceptions) ---
    TEMP_PROJECT_X_ACCESS = {
      description = "Temporary access for Project X team members (expiring 2026-06-30)."
    }
  }
}

resource "okta_group" "groups" {
  for_each = local.okta_groups

  name        = each.key
  description = each.value.description
}


