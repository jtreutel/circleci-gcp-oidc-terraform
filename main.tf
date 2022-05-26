resource "google_iam_workload_identity_pool" "circleci" {
  provider                  = google-beta
  workload_identity_pool_id = lower("${var.resource_prefix}-oidc-pool")
  display_name              = "${var.resource_prefix} OIDC Auth Pool"
  description               = "Identity pool for CircleCI OIDC authentication"
}

resource "google_iam_workload_identity_pool_provider" "circleci" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.circleci.workload_identity_pool_id
  workload_identity_pool_provider_id = lower("${var.resource_prefix}-oidc-prv")
  display_name                       = "${var.resource_prefix} OIDC Auth"
  description                        = "Identity pool provider for CircleCI OIDC authentication"
  attribute_mapping = {
    "attribute.org_id" : "assertion.aud",
    "google.subject" : "assertion.sub"
  }
  oidc {
    allowed_audiences = ["${var.circleci_org_id}"]
    issuer_uri        = "https://oidc.circleci.com/org/${var.circleci_org_id}"
  }
}



resource "google_service_account" "circleci" {
  account_id   = lower("${var.resource_prefix}-oidc-acct")
  display_name = "${var.resource_prefix} Pipeline User"
}


resource "google_service_account_iam_binding" "circleci" {
  service_account_id = google_service_account.circleci.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    #"principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.circleci.workload_identity_pool_id}/*"
    #TODO: Narrow scope.  Maybe it's this:
    "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/{google_iam_workload_identity_pool.circleci.workload_identity_pool_id}/attribute.org_id/${var.circleci_org_id}"
  ]
}

resource "google_service_account_iam_binding" "circleci_sa_user" {
  count              = var.debug == true ? 1 : 0
  service_account_id = google_service_account.circleci.name
  role               = "roles/iam.serviceAccountAdmin"
  members = [
    "serviceAccount:${google_service_account.circleci.email}"
  ]
}

