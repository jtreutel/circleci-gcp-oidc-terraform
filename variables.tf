#-------------------------------------------------------------------------------
# REQUIRED VARS
#-------------------------------------------------------------------------------


variable "circleci_org_id" {
  type        = string
  description = "Your CircleCI org ID.  Can be found under \"Organization Settings\" in the CircleCI application."
}

#-------------------------------------------------------------------------------
# OPTIONAL VARS
#-------------------------------------------------------------------------------


variable "resource_prefix" {
  type        = string
  default     = "CircleCI"
  description = "A prefix that will be added to all resources created by this Terraform plan."
}

variable "custom_attribute_mappings" {
  type        = map(string)
  description = "List of custom attribute mappings.  See https://cloud.google.com/iam/docs/workload-identity-federation#mapping and https://circleci.com/docs2/2.0/openid-connect-tokens#format-of-the-openid-connect-id-token."
}

variable "existing_service_account_name" {
  type        = string
  description = "Enter the name of the GCP SA that CircleCI should impersonate.  Leave blank to create a new service account."
  default     = ""
}

variable "debug" {
  type        = bool
  default     = false
  description = "Grants ServiceAccountUser permission to the service account for testing purposes."
}

# These two variables can be used to restrict who can impersonate a service account based on the values of the assertions in the CircleCI OIDC token

variable "sa_impersonation_filter_attribute" {
  type        = string
  description = "A GCP workload identity pool provider attribute to use for restricting role impersonation to specific CircleCI orgs, projects, or contexts. Defaults to CircleCI org ID."
  default     = "" #defaults to "attribute.org_id"
}

variable "sa_impersonation_filter_value" {
  type        = string
  description = "A GCP workload identity pool provider attribute value to use for restricting role impersonation to specific CircleCI orgs, projects, or contexts. Defaults to CircleCI org ID."
  default     = "" #defaults to your CircleCI org ID
}

variable "wip_provider_attribute_condition" {
  type        = string
  description = "CEL expression describing which principles are allowed to impersonate service accounts. Defaults to anyone from your CircleCI org."
  default     = ""
}
