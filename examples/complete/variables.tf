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

variable "naming_prefix" {
  description = "Prefix for the provisioned resources."
  type        = string
  default     = "example"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned."
  default     = "us-east-2"
}

variable "sumologic_kinesis_logs_source_http_endpoint_name" {
  description = "Name for the Kinesis Log source HTTP endpoint used as destination by Kinesis data firehose."
  type        = string
}

variable "sumologic_kinesis_logs_source_http_endpoint_url" {
  description = "URL of the Kinesis Log source HTTP endpoint used as destination by Kinesis data firehose."
  type        = string
}

variable "sumologic_kinesis_metrics_source_http_endpoint_name" {
  description = "Name for the Kinesis Metrics source HTTP endpoint used as destination by Kinesis data firehose."
  type        = string
}

variable "sumologic_kinesis_metrics_source_http_endpoint_url" {
  description = "URL of the Kinesis Metrics source HTTP endpoint used as destination by Kinesis data firehose."
  type        = string
}

variable "create_cloudwatch_log_stream" {
  description = "Flag to indicate if AWS cloudwatch log stream should be created."
  type        = bool
  default     = false
}

variable "create_cloudwatch_log_subscription_filter" {
  description = "Flag to indicate if AWS cloudwatch log subscription filter should be created."
  type        = bool
  default     = false
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names."
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    s3_failed_logs_bucket = {
      name = "s3-failed-logs"
    }
  }
}
