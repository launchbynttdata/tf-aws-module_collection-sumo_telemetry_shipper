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

data "aws_caller_identity" "current" {}

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = join("", split("-", var.region))
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
}

module "cloudwatch_log_group_wrapper" {
  source  = "terraform.registry.launch.nttdata.com/module_collection/cloudwatch_logs/aws"
  version = "~> 1.0"

  cloudwatch_log_group_name                 = module.resource_names["log_group"].standard
  create_cloudwatch_log_stream              = var.create_cloudwatch_log_stream
  create_cloudwatch_log_subscription_filter = var.create_cloudwatch_log_subscription_filter
  cloudwatch_log_stream_name                = module.resource_names["log_stream"].standard
  subscription_filter_name                  = module.resource_names["subscription_filter"].standard
  firehose_delivery_stream_arn              = module.logs_firehose_delivery_stream.arn
  subscription_filter_role                  = module.logs_producer_role.assumable_iam_role
}

module "cloudwatch_metric_stream" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/cloudwatch_metric_stream/aws"
  version = "~> 1.0"

  metric_stream_name  = module.resource_names["metrics_stream"].standard
  delivery_stream_arn = module.metrics_firehose_delivery_stream.arn
  producer_role_arn   = module.metrics_producer_role.assumable_iam_role
  metrics_namespaces  = var.cloudwatch_metrics_namespaces
}

module "logs_firehose_delivery_stream" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/firehose_delivery_stream/aws"
  version = "~> 1.0"

  delivery_stream_name   = module.resource_names["logs_delivery_stream"].standard
  http_endpoint_name     = var.sumologic_kinesis_logs_source_http_endpoint_name
  http_endpoint_url      = var.sumologic_kinesis_logs_source_http_endpoint_url
  s3_error_output_prefix = var.logs_path_expression
  s3_endpoint_bucket_arn = var.s3_failed_logs_bucket_arn
  consumer_role_arn      = module.logs_consumer_role.assumable_iam_role
}

module "metrics_firehose_delivery_stream" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/firehose_delivery_stream/aws"
  version = "~> 1.0"

  delivery_stream_name   = module.resource_names["metrics_delivery_stream"].standard
  http_endpoint_name     = var.sumologic_kinesis_metrics_source_http_endpoint_name
  http_endpoint_url      = var.sumologic_kinesis_metrics_source_http_endpoint_url
  s3_error_output_prefix = var.metrics_path_expression
  s3_endpoint_bucket_arn = var.s3_failed_logs_bucket_arn
  consumer_role_arn      = module.metrics_consumer_role.assumable_iam_role
}

module "logs_producer_role" {
  source  = "terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws"
  version = "~> 1.0"

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  environment             = var.environment
  environment_number      = var.environment_number
  region                  = var.region
  resource_number         = var.resource_number

  resource_names_map = {
    iam_role   = var.resource_names_map["logs_producer_role"]
    iam_policy = var.resource_names_map["logs_producer_policy"]
  }

  assume_iam_role_policies = [data.aws_iam_policy_document.logs_producer_policy.json]
  trusted_role_services    = local.logs_producer_trusted_services
  role_sts_externalid      = local.logs_producer_external_id
}

data "aws_iam_policy_document" "logs_producer_policy" {
  statement {
    sid    = "StreamInteractions"
    effect = "Allow"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    resources = [
      "arn:aws:firehose:${var.region}:${local.account_id}:deliverystream/${module.resource_names["logs_delivery_stream"].standard}"
    ]
  }
}

module "logs_consumer_role" {
  source  = "terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws"
  version = "~> 1.0"

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  environment             = var.environment
  environment_number      = var.environment_number
  region                  = var.region
  resource_number         = var.resource_number

  resource_names_map = {
    iam_role   = var.resource_names_map["logs_consumer_role"]
    iam_policy = var.resource_names_map["logs_consumer_policy"]
  }

  assume_iam_role_policies = [data.aws_iam_policy_document.logs_consumer_policy.json]
  trusted_role_services    = local.consumer_trusted_services
  role_sts_externalid      = local.consumer_external_id
}

data "aws_iam_policy_document" "logs_consumer_policy" {
  statement {
    sid    = "FailedLogsS3Interactions"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      var.s3_failed_logs_bucket_arn,
      "${var.s3_failed_logs_bucket_arn}/*"
    ]
  }

  statement {
    sid    = "PutLogEvents"
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]
    resources = [
      module.cloudwatch_log_group_wrapper.cloudwatch_log_group_arn
    ]
  }

  statement {
    sid    = "StreamInteractions"
    effect = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards"
    ]
    resources = [
      "arn:aws:firehose:${var.region}:${local.account_id}:deliverystream/${module.resource_names["logs_delivery_stream"].standard}"
    ]
  }

  statement {
    sid    = "PassRole"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "arn:aws:firehose:${var.region}:${local.account_id}:role/${module.resource_names["logs_consumer_role"].standard}"
    ]
  }
}

module "metrics_producer_role" {
  source  = "terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws"
  version = "~> 1.0"

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  environment             = var.environment
  environment_number      = var.environment_number
  region                  = var.region
  resource_number         = var.resource_number

  resource_names_map = {
    iam_role   = var.resource_names_map["metrics_producer_role"]
    iam_policy = var.resource_names_map["metrics_producer_policy"]
  }

  assume_iam_role_policies = [data.aws_iam_policy_document.metrics_producer_policy.json]
  trusted_role_services    = local.metrics_producer_trusted_services
  role_sts_externalid      = local.metrics_producer_external_id
}

data "aws_iam_policy_document" "metrics_producer_policy" {
  statement {
    sid    = "StreamInteractions"
    effect = "Allow"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    resources = [
      "arn:aws:firehose:${var.region}:${local.account_id}:deliverystream/${module.resource_names["metrics_delivery_stream"].standard}"
    ]
  }
}

module "metrics_consumer_role" {
  source  = "terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws"
  version = "~> 1.0"

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  environment             = var.environment
  environment_number      = var.environment_number
  region                  = var.region
  resource_number         = var.resource_number

  resource_names_map = {
    iam_role   = var.resource_names_map["metrics_consumer_role"]
    iam_policy = var.resource_names_map["metrics_consumer_policy"]
  }

  assume_iam_role_policies = [data.aws_iam_policy_document.metrics_consumer_policy.json]
  trusted_role_services    = local.consumer_trusted_services
  role_sts_externalid      = local.consumer_external_id
}

data "aws_iam_policy_document" "metrics_consumer_policy" {
  statement {
    sid    = "FailedLogsS3Interactions"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      var.s3_failed_logs_bucket_arn,
      "${var.s3_failed_logs_bucket_arn}/*"
    ]
  }

  statement {
    sid    = "PutLogEvents"
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]
    resources = [
      module.cloudwatch_metric_stream.arn
    ]
  }

  statement {
    sid    = "StreamInteractions"
    effect = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards"
    ]
    resources = [
      "arn:aws:firehose:${var.region}:${local.account_id}:deliverystream/${module.resource_names["metrics_delivery_stream"].standard}"
    ]
  }

  statement {
    sid    = "PassRole"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "arn:aws:firehose:${var.region}:${local.account_id}:role/${module.resource_names["metrics_consumer_role"].standard}"
    ]
  }
}
