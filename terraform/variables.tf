variable "region" {
  type        = string
  default     = "sa-east-1"
}

variable "sns_topic_name" {
  type        = string
  default     = "PluggyWebhookEventsTopic"
}

variable "api_name" {
  type        = string
  default     = "PluggyWebhookAPI"
}

variable "sqs_queue_name" {
  type        = string
  default     = "PluggyWebhookEventsQueueTest"
}