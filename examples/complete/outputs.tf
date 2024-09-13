// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

output "cloudwatch_log_group_arn" {
  description = "ARN of the cloudwatch log group."
  value       = module.sumo_telemetry_shipper.cloudwatch_log_group_arn
}

output "cloudwatch_log_group_name" {
  value       = module.sumo_telemetry_shipper.cloudwatch_log_group_name
  description = "Name of the cloudwatch log group."
}

output "cloudwatch_log_stream_arn" {
  value       = module.sumo_telemetry_shipper.cloudwatch_log_stream_arn
  description = "ARN of the cloudwatch log stream."
}

output "cloudwatch_log_stream_name" {
  value       = module.sumo_telemetry_shipper.cloudwatch_log_stream_name
  description = "Name of the cloudwatch log stream."
}

output "cloudwatch_metric_stream_arn" {
  description = "ARN of the metric stream."
  value       = module.sumo_telemetry_shipper.cloudwatch_metric_stream_arn
}

output "cloudwatch_metric_stream_name" {
  description = "Name of the metric stream."
  value       = module.sumo_telemetry_shipper.cloudwatch_metric_stream_name
}

output "logs_delivery_stream_arn" {
  description = "The ARN of the log delivery stream"
  value       = module.sumo_telemetry_shipper.logs_delivery_stream_arn
}

output "logs_delivery_stream_name" {
  description = "The name of the log delivery stream"
  value       = module.sumo_telemetry_shipper.logs_delivery_stream_name
}

output "logs_delivery_stream_destination_id" {
  description = "The id of the log delivery stream"
  value       = module.sumo_telemetry_shipper.logs_delivery_stream_destination_id
}

output "metrics_delivery_stream_arn" {
  description = "The ARN of the metrics delivery stream"
  value       = module.sumo_telemetry_shipper.metrics_delivery_stream_arn
}

output "metrics_delivery_stream_name" {
  description = "The name of the metric delivery stream"
  value       = module.sumo_telemetry_shipper.metrics_delivery_stream_name
}

output "metrics_delivery_stream_destination_id" {
  description = "The id of the metric delivery stream"
  value       = module.sumo_telemetry_shipper.metrics_delivery_stream_destination_id
}
