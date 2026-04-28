output "organization_id" {
  description = "The organization ID."
  value       = module.org-policies.id
}

output "organization_policies_ids" {
  description = "Map of ORGANIZATION_POLICIES => ID in the organization."
  value       = module.org-policies.organization_policies_ids
}
