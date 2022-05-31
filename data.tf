data "google_project" "project" {}

locals {
  sa_impersonation_filter_attribute = var.sa_impersonation_filter_attribute == "" ? "attribute.org_id" : var.sa_impersonation_filter_attribute
  sa_impersonation_filter_value     = var.sa_impersonation_filter_value == "" ? var.circleci_org_id : var.sa_impersonation_filter_value
}