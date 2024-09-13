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
  value = module.cloudwatch_log_group_wrapper.cloudwatch_log_group_arn
}

output "cloudwatch_log_group_name" {
  value       = module.cloudwatch_log_group_wrapper.cloudwatch_log_group_name
  description = "Name of the cloudwatch log group."
}

output "cloudwatch_log_stream_arn" {
  value = module.cloudwatch_log_group_wrapper.cloudwatch_log_stream_arn
}

output "cloudwatch_log_stream_name" {
  value       = module.cloudwatch_log_group_wrapper.cloudwatch_log_stream_name
  description = "Name of the cloudwatch log stream."
}


output "cloudwatch_metric_stream_arn" {
  value = module.cloudwatch_metric_stream.arn
}

output "cloudwatch_metric_stream_name" {
  description = "Name of the metric stream."
  value       = module.cloudwatch_metric_stream.name
}

output "logs_delivery_stream_arn" {
  value = module.logs_firehose_delivery_stream.arn
}

output "logs_delivery_stream_name" {
  description = "The name of the log delivery stream"
  value       = module.logs_firehose_delivery_stream.name
}

output "logs_delivery_stream_destination_id" {
  description = "The name of the log delivery stream"
  value       = module.logs_firehose_delivery_stream.destination_id
}

output "metrics_delivery_stream_arn" {
  value = module.metrics_firehose_delivery_stream.arn
}

output "metrics_delivery_stream_name" {
  description = "The name of the metrics delivery stream"
  value       = module.metrics_firehose_delivery_stream.name
}

output "metrics_delivery_stream_destination_id" {
  description = "The name of the metrics delivery stream"
  value       = module.metrics_firehose_delivery_stream.destination_id
}
