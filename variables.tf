#-------------------------------------------------------------------------------
# REQUIRED VARS
#-------------------------------------------------------------------------------


variable "circleci_org_id" {
  type = string
  description = "Your CircleCI org ID.  Can be found under \"Organization Settings\" in the CircleCI application."
}

#-------------------------------------------------------------------------------
# OPTIONAL VARS
#-------------------------------------------------------------------------------


variable "resource_prefix" {
  type    = string
  default = "CircleCI"
  description = "A prefix that will be added to all resources created by this Terraform plan."
}

variable "debug" {
  type        = bool
  default     = false
  description = "Grants ServiceAccountUser permission to the service account for testing purposes."
}