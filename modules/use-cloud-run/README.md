# Cloud Run v2 Enterprise IaC Configuration

This repository contains an enterprise-grade, highly modular Terraform Infrastructure as Code (IaC) setup for provisioning Google Cloud Run v2 services and managing inbound invocation authentication natively. 

This configuration integrates directly with upstream **Google Cloud Foundation Fabric** modules, enforcing the **Principle of Least Privilege** and supporting flexible single-container or multi-container sidecar architectures seamlessly out-of-the-box.

---

## 📑 Table of Contents
- [Architecture & Access Model](#-architecture--access-model)
- [Directory Structure](#-directory-structure)
- [Variables Reference](#-variables-reference)
- [Outputs Reference](#-outputs-reference)
- [Getting Started & Deployment](#-getting-started--deployment)
- [Verification & Live Testing](#-verification--live-testing)

---

## 📁 Directory Structure

The root module resides in `cloud-run-sample/` and is self-contained:

```
/Users/timjabez/Projects/NYL/cloud-run-sample/
├── main.tf               # Invokes upstream Fabric Cloud Run v2 module directly
├── variables.tf          # Fully variablizes structural inputs and sidecar models
├── terraform.tfvars      # Out-of-the-box defaults executing Google public hello-world
├── outputs.tf            # Exposes serving URLs, identifiers, and testing CLI macros
└── providers.tf          # Configures required providers and terraform constraints
```

---

## ⚙️ Variables Reference

All properties are strictly parameterized inside `variables.tf` to make the code fully flexible for customer staging and production targets.

### Core Deployment & Identity
| Variable | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `project_id` | `string` | *Required* | Target Google Cloud Project ID where the service resides. |
| `region` | `string` | `"us-east4"` | Target Google Cloud deployment region. |
| `service_name` | `string` | *Required* | Target identifier string for the deployed Cloud Run v2 Service. |
| `create_service_account` | `bool` | `true` | Toggles dynamic provision of a runtime service account identity. |
| `service_account_roles` | `list(string)`| `["roles/logging.logWriter", "roles/monitoring.metricWriter"]` | Standard base IAM roles bound directly to the container runtime service account. |

### Networking & Ingress
| Variable | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `vpc_network` | `string` | *Required* | Parent VPC network identifier for direct Serverless VPC egress. |
| `vpc_subnetwork` | `string` | *Required* | Subnetwork target mapped to dynamic serverless outbound routes. |
| `vpc_egress` | `string` | `"ALL_TRAFFIC"` | Controls VPC egress behavior (`ALL_TRAFFIC` or `PRIVATE_RANGES_ONLY`). |
| `ingress` | `string` | `"INGRESS_TRAFFIC_ALL"` | Ingress setting constraints (`INGRESS_TRAFFIC_ALL`, `INGRESS_TRAFFIC_INTERNAL_ONLY`, etc.). |

### Operational Limits & Auto-scaling
| Variable | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `min_instance_count` | `number` | `1` | Minimum baseline active containers kept hot to prevent cold-starts. |
| `max_instance_count` | `number` | `10` | Upper bound auto-scaling thresholds based on concurrent user requests. |
| `timeout` | `string` | `"3600s"` | Maximum processing runtime allocation for single request events. |
| `deletion_protection` | `bool` | `false` | Toggles provider-level safeguard against destructive reprovisioning. |

### Container Lifecycle & Injections
| Variable | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `containers` | `map(object)` | *Required* | Unified structural object configuring one or more sidecars natively. |
| `container_env` | `map(string)` | `{}` | Application environment injection keys decoupled from source logic. |

### Inbound Caller Authentication
| Variable | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `portal_invoker_sa_email` | `string` | `""` | Dedicated frontend gateway runtime caller authorized to trigger logic. |
| `shared_wif_service_account` | `string` | `""` | CI/CD pipeline SA acting under Workload Identity for validation hooks. |
| `service_invoker_sa_emails`| `list(string)`| `[]` | Authorized server-to-server backend callers bound with `run.invoker`. |

---

## 📤 Outputs Reference

The configuration extracts operational endpoints to verify deployments or configure third-party downstream access:

| Output Name | Type | Description |
| :--- | :--- | :--- |
| `service_uri` | `string` | Fully qualified secure base serving address assigned by Google. |
| `service_name` | `string` | Literal target revision and service namespace string. |
| `service_id` | `string` | Fully qualified URI resource path for advanced IAM cross-project mapping. |
| `service_account_email` | `string` | Raw runtime SA email address assigned to the container boundary. |
| `service_account_iam_email`| `string` | Formatted `"serviceAccount:<email>"` string convenient for downstream permissions. |
| `invoke_command` | `string` | Pre-formatted terminal cURL invocation command embedded with live OIDC identity tokens. |

---

## 🚀 Getting Started & Deployment

### 1. Clone and Configure Defaults
Open `terraform.tfvars` and customize values according to your customer's target environment. Out of the box, it configures deployment of Google's official public hello-world container image:

```tf
project_id   = "target-customer-project-id"
region       = "us-central1"
service_name = "premium-control-plane"

containers = {
  app-core = {
    image = "us-docker.pkg.dev/cloudrun/container/hello:latest"
    resources = {
      limits = {
        cpu    = "1"
        memory = "512Mi"
      }
    }
    ports = {
      default = {
        container_port = 8080
      }
    }
  }
}

vpc_network    = "custom-vpc-link"
vpc_subnetwork = "custom-subnetwork-link"
```

### 2. Initialize and Apply
Ensure your Google Cloud SDK terminal session is authenticated (`gcloud auth login`), then initialize and apply:

```bash
cd /Users/timjabez/Projects/NYL/cloud-run-sample
terraform init -upgrade
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

---

## 🧪 Verification & Live Testing

Once the service provisions, use the generated macro output to test private routing and identity-aware verification right inside your terminal.

### Retrieving the Macro Command
```bash
terraform output -raw invoke_command
```

### Executing the Test
Run the extracted macro script directly:
```bash
curl -H "Authorization: bearer $(gcloud auth print-identity-token)" \
  https://service-hello-world-xxxxxx-el.a.run.app \
  -X POST -d 'data'
```

> [!IMPORTANT]
> If the returned payload is a standard HTML file containing `<title>Congratulations | Cloud Run</title>`, the target infrastructure is **100% verified and fully operational**!
