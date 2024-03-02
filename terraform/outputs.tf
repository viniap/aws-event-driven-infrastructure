output "sns_topic_arn" {
  value = aws_sns_topic.topic.arn
}

output "publish_topic_policy_arn" {
  value = aws_iam_policy.publish_topic_policy.arn
}