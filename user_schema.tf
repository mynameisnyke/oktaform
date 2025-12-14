# Custom user schema properties for HRIS data
# These attributes will be populated by HRIS system via SCIM/API sync

resource "okta_user_schema_property" "employee_status" {
  index       = "employeeStatus"
  title       = "Employee Status"
  type        = "string"
  description = "Employee status synced from HRIS system (e.g., FULL_TIME, CONTRACTOR, PART_TIME)"

  # Allow HRIS to write this field, but users/admins can read it
  permissions = "READ_ONLY"

  # Make it searchable and filterable
  master = "OKTA"

  # Optional: Set enum values if you want to restrict to specific statuses
  # enum = ["FULL_TIME", "CONTRACTOR", "PART_TIME", "TERMINATED"]
}
