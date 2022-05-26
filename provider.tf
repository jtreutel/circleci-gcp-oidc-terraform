provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region
}

# Required for workload identity pool resources
provider "google-beta" {
  project = var.gcp_project_name
  region  = var.gcp_region
}