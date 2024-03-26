<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.39.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.39.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_api_key.api_key](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/api_gateway_api_key) | resource |
| [aws_api_gateway_deployment.pluggy_webhook_deployment](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.api_gateway_sns_integration](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration_response.integration_response_200](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/api_gateway_integration_response) | resource |
| [aws_api_gateway_method.pluggy_webhook_method](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_response.method_response_200](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/api_gateway_method_response) | resource |
| [aws_api_gateway_resource.pluggy_webhook_resource](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.pluggy_webhook_rest_api](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.api_stage](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/api_gateway_stage) | resource |
| [aws_api_gateway_usage_plan.api_usage_plan](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/api_gateway_usage_plan) | resource |
| [aws_api_gateway_usage_plan_key.api_usage_plan_key](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/api_gateway_usage_plan_key) | resource |
| [aws_iam_policy.publish_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.api_gateway_sns_proxy_role](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach_publish_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_sns_topic.topic](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.topic_subscription](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.queue_policy](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.39.0/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | n/a | `string` | `"PluggyWebhookAPI"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"sa-east-1"` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | n/a | `string` | `"PluggyWebhookEventsTopic"` | no |
| <a name="input_sqs_queue_name"></a> [sqs\_queue\_name](#input\_sqs\_queue\_name) | n/a | `string` | `"PluggyWebhookEventsQueueTest"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_invoke_url"></a> [api\_invoke\_url](#output\_api\_invoke\_url) | n/a |
| <a name="output_api_key"></a> [api\_key](#output\_api\_key) | n/a |
| <a name="output_publish_topic_policy_arn"></a> [publish\_topic\_policy\_arn](#output\_publish\_topic\_policy\_arn) | n/a |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | n/a |
<!-- END_TF_DOCS -->  