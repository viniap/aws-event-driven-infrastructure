variable "region" {
  type        = string
  default     = "sa-east-1"
}

variable "sns_topic_name" {
  type        = string
  default     = "PluggyWebhookEventsTopic"
}