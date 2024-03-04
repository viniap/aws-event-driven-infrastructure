resource "aws_sns_topic" "topic" {
  name = var.sns_topic_name
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
        Resource = aws_sns_topic.topic.arn
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

resource "aws_api_gateway_rest_api" "pluggy_webhook_rest_api" {
  name = var.api_name
  description = "API to receive the events from the Pluggy Webhook."

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "pluggy_webhook_resource" {
  parent_id   = aws_api_gateway_rest_api.pluggy_webhook_rest_api.root_resource_id
  path_part   = "pluggywebhook"
  rest_api_id = aws_api_gateway_rest_api.pluggy_webhook_rest_api.id
}

resource "aws_api_gateway_method" "pluggy_webhook_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.pluggy_webhook_resource.id
  rest_api_id   = aws_api_gateway_rest_api.pluggy_webhook_rest_api.id
  api_key_required = true
  operation_name = "PostEvents"
}

resource "aws_api_gateway_integration" "api_gateway_sns_integration" {
  http_method = aws_api_gateway_method.pluggy_webhook_method.http_method
  resource_id = aws_api_gateway_resource.pluggy_webhook_resource.id
  rest_api_id = aws_api_gateway_rest_api.pluggy_webhook_rest_api.id
  integration_http_method = "POST"
  type        = "AWS"
  uri = "arn:aws:apigateway:${var.region}:sns:path//"
  credentials = aws_iam_role.api_gateway_sns_proxy_role.arn
  passthrough_behavior = "WHEN_NO_TEMPLATES"

  request_parameters = { 
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=Publish&TopicArn=$util.urlEncode('${aws_sns_topic.topic.arn}')&Message=$util.urlEncode($input.body)"
  }
}

resource "aws_api_gateway_method_response" "method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.pluggy_webhook_rest_api.id
  resource_id = aws_api_gateway_resource.pluggy_webhook_resource.id
  http_method = aws_api_gateway_method.pluggy_webhook_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.pluggy_webhook_rest_api.id
  resource_id = aws_api_gateway_resource.pluggy_webhook_resource.id
  http_method = aws_api_gateway_method.pluggy_webhook_method.http_method
  status_code = aws_api_gateway_method_response.method_response_200.status_code

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.api_gateway_sns_integration
  ]
}

resource "aws_api_gateway_deployment" "pluggy_webhook_deployment" {
  rest_api_id = aws_api_gateway_rest_api.pluggy_webhook_rest_api.id
  description = "First deployment."

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.pluggy_webhook_resource.id,
      aws_api_gateway_method.pluggy_webhook_method.id,
      aws_api_gateway_integration.api_gateway_sns_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.pluggy_webhook_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.pluggy_webhook_rest_api.id
  stage_name    = "dev"
  description = "Development Stage."
}

resource "aws_api_gateway_api_key" "api_key" {
  name = "APIKey"
  description = "API Key for ${var.api_name}."
}

resource "aws_api_gateway_usage_plan" "api_usage_plan" {
  name = "UsagePlan"
  description = "Usage plan for ${var.api_name}."

  api_stages {
    api_id = aws_api_gateway_rest_api.pluggy_webhook_rest_api.id
    stage  = aws_api_gateway_stage.api_stage.stage_name
  }

  quota_settings {
    limit  = 1000000
    period = "MONTH"
  }

  throttle_settings {
    burst_limit = 500
    rate_limit  = 1000
  }
}

resource "aws_api_gateway_usage_plan_key" "api_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.api_usage_plan.id
}

resource "aws_sqs_queue" "queue" {
  name                    = var.sqs_queue_name
  sqs_managed_sse_enabled = true
}

resource "aws_sns_topic_subscription" "topic_subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.queue.arn
  filter_policy_scope = "MessageBody"

  filter_policy = jsonencode(
    {
      event = [
        "item/created",
        "item/updated",
        "item/deleted",
        "transactions/deleted",
      ]
    }
  )
}

data "aws_caller_identity" "current" {}

resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = aws_sqs_queue.queue.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "__owner_statement"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.arn
        }
        Action = "SQS:*"
        Resource = aws_sqs_queue.queue.arn
      },
      {
        Sid       = aws_sns_topic_subscription.topic_subscription.id
        Effect    = "Allow"
        Principal = {
          AWS = "*"
        }
        Action    = "SQS:SendMessage"
        Resource  = aws_sqs_queue.queue.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = aws_sns_topic.topic.arn
          }
        }
      },
    ]
  })
}