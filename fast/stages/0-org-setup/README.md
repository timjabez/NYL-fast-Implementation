# Organization Setup (Basic)

This folder contains a basic implementation of the FAST `0-org-setup` stage, calling the shared `organization` module. It is designed to apply organization policies from YAML files located in the `org-policies` directory.

## Design overview and choices

This stage is a thin wrapper around the underlying `organization` module. It allows you to manage organization policies by placing YAML files in a dedicated folder, which are then processed by the module's factory functionality.

## How to run this stage

This stage is meant to be executed to set up organization-level configurations like policies.

### Prerequisites

- Access to a GCP Organization.
- The Organization ID (in the format `organizations/nnnnnnnnnn`).
- Terraform CLI installed.

### Execution

1.  **Initialize Terraform**:
    ```bash
    terraform init
    ```

2.  **Provide Variables**:
    You need to provide the `organization_id`. You can do this by creating a `terraform.tfvars` file:
    ```terraform
    organization_id = "organizations/1234567890" # Replace with your Org ID
    ```

3.  **Plan and Apply**:
    Run the standard Terraform flow:
    ```bash
    terraform plan
    ```
    Review the plan and if satisfied, apply it:
    ```bash
    terraform apply
    ```

## Files

| Name | Description |
|---|---|
| [main.tf](./main.tf) | Calls the organization module with factory config. |
| [variables.tf](./variables.tf) | Defines input variables for the stage. |
| [outputs.tf](./outputs.tf) | Defines outputs for the stage. |
| [versions.tf](./versions.tf) | Pin provider and Terraform versions. |
| [org-policies/](./org-policies/) | Folder where you place your policy YAML files. |

## Variables

| Name | Description | Type | Required | Default |
|---|---|:---:|:---:|---|
| `organization_id` | Organization id in `organizations/nnnnnn` format. | `string` | ✓ | |
| `org_policies_path` | Path to the folder where you will put your policy YAML files. | `string` | | `./org-policies` |

## Outputs

| Name | Description |
|---|---|
| `organization_id` | The organization ID. |
| `organization_policies_ids` | Map of ORGANIZATION_POLICIES => ID in the organization. |
