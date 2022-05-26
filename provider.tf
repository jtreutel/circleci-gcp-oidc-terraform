provider "google" {
  project = "makoto-workbench"
  region  = "asia-northeast1-a"
}

# Required for workload identity pool resources
provider "google-beta" {
  project = "makoto-workbench"
  region  = "asia-northeast1-a"
}