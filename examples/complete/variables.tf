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

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false
  default     = "launch"

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false
  default     = "backend"

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }
}

variable "instance_resource" {
  type        = number
  description = "Number that represents the instance of the resource."
  default     = 0

  validation {
    condition     = var.instance_resource >= 0 && var.instance_resource <= 100
    error_message = "Instance number should be between 1 to 100."
  }
}

variable "instance_env" {
  type        = number
  description = "Number that represents the instance of the environment."
  default     = 0

  validation {
    condition     = var.instance_env >= 0 && var.instance_env <= 999
    error_message = "Instance number should be between 1 to 999."
  }
}

variable "class_env" {
  type        = string
  default     = "dev"
  description = "(Required) Environment where resource is going to be deployed. For example. dev, qa, uat"
  nullable    = false

  validation {
    condition     = length(regexall("\\b \\b", var.class_env)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

variable "region" {
  type        = string
  description = <<EOF
    (Required) The location where the resource will be created. Must not have spaces
    For example, us-east-1, us-west-2, eu-west-1, etc.
  EOF
  nullable    = false
  default     = "us-east-2"

  validation {
    condition     = length(regexall("\\b \\b", var.region)) == 0
    error_message = "Spaces between the words are not allowed."
  }
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
      name = "s3failedlogs"
    }
  }
}
