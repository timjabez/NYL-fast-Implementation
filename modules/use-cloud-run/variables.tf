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

variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "region" {
  description = "The Google Cloud region."
  type        = string
  default     = "us-east4"
}

variable "service_name" {
  description = "The name of the Cloud Run service."
  type        = string
}

variable "vpc_network" {
  description = "The name or self-link of the VPC network."
  type        = string
}

variable "vpc_subnetwork" {
  description = "The name or self-link of the VPC subnetwork."
  type        = string
}

variable "portal_invoker_sa_email" {
  description = "The email address of the service account used by the portal to invoke the Cloud Run service. Optional."
  type        = string
  default     = ""
}

variable "shared_wif_service_account" {
  description = "The email address of the WIF service account used by CI/CD to invoke the Cloud Run service (health checks). Optional."
  type        = string
  default     = ""
}

variable "service_invoker_sa_emails" {
  description = "The email addresses of the service accounts for other backend services that are authorized to invoke the Cloud Run service."
  type        = list(string)
  default     = []
}

variable "deletion_protection" {
  description = "Deletion protection setting for the Cloud Run service."
  type        = bool
  default     = false
}

variable "ingress" {
  description = "The ingress settings for the Cloud Run service. Allowed values: INGRESS_TRAFFIC_ALL, INGRESS_TRAFFIC_INTERNAL_ONLY, INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER."
  type        = string
  default     = "INGRESS_TRAFFIC_ALL"
}

variable "min_instance_count" {
  description = "The minimum number of container instances to keep warm."
  type        = number
  default     = 1
}

variable "max_instance_count" {
  description = "The maximum number of container instances that can be scaled."
  type        = number
  default     = 10
}

variable "timeout" {
  description = "The maximum request duration in seconds."
  type        = string
  default     = "3600s"
}

variable "create_service_account" {
  description = "Whether to natively provision a new service account for the service runtime."
  type        = bool
  default     = true
}

variable "service_account_roles" {
  description = "The list of IAM roles to assign to the provisioned service account."
  type        = list(string)
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ]
}

variable "vpc_egress" {
  description = "Egress settings for VPC access. Allowed values: ALL_TRAFFIC, PRIVATE_RANGES_ONLY."
  type        = string
  default     = "ALL_TRAFFIC"
}

variable "containers" {
  description = "Containers in name => attributes format."
  type = map(object({
    image      = string
    depends_on = optional(list(string))
    command    = optional(list(string))
    args       = optional(list(string))
    env        = optional(map(string))
    env_from_key = optional(map(object({
      secret  = string
      version = string
    })))
    liveness_probe = optional(object({
      grpc = optional(object({
        port    = optional(number)
        service = optional(string)
      }))
      http_get = optional(object({
        http_headers = optional(map(string))
        path         = optional(string)
        port         = optional(number)
      }))
      failure_threshold     = optional(number)
      initial_delay_seconds = optional(number)
      period_seconds        = optional(number)
      timeout_seconds       = optional(number)
    }))
    ports = optional(map(object({
      container_port = optional(number)
      name           = optional(string)
    })))
    resources = optional(object({
      limits            = optional(map(string))
      cpu_idle          = optional(bool)
      startup_cpu_boost = optional(bool)
    }))
    startup_probe = optional(object({
      grpc = optional(object({
        port    = optional(number)
        service = optional(string)
      }))
      http_get = optional(object({
        http_headers = optional(map(string))
        path         = optional(string)
        port         = optional(number)
      }))
      tcp_socket = optional(object({
        port = optional(number)
      }))
      failure_threshold     = optional(number)
      initial_delay_seconds = optional(number)
      period_seconds        = optional(number)
      timeout_seconds       = optional(number)
    }))
    volume_mounts = optional(map(string))
  }))
}
