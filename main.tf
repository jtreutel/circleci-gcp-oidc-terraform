resource "google_iam_workload_identity_pool" "circleci" {
  workload_identity_pool_id = lower("${var.resource_prefix}-oidc-pool")
  display_name              = "${var.resource_prefix} OIDC Auth Pool"
  description               = "Identity pool for CircleCI OIDC authentication"
}

resource "google_iam_workload_identity_pool_provider" "circleci" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.circleci.workload_identity_pool_id
  workload_identity_pool_provider_id = lower("${var.resource_prefix}-oidc-prv")
  display_name                       = "${var.resource_prefix} OIDC Auth"
  description                        = "Identity pool provider for CircleCI OIDC authentication"
  attribute_condition                = coalesce(var.wip_provider_attribute_condition, "attribute.org_id=='${var.circleci_org_id}'")
  attribute_mapping = merge(
    {
      "attribute.org_id" = "assertion.aud",
      "google.subject"   = "assertion.sub"
    },
    var.custom_attribute_mappings
  )
  oidc {
    allowed_audiences = ["${var.circleci_org_id}"]
    issuer_uri        = "https://oidc.circleci.com/org/${var.circleci_org_id}"
  }
}



resource "google_service_account" "circleci" {
  count = var.existing_service_account_email == "" ? 1 : 0

  account_id   = lower("${var.resource_prefix}-oidc-acct")
  display_name = "${var.resource_prefix} Pipeline User"
}

#Allow CircleCI to impersonate SA
resource "google_service_account_iam_member" "circleci_impersonation" {
  service_account_id = var.existing_service_account_email == "" ? google_service_account.circleci[0].name : data.google_service_account.existing_sa[var.existing_service_account_email].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.circleci.workload_identity_pool_id}/${local.sa_impersonation_filter_attribute}/${local.sa_impersonation_filter_value}"
}

resource "google_project_iam_member" "project" {
  for_each = concat(
    toset(["roles/iam.serviceAccountUser", "roles/iam.serviceAccountOpenIdTokenCreator"]),
    var.roles_to_bind
  )

  project = data.google_project.project.project_id
  role    = each.value
  member  = "serviceAccount:${var.existing_service_account_email == "" ? google_service_account.circleci[0].email : data.google_service_account.existing_sa[var.existing_service_account_email].email}"
}