output "sns_topic_arn" {
  value = aws_sns_topic.pluggy_webhook_events_topic.arn
}