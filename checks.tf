check "okta_org_target" {
  assert {
    condition = (
      var.okta_org_url != null
      || try(trimspace(var.okta_org_name), "") != ""
    )
    error_message = "Set either okta_org_url (recommended) or okta_org_name (non-empty)."
  }
}


