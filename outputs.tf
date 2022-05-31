output "service_account_name" {
  value = var.existing_service_account_name == "" ? google_service_account.circleci[0].name : var.existing_service_account_name
}

