locals {
  # okta_org_url is a convenience input; the provider itself expects org_name/base_url.
  #
  # Examples:
  # - https://dev-123456.okta.com      => org_name=dev-123456, base_url=okta.com
  # - https://acme.okta-emea.com       => org_name=acme,      base_url=okta-emea.com
  derived_org_name = var.okta_org_url != null ? regex("^https?://([^./]+)\\.", var.okta_org_url)[0] : var.okta_org_name
  derived_base_url = var.okta_org_url != null ? regex("^https?://[^./]+\\.(.+?)(/.*)?$", var.okta_org_url)[0] : var.okta_base_url
}

provider "okta" {
  api_token = var.okta_api_token
  org_name  = local.derived_org_name
  base_url  = local.derived_base_url
}


