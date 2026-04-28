provider "google" {
  billing_project       = var.quota_project_id
  user_project_override = true
}

provider "google-beta" {
  billing_project       = var.quota_project_id
  user_project_override = true
}
