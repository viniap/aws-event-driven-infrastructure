output "sns_topic_arn" {
  value = aws_sns_topic.topic.arn
}

output "publish_topic_policy_arn" {
  value = aws_iam_policy.publish_topic_policy.arn
}

output "api_invoke_url" {
  value = aws_api_gateway_deployment.pluggy_webhook_deployment.invoke_url
}

output "api_key" {
  value = aws_api_gateway_api_key.api_key.value
  sensitive = true
}