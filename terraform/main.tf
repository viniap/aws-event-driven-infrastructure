resource "aws_sns_topic" "topic" {
  name = "${var.sns_topic_name}"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_iam_policy" "publish_topic_policy" {
  name        = "AmazonSNSPublish${var.sns_topic_name}Policy"
  description = "Allows to publish to the ${var.sns_topic_name} SNS topic."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish*",
        ]
        Effect   = "Allow"
        Resource = "${aws_sns_topic.topic.arn}"
      },
    ]
  })
}