output "GOOGLE_PROJECT_ID" {
  value       = data.google_project.project.project_id
  description = "Google project ID."
}

output "GOOGLE_PROJECT_NUMBER" {
  value       = data.google_project.project.number
  description = "Google project number."
}

output "OIDC_SERVICE_ACCOUNT_EMAIL" {
  value       = var.existing_service_account_email == "" ? google_service_account.circleci[0].email : var.existing_service_account_email
  description = "OIDC service account ID."
}

output "OIDC_WIP_ID" {
  value       = google_iam_workload_identity_pool.circleci.workload_identity_pool_id
  description = "GCP IAM workload identity pool ID."
}

output "OIDC_WIP_PROVIDER_ID" {
  value       = google_iam_workload_identity_pool_provider.circleci.workload_identity_pool_provider_id
  description = "GCP IAM workload identity pool provider ID."
}