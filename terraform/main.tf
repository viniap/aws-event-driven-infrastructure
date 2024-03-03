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

resource "aws_iam_role" "api_gateway_sns_proxy_role" {
  name = "APIGatewaySNSProxyRoleTest"
  description = "Allows API Gateway to interact with SNS topics."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_publish_topic_policy" {
  role       = aws_iam_role.api_gateway_sns_proxy_role.name
  policy_arn = aws_iam_policy.publish_topic_policy.arn
}