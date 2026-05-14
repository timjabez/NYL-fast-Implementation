/**
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  invoker_members = compact(concat(
    var.portal_invoker_sa_email != "" ? ["serviceAccount:${var.portal_invoker_sa_email}"] : [],
    var.shared_wif_service_account != "" ? ["serviceAccount:${var.shared_wif_service_account}"] : [],
    [for sa in var.service_invoker_sa_emails : "serviceAccount:${sa}"]
  ))
}

module "cloud_run" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/cloud-run-v2?ref=master"
  project_id = var.project_id
  region     = var.region
  name       = var.service_name

  deletion_protection = var.deletion_protection

  service_config = {
    ingress = var.ingress
    scaling = {
      min_instance_count = var.min_instance_count
      max_instance_count = var.max_instance_count
    }
    timeout = var.timeout
  }

  service_account_config = {
    create = var.create_service_account
    roles  = var.service_account_roles
  }

  revision = {
    vpc_access = {
      network = var.vpc_network
      subnet  = var.vpc_subnetwork
      egress  = var.vpc_egress
    }
  }

  containers = var.containers

  iam = length(local.invoker_members) > 0 ? {
    "roles/run.invoker" = local.invoker_members
  } : {}
}

