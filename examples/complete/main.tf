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

module "sumo_telemetry_shipper" {
  source = "../.."

  sumologic_kinesis_logs_source_http_endpoint_name    = var.sumologic_kinesis_logs_source_http_endpoint_name
  sumologic_kinesis_logs_source_http_endpoint_url     = var.sumologic_kinesis_logs_source_http_endpoint_url
  create_cloudwatch_log_stream                        = var.create_cloudwatch_log_stream
  create_cloudwatch_log_subscription_filter           = var.create_cloudwatch_log_subscription_filter
  sumologic_kinesis_metrics_source_http_endpoint_url  = var.sumologic_kinesis_metrics_source_http_endpoint_url
  sumologic_kinesis_metrics_source_http_endpoint_name = var.sumologic_kinesis_metrics_source_http_endpoint_name
  s3_failed_logs_bucket_arn                           = module.s3_failed_logs_bucket.arn
}

module "resource_names" {
  source = "git::https://github.com/launchbynttdata/tf-launch-module_library-resource_name.git?ref=1.0.0"

  for_each = var.resource_names_map

  logical_product_name = var.naming_prefix
  region               = join("", split("-", var.region))
  class_env            = var.environment
  cloud_resource_type  = each.value.name
  instance_env         = var.environment_number
  instance_resource    = var.resource_number
  maximum_length       = each.value.max_length
}

module "s3_failed_logs_bucket" {
  source = "git::https://github.com/launchbynttdata/tf-aws-module_collection-s3_bucket.git?ref=1.0.0"

  naming_prefix      = var.naming_prefix
  environment        = var.environment
  environment_number = var.environment_number
  region             = var.region
  resource_number    = var.resource_number

  use_default_server_side_encryption = true

  bucket_name = module.resource_names["s3_failed_logs_bucket"].recommended_per_length_restriction
}
