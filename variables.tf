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
variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
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
    logs_delivery_stream = {
      name       = "logsds"
      max_length = 60
    }
    metrics_delivery_stream = {
      name       = "metricsds"
      max_length = 60
    }
    logs_producer_policy = {
      name       = "logsprdcrplcy"
      max_length = 60
    }
    logs_producer_role = {
      name       = "logsprdcrrole"
      max_length = 60
    }
    metrics_producer_policy = {
      name       = "metricsprdcrplcy"
      max_length = 60
    }
    metrics_producer_role = {
      name       = "metricsprdcrrole"
      max_length = 60
    }
    logs_consumer_policy = {
      name       = "logscnsmrplcy"
      max_length = 60
    }
    logs_consumer_role = {
      name       = "logscnsmrrole"
      max_length = 60
    }
    metrics_consumer_policy = {
      name       = "metricscnsmrplcy"
      max_length = 60
    }
    metrics_consumer_role = {
      name       = "metricscnsmrrole"
      max_length = 60
    }
    log_group = {
      name       = "lg"
      max_length = 63
    }
    subscription_filter = {
      name       = "subfltr"
      max_length = 63
    }
    log_stream = {
      name       = "ls"
      max_length = 63
    }
    metrics_stream = {
      name       = "ms"
      max_length = 63
    }
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

variable "logs_path_expression" {
  description = "Path to the data within the S3 Bucket. If utilizing the tf-aws-module_primitive-firehose_delivery_stream module, set this value to s3_error_output_prefix and include the trailing slash. Will automatically append http-endpoint-failed/* as required by Sumo Logic."
  type        = string
  default     = null
}

variable "metrics_path_expression" {
  description = "Path to the data within the S3 Bucket. If utilizing the tf-aws-module_primitive-firehose_delivery_stream module, set this value to s3_error_output_prefix and include the trailing slash. Will automatically append http-endpoint-failed/* as required by Sumo Logic."
  type        = string
  default     = null
}

variable "logs_producer_trusted_services" {
  description = "Trusted service used for the assumption policy when creating the producer role. Defaults to the streams service for the current AWS region."
  type        = string
  default     = null
}

variable "logs_producer_external_id" {
  description = "STS External ID used for the assumption policy when creating the producer role."
  type        = list(string)
  default     = null
}

variable "metrics_producer_trusted_services" {
  description = "Trusted service used for the assumption policy when creating the producer role. Defaults to the streams service for the current AWS region."
  type        = string
  default     = null
}

variable "metrics_producer_external_id" {
  description = "STS External ID used for the assumption policy when creating the producer role."
  type        = list(string)
  default     = null
}

variable "consumer_trusted_services" {
  description = "Trusted service used for the assumption policy when creating the consumer role. Defaults to the firehose service."
  type        = string
  default     = null
}

variable "consumer_external_id" {
  description = "STS External ID used for the assumption policy when creating the consumer role. Defaults to the current AWS account ID."
  type        = string
  default     = null
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

variable "cloudwatch_metrics_namespaces" {
  type        = list(string)
  description = "A list of metrics namespaces to pull from CloudWatch into Sumo Logic. An empty list (default) exports all metrics."
  default     = []
}

variable "s3_failed_logs_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket where failed logs would be stored by Kinesis data firehose."
}
