# tf-aws-module_collection-sumo_telemetry_shipper

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This module creates AWS resources to send the cloudwatch logs and cloudwatch metrics data to Sumologic collectors.

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 1.0 |
| <a name="module_cloudwatch_log_group_wrapper"></a> [cloudwatch\_log\_group\_wrapper](#module\_cloudwatch\_log\_group\_wrapper) | terraform.registry.launch.nttdata.com/module_collection/cloudwatch_logs/aws | ~> 1.0 |
| <a name="module_cloudwatch_metric_stream"></a> [cloudwatch\_metric\_stream](#module\_cloudwatch\_metric\_stream) | terraform.registry.launch.nttdata.com/module_primitive/cloudwatch_metric_stream/aws | ~> 1.0 |
| <a name="module_logs_firehose_delivery_stream"></a> [logs\_firehose\_delivery\_stream](#module\_logs\_firehose\_delivery\_stream) | terraform.registry.launch.nttdata.com/module_primitive/firehose_delivery_stream/aws | ~> 1.0 |
| <a name="module_metrics_firehose_delivery_stream"></a> [metrics\_firehose\_delivery\_stream](#module\_metrics\_firehose\_delivery\_stream) | terraform.registry.launch.nttdata.com/module_primitive/firehose_delivery_stream/aws | ~> 1.0 |
| <a name="module_logs_producer_role"></a> [logs\_producer\_role](#module\_logs\_producer\_role) | terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws | ~> 1.0 |
| <a name="module_logs_consumer_role"></a> [logs\_consumer\_role](#module\_logs\_consumer\_role) | terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws | ~> 1.0 |
| <a name="module_metrics_producer_role"></a> [metrics\_producer\_role](#module\_metrics\_producer\_role) | terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws | ~> 1.0 |
| <a name="module_metrics_consumer_role"></a> [metrics\_consumer\_role](#module\_metrics\_consumer\_role) | terraform.registry.launch.nttdata.com/module_collection/iam_assumable_role/aws | ~> 1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.logs_consumer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.logs_producer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.metrics_consumer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.metrics_producer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"backend"` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | (Required) The location where the resource will be created. Must not have spaces<br>    For example, us-east-1, us-west-2, eu-west-1, etc. | `string` | `"us-east-2"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names. | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "log_group": {<br>    "max_length": 63,<br>    "name": "lg"<br>  },<br>  "log_stream": {<br>    "max_length": 63,<br>    "name": "ls"<br>  },<br>  "logs_consumer_policy": {<br>    "max_length": 60,<br>    "name": "logscnsmrplcy"<br>  },<br>  "logs_consumer_role": {<br>    "max_length": 60,<br>    "name": "logscnsmrrole"<br>  },<br>  "logs_delivery_stream": {<br>    "max_length": 60,<br>    "name": "logsds"<br>  },<br>  "logs_producer_policy": {<br>    "max_length": 60,<br>    "name": "logsprdcrplcy"<br>  },<br>  "logs_producer_role": {<br>    "max_length": 60,<br>    "name": "logsprdcrrole"<br>  },<br>  "metrics_consumer_policy": {<br>    "max_length": 60,<br>    "name": "metricscnsmrplcy"<br>  },<br>  "metrics_consumer_role": {<br>    "max_length": 60,<br>    "name": "metricscnsmrrole"<br>  },<br>  "metrics_delivery_stream": {<br>    "max_length": 60,<br>    "name": "metricsds"<br>  },<br>  "metrics_producer_policy": {<br>    "max_length": 60,<br>    "name": "metricsprdcrplcy"<br>  },<br>  "metrics_producer_role": {<br>    "max_length": 60,<br>    "name": "metricsprdcrrole"<br>  },<br>  "metrics_stream": {<br>    "max_length": 63,<br>    "name": "ms"<br>  },<br>  "subscription_filter": {<br>    "max_length": 63,<br>    "name": "subfltr"<br>  }<br>}</pre> | no |
| <a name="input_sumologic_kinesis_logs_source_http_endpoint_name"></a> [sumologic\_kinesis\_logs\_source\_http\_endpoint\_name](#input\_sumologic\_kinesis\_logs\_source\_http\_endpoint\_name) | Name for the Kinesis Log source HTTP endpoint used as destination by Kinesis data firehose. | `string` | n/a | yes |
| <a name="input_sumologic_kinesis_logs_source_http_endpoint_url"></a> [sumologic\_kinesis\_logs\_source\_http\_endpoint\_url](#input\_sumologic\_kinesis\_logs\_source\_http\_endpoint\_url) | URL of the Kinesis Log source HTTP endpoint used as destination by Kinesis data firehose. | `string` | n/a | yes |
| <a name="input_sumologic_kinesis_metrics_source_http_endpoint_name"></a> [sumologic\_kinesis\_metrics\_source\_http\_endpoint\_name](#input\_sumologic\_kinesis\_metrics\_source\_http\_endpoint\_name) | Name for the Kinesis Metrics source HTTP endpoint used as destination by Kinesis data firehose. | `string` | n/a | yes |
| <a name="input_sumologic_kinesis_metrics_source_http_endpoint_url"></a> [sumologic\_kinesis\_metrics\_source\_http\_endpoint\_url](#input\_sumologic\_kinesis\_metrics\_source\_http\_endpoint\_url) | URL of the Kinesis Metrics source HTTP endpoint used as destination by Kinesis data firehose. | `string` | n/a | yes |
| <a name="input_logs_path_expression"></a> [logs\_path\_expression](#input\_logs\_path\_expression) | Path to the data within the S3 Bucket. If utilizing the tf-aws-module\_primitive-firehose\_delivery\_stream module, set this value to s3\_error\_output\_prefix and include the trailing slash. Will automatically append http-endpoint-failed/* as required by Sumo Logic. | `string` | `null` | no |
| <a name="input_metrics_path_expression"></a> [metrics\_path\_expression](#input\_metrics\_path\_expression) | Path to the data within the S3 Bucket. If utilizing the tf-aws-module\_primitive-firehose\_delivery\_stream module, set this value to s3\_error\_output\_prefix and include the trailing slash. Will automatically append http-endpoint-failed/* as required by Sumo Logic. | `string` | `null` | no |
| <a name="input_logs_producer_trusted_services"></a> [logs\_producer\_trusted\_services](#input\_logs\_producer\_trusted\_services) | Trusted service used for the assumption policy when creating the producer role. Defaults to the streams service for the current AWS region. | `string` | `null` | no |
| <a name="input_logs_producer_external_id"></a> [logs\_producer\_external\_id](#input\_logs\_producer\_external\_id) | STS External ID used for the assumption policy when creating the producer role. | `list(string)` | `null` | no |
| <a name="input_metrics_producer_trusted_services"></a> [metrics\_producer\_trusted\_services](#input\_metrics\_producer\_trusted\_services) | Trusted service used for the assumption policy when creating the producer role. Defaults to the streams service for the current AWS region. | `string` | `null` | no |
| <a name="input_metrics_producer_external_id"></a> [metrics\_producer\_external\_id](#input\_metrics\_producer\_external\_id) | STS External ID used for the assumption policy when creating the producer role. | `list(string)` | `null` | no |
| <a name="input_consumer_trusted_services"></a> [consumer\_trusted\_services](#input\_consumer\_trusted\_services) | Trusted service used for the assumption policy when creating the consumer role. Defaults to the firehose service. | `string` | `null` | no |
| <a name="input_consumer_external_id"></a> [consumer\_external\_id](#input\_consumer\_external\_id) | STS External ID used for the assumption policy when creating the consumer role. Defaults to the current AWS account ID. | `string` | `null` | no |
| <a name="input_create_cloudwatch_log_stream"></a> [create\_cloudwatch\_log\_stream](#input\_create\_cloudwatch\_log\_stream) | Flag to indicate if AWS cloudwatch log stream should be created. | `bool` | `false` | no |
| <a name="input_create_cloudwatch_log_subscription_filter"></a> [create\_cloudwatch\_log\_subscription\_filter](#input\_create\_cloudwatch\_log\_subscription\_filter) | Flag to indicate if AWS cloudwatch log subscription filter should be created. | `bool` | `false` | no |
| <a name="input_cloudwatch_metrics_namespaces"></a> [cloudwatch\_metrics\_namespaces](#input\_cloudwatch\_metrics\_namespaces) | A list of metrics namespaces to pull from CloudWatch into Sumo Logic. An empty list (default) exports all metrics. | `list(string)` | `[]` | no |
| <a name="input_s3_failed_logs_bucket_arn"></a> [s3\_failed\_logs\_bucket\_arn](#input\_s3\_failed\_logs\_bucket\_arn) | ARN of the S3 bucket where failed logs would be stored by Kinesis data firehose. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | ARN of the cloudwatch log group. |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of the cloudwatch log group. |
| <a name="output_cloudwatch_log_stream_arn"></a> [cloudwatch\_log\_stream\_arn](#output\_cloudwatch\_log\_stream\_arn) | ARN of the cloudwatch log stream. |
| <a name="output_cloudwatch_log_stream_name"></a> [cloudwatch\_log\_stream\_name](#output\_cloudwatch\_log\_stream\_name) | Name of the cloudwatch log stream. |
| <a name="output_cloudwatch_metric_stream_arn"></a> [cloudwatch\_metric\_stream\_arn](#output\_cloudwatch\_metric\_stream\_arn) | ARN of the metric stream. |
| <a name="output_cloudwatch_metric_stream_name"></a> [cloudwatch\_metric\_stream\_name](#output\_cloudwatch\_metric\_stream\_name) | Name of the metric stream. |
| <a name="output_logs_delivery_stream_arn"></a> [logs\_delivery\_stream\_arn](#output\_logs\_delivery\_stream\_arn) | The ARN of the log delivery stream |
| <a name="output_logs_delivery_stream_name"></a> [logs\_delivery\_stream\_name](#output\_logs\_delivery\_stream\_name) | The name of the log delivery stream |
| <a name="output_logs_delivery_stream_destination_id"></a> [logs\_delivery\_stream\_destination\_id](#output\_logs\_delivery\_stream\_destination\_id) | The id of the log delivery stream |
| <a name="output_metrics_delivery_stream_arn"></a> [metrics\_delivery\_stream\_arn](#output\_metrics\_delivery\_stream\_arn) | The ARN of the metrics delivery stream |
| <a name="output_metrics_delivery_stream_name"></a> [metrics\_delivery\_stream\_name](#output\_metrics\_delivery\_stream\_name) | The name of the metrics delivery stream |
| <a name="output_metrics_delivery_stream_destination_id"></a> [metrics\_delivery\_stream\_destination\_id](#output\_metrics\_delivery\_stream\_destination\_id) | The id of the metrics delivery stream |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
