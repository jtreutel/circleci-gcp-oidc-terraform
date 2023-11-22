data "google_project" "project" {}

locals {
  sa_impersonation_filter_attribute = var.sa_impersonation_filter_attribute == "" ? "attribute.org_id" : var.sa_impersonation_filter_attribute
  sa_impersonation_filter_value     = var.sa_impersonation_filter_value == "" ? var.circleci_org_id : var.sa_impersonation_filter_value
}

data "google_service_account" "circleci_access" {
  count      = var.existing_service_account_email == "" ? 0 : 1
  account_id = var.existing_service_account_email
}