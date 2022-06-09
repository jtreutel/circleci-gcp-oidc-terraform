provider "google" {
  credentials = "key.json"
  project     = var.gcp_project_name
  region      = var.gcp_region
}

# Required for workload identity pool resources
provider "google-beta" {
  credentials = "key.json"
  project     = var.gcp_project_name
  region      = var.gcp_region
}