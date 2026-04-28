variable "organization_id" {
  description = "Organization id in organizations/nnnnnn format."
  type        = string
}

variable "org_policies_path" {
  description = "Path to the folder where you will put your policy YAML files."
  type        = string
  default     = "./org-policies"
}

variable "quota_project_id" {
  description = "The project ID to use for API quota when authenticating with user credentials."
  type        = string
  default     = null
}

variable "billing_account" {
  description = "The ID of the billing account to link to projects."
  type        = string
}

