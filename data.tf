data "google_project" "project" {
  project_id = var.project_id
}

locals {
  sa_impersonation_filter_attribute = var.sa_impersonation_filter_attribute == "" ? "attribute.org_id" : var.sa_impersonation_filter_attribute
  sa_impersonation_filter_value     = var.sa_impersonation_filter_value == "" ? var.circleci_org_id : var.sa_impersonation_filter_value
  project_id = data.google_project.project.project_id
}

data "google_service_account" "existing_sa" {
  for_each = var.existing_service_account_email == "" ? toset([]) : toset([var.existing_service_account_email])

  account_id = var.existing_service_account_email
}