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

output "service_uri" {
  description = "The URI where the Cloud Run service is serving traffic."
  value       = module.cloud_run.service_uri
}

output "service_name" {
  description = "The name of the Cloud Run service."
  value       = module.cloud_run.service_name
}

output "service_id" {
  description = "The fully qualified ID of the Cloud Run service."
  value       = module.cloud_run.id
}

output "service_account_email" {
  description = "The service account email used by the Cloud Run service."
  value       = module.cloud_run.service_account_email
}

output "service_account_iam_email" {
  description = "The IAM-prefixed email of the service account under which the Cloud Run service runs (prefixed with 'serviceAccount:')."
  value       = module.cloud_run.service_account_iam_email
}

output "invoke_command" {
  description = "The command used to call and invoke the deployed Cloud Run service."
  value       = module.cloud_run.invoke_command
}
