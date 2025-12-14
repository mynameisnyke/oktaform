# Skeleton SAML applications for demo purposes
# These apps use placeholder URLs and minimal configuration

resource "okta_app_saml" "google_workspace" {
  label                    = "Google Workspace"
  sso_url                  = "https://accounts.google.com/o/saml2/idp?idpid=demo"
  recipient                = "https://accounts.google.com/o/saml2/idp?idpid=demo"
  destination              = "https://accounts.google.com/o/saml2/idp?idpid=demo"
  audience                 = "https://accounts.google.com/o/saml2/idp?idpid=demo"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  subject_name_id_template = "user.email"
  response_signed          = true
  assertion_signed         = true
  signature_algorithm      = "RSA_SHA256"
  digest_algorithm         = "SHA256"
  honor_force_authn        = true
  authn_context_class_ref  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
  user_name_template       = "user.email"
  user_name_template_type  = "BUILT_IN"
  status                   = "ACTIVE"
}

resource "okta_app_saml" "github_enterprise" {
  label                    = "GitHub Enterprise"
  sso_url                  = "https://github.com/orgs/demo/sso/saml/consume"
  recipient                = "https://github.com/orgs/demo/sso/saml/consume"
  destination              = "https://github.com/orgs/demo/sso/saml/consume"
  audience                 = "https://github.com/orgs/demo/sso/saml/metadata"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  subject_name_id_template = "user.email"
  response_signed          = true
  assertion_signed         = true
  signature_algorithm      = "RSA_SHA256"
  digest_algorithm         = "SHA256"
  honor_force_authn        = true
  authn_context_class_ref  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
  user_name_template       = "user.email"
  user_name_template_type  = "BUILT_IN"
  status                   = "ACTIVE"
}

resource "okta_app_saml" "slack" {
  label                    = "Slack"
  sso_url                  = "https://demo.slack.com/sso/saml"
  recipient                = "https://demo.slack.com/sso/saml"
  destination              = "https://demo.slack.com/sso/saml"
  audience                 = "https://demo.slack.com/sso/saml/metadata"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  subject_name_id_template = "user.email"
  response_signed          = true
  assertion_signed         = true
  signature_algorithm      = "RSA_SHA256"
  digest_algorithm         = "SHA256"
  honor_force_authn        = true
  authn_context_class_ref  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
  user_name_template       = "user.email"
  user_name_template_type  = "BUILT_IN"
  status                   = "ACTIVE"
}

