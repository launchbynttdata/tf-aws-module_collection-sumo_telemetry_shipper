# complete

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.57.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sumo_telemetry_shipper"></a> [sumo\_telemetry\_shipper](#module\_sumo\_telemetry\_shipper) | ../.. | n/a |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | git::https://github.com/launchbynttdata/tf-launch-module_library-resource_name.git | 1.0.0 |
| <a name="module_s3_failed_logs_bucket"></a> [s3\_failed\_logs\_bucket](#module\_s3\_failed\_logs\_bucket) | git::https://github.com/launchbynttdata/tf-aws-module_collection-s3_bucket.git | 1.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_naming_prefix"></a> [naming\_prefix](#input\_naming\_prefix) | Prefix for the provisioned resources. | `string` | `"example"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region in which the infra needs to be provisioned. | `string` | `"us-east-2"` | no |
| <a name="input_sumologic_kinesis_logs_source_http_endpoint_name"></a> [sumologic\_kinesis\_logs\_source\_http\_endpoint\_name](#input\_sumologic\_kinesis\_logs\_source\_http\_endpoint\_name) | Name for the Kinesis Log source HTTP endpoint used as destination by Kinesis data firehose. | `string` | n/a | yes |
| <a name="input_sumologic_kinesis_logs_source_http_endpoint_url"></a> [sumologic\_kinesis\_logs\_source\_http\_endpoint\_url](#input\_sumologic\_kinesis\_logs\_source\_http\_endpoint\_url) | URL of the Kinesis Log source HTTP endpoint used as destination by Kinesis data firehose. | `string` | n/a | yes |
| <a name="input_sumologic_kinesis_metrics_source_http_endpoint_name"></a> [sumologic\_kinesis\_metrics\_source\_http\_endpoint\_name](#input\_sumologic\_kinesis\_metrics\_source\_http\_endpoint\_name) | Name for the Kinesis Metrics source HTTP endpoint used as destination by Kinesis data firehose. | `string` | n/a | yes |
| <a name="input_sumologic_kinesis_metrics_source_http_endpoint_url"></a> [sumologic\_kinesis\_metrics\_source\_http\_endpoint\_url](#input\_sumologic\_kinesis\_metrics\_source\_http\_endpoint\_url) | URL of the Kinesis Metrics source HTTP endpoint used as destination by Kinesis data firehose. | `string` | n/a | yes |
| <a name="input_create_cloudwatch_log_stream"></a> [create\_cloudwatch\_log\_stream](#input\_create\_cloudwatch\_log\_stream) | Flag to indicate if AWS cloudwatch log stream should be created. | `bool` | `false` | no |
| <a name="input_create_cloudwatch_log_subscription_filter"></a> [create\_cloudwatch\_log\_subscription\_filter](#input\_create\_cloudwatch\_log\_subscription\_filter) | Flag to indicate if AWS cloudwatch log subscription filter should be created. | `bool` | `false` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names. | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "s3_failed_logs_bucket": {<br>    "name": "s3-failed-logs"<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | n/a |
| <a name="output_cloudwatch_log_stream_arn"></a> [cloudwatch\_log\_stream\_arn](#output\_cloudwatch\_log\_stream\_arn) | n/a |
| <a name="output_cloudwatch_metric_stream_arn"></a> [cloudwatch\_metric\_stream\_arn](#output\_cloudwatch\_metric\_stream\_arn) | n/a |
| <a name="output_logs_delivery_stream_arn"></a> [logs\_delivery\_stream\_arn](#output\_logs\_delivery\_stream\_arn) | n/a |
| <a name="output_metrics_delivery_stream_arn"></a> [metrics\_delivery\_stream\_arn](#output\_metrics\_delivery\_stream\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
