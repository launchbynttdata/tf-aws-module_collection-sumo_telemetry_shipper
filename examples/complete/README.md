# complete

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sumo_telemetry_shipper"></a> [sumo\_telemetry\_shipper](#module\_sumo\_telemetry\_shipper) | ../.. | n/a |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 1.0 |
| <a name="module_s3_failed_logs_bucket"></a> [s3\_failed\_logs\_bucket](#module\_s3\_failed\_logs\_bucket) | terraform.registry.launch.nttdata.com/module_collection/s3_bucket/aws | ~> 1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"backend"` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_region"></a> [region](#input\_region) | (Required) The location where the resource will be created. Must not have spaces<br>    For example, us-east-1, us-west-2, eu-west-1, etc. | `string` | `"us-east-2"` | no |
| <a name="input_sumologic_kinesis_logs_source_http_endpoint_name"></a> [sumologic\_kinesis\_logs\_source\_http\_endpoint\_name](#input\_sumologic\_kinesis\_logs\_source\_http\_endpoint\_name) | Name for the Kinesis Log source HTTP endpoint used as destination by Kinesis data firehose. | `string` | n/a | yes |
| <a name="input_sumologic_kinesis_logs_source_http_endpoint_url"></a> [sumologic\_kinesis\_logs\_source\_http\_endpoint\_url](#input\_sumologic\_kinesis\_logs\_source\_http\_endpoint\_url) | URL of the Kinesis Log source HTTP endpoint used as destination by Kinesis data firehose. | `string` | n/a | yes |
| <a name="input_sumologic_kinesis_metrics_source_http_endpoint_name"></a> [sumologic\_kinesis\_metrics\_source\_http\_endpoint\_name](#input\_sumologic\_kinesis\_metrics\_source\_http\_endpoint\_name) | Name for the Kinesis Metrics source HTTP endpoint used as destination by Kinesis data firehose. | `string` | n/a | yes |
| <a name="input_sumologic_kinesis_metrics_source_http_endpoint_url"></a> [sumologic\_kinesis\_metrics\_source\_http\_endpoint\_url](#input\_sumologic\_kinesis\_metrics\_source\_http\_endpoint\_url) | URL of the Kinesis Metrics source HTTP endpoint used as destination by Kinesis data firehose. | `string` | n/a | yes |
| <a name="input_create_cloudwatch_log_stream"></a> [create\_cloudwatch\_log\_stream](#input\_create\_cloudwatch\_log\_stream) | Flag to indicate if AWS cloudwatch log stream should be created. | `bool` | `false` | no |
| <a name="input_create_cloudwatch_log_subscription_filter"></a> [create\_cloudwatch\_log\_subscription\_filter](#input\_create\_cloudwatch\_log\_subscription\_filter) | Flag to indicate if AWS cloudwatch log subscription filter should be created. | `bool` | `false` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names. | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "s3_failed_logs_bucket": {<br>    "name": "s3failedlogs"<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | n/a |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of the cloudwatch log group. |
| <a name="output_cloudwatch_log_stream_arn"></a> [cloudwatch\_log\_stream\_arn](#output\_cloudwatch\_log\_stream\_arn) | n/a |
| <a name="output_cloudwatch_log_stream_name"></a> [cloudwatch\_log\_stream\_name](#output\_cloudwatch\_log\_stream\_name) | Name of the cloudwatch log stream. |
| <a name="output_cloudwatch_metric_stream_arn"></a> [cloudwatch\_metric\_stream\_arn](#output\_cloudwatch\_metric\_stream\_arn) | n/a |
| <a name="output_cloudwatch_metric_stream_name"></a> [cloudwatch\_metric\_stream\_name](#output\_cloudwatch\_metric\_stream\_name) | n/a |
| <a name="output_logs_delivery_stream_arn"></a> [logs\_delivery\_stream\_arn](#output\_logs\_delivery\_stream\_arn) | n/a |
| <a name="output_logs_delivery_stream_name"></a> [logs\_delivery\_stream\_name](#output\_logs\_delivery\_stream\_name) | The name of the log delivery stream |
| <a name="output_logs_delivery_stream_destination_id"></a> [logs\_delivery\_stream\_destination\_id](#output\_logs\_delivery\_stream\_destination\_id) | The name of the log delivery stream |
| <a name="output_metrics_delivery_stream_arn"></a> [metrics\_delivery\_stream\_arn](#output\_metrics\_delivery\_stream\_arn) | n/a |
| <a name="output_metrics_delivery_stream_name"></a> [metrics\_delivery\_stream\_name](#output\_metrics\_delivery\_stream\_name) | The name of the metric delivery stream |
| <a name="output_metrics_delivery_stream_destination_id"></a> [metrics\_delivery\_stream\_destination\_id](#output\_metrics\_delivery\_stream\_destination\_id) | The name of the metric delivery stream |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
