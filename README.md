## Oktaform (Terraform + Okta)

This repo manages Okta configuration using Terraform (groups first).

### What it creates

- **Okta groups** following the taxonomy:
  - **HRIS_***: lifecycle truth (usually sourced from HR / directory sync)
  - **BASE_***: broad access abstraction
  - **DEPT_***: org context
  - **APP_***: standard app access
  - **PRIV_***: elevated/admin access
  - **SEC_***: conditional access / security policy targeting
  - **TEMP_***: time-bound exceptions

### Prereqs

- Terraform installed
- Okta org admin permissions
- Okta API token

### Configure credentials (recommended)

Set the API token via environment variable (keeps secrets out of files and shell history if you use your shell's secure mechanisms):

```bash
export TF_VAR_okta_api_token="REDACTED"
```

Set your org:

- Preferred:

```bash
export TF_VAR_okta_org_url="https://dev-123456.okta.com"
```

- Or alternatively:

```bash
export TF_VAR_okta_org_name="dev-123456"
export TF_VAR_okta_base_url="okta.com"
```

### Run

```bash
terraform init
terraform plan
terraform apply
```

### Outputs

- `okta_group_ids`: map of group name => Okta group ID


