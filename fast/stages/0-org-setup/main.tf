module "org-policies" {
  source          = "../../../modules/organization"
  organization_id = var.organization_id

  factories_config = {
    # Path to the folder where you will put your policy YAML files
    org_policies = var.org_policies_path
  }

  iam_bindings_additive = {
    seed_sa_project_creator = {
      member = module.seed_sa.iam_email
      role   = "roles/resourcemanager.projectCreator"
    }
    seed_sa_folder_creator = {
      member = module.seed_sa.iam_email
      role   = "roles/resourcemanager.folderCreator"
    }
  }
}

module "folder_bootstrap" {
  source = "../../../modules/folder"
  parent = var.organization_id
  name   = "Bootstrap"
}

module "project_seed" {
  source          = "../../../modules/project"
  parent          = module.folder_bootstrap.id
  name            = "prj-b-seed-v2"
  prefix          = "nyl"
  billing_account = var.billing_account
  services = [
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com"
  ]
}

module "seed_sa" {
  source       = "../../../modules/iam-service-account"
  project_id   = module.project_seed.project_id
  name         = "project-factory"
  display_name = "Seed Project Factory Service Account"
}

module "folder_common" {
  source = "../../../modules/folder"
  parent = var.organization_id
  name   = "Common"
}

module "project_logging" {
  source          = "../../../modules/project"
  parent          = module.folder_common.id
  name            = "prj-c-log-v2"
  prefix          = "nyl"
  billing_account = var.billing_account
  services = [
    "logging.googleapis.com",
    "bigquery.googleapis.com"
  ]
}
