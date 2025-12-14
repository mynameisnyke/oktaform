variable "okta_api_token" {
  description = "Okta API token used by Terraform (set via TF_VAR_okta_api_token)."
  type        = string
  sensitive   = true
}

variable "okta_org_url" {
  description = "Full Okta org URL (e.g., https://dev-123456.okta.com). If set, it takes precedence over okta_org_name/base_url."
  type        = string
  default     = null

  validation {
    condition = (
      var.okta_org_url == null
      || can(regex("^https?://[^/]+$", var.okta_org_url))
    )
    error_message = "If set, okta_org_url must look like 'https://your-org.your-domain' with no path (e.g., https://dev-123456.okta.com)."
  }
}

variable "okta_org_name" {
  description = "Okta org name (e.g., dev-123456). Used only when okta_org_url is not set."
  type        = string
  default     = null
  validation {
    condition     = var.okta_org_name == null || try(trimspace(var.okta_org_name), "") != ""
    error_message = "If set, okta_org_name must be non-empty."
  }
}

variable "okta_base_url" {
  description = "Okta base domain (e.g., okta.com, okta-emea.com). Used only when okta_org_url is not set."
  type        = string
  default     = "okta.com"
}


