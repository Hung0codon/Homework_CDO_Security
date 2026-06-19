terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Random generator for S3 Bucket suffix
resource "random_id" "bucket_suffix" {
  byte_length = 6
}

# 2. S3 Bucket to upload sample files
resource "aws_s3_bucket" "macie_target" {
  bucket        = "${var.bucket_prefix}-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "macie_target" {
  bucket = aws_s3_bucket.macie_target.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "macie_target" {
  bucket = aws_s3_bucket.macie_target.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 3. Upload the sensitive sample data file to S3
resource "aws_s3_object" "sensitive_data" {
  bucket = aws_s3_bucket.macie_target.id
  key    = "sensitive_data.csv"
  source = "${path.module}/sample_files/sensitive_data.csv"
  etag   = filemd5("${path.module}/sample_files/sensitive_data.csv")

  depends_on = [
    aws_s3_bucket_public_access_block.macie_target,
    aws_s3_bucket_server_side_encryption_configuration.macie_target
  ]
}

# 4. Enable Amazon Macie Account
resource "aws_macie2_account" "this" {
  status                       = "ENABLED"
  finding_publishing_frequency = "FIFTEEN_MINUTES"
}

# 5. Create Amazon Macie Classification Job
data "aws_caller_identity" "current" {}

resource "random_id" "job_suffix" {
  byte_length = 4
}

resource "aws_macie2_classification_job" "sensitive_data_job" {
  job_type = "ONE_TIME"
  name     = "cdo-macie-job-${random_id.job_suffix.hex}"

  s3_job_definition {
    bucket_definitions {
      account_id = data.aws_caller_identity.current.account_id
      buckets    = [aws_s3_bucket.macie_target.id]
    }
  }

  depends_on = [
    aws_macie2_account.this,
    aws_s3_object.sensitive_data
  ]
}

# 6. Create SNS Topic for email notifications
resource "aws_sns_topic" "macie_alerts" {
  name = "cdo-macie-alerts-topic-${random_id.bucket_suffix.hex}"
}

# 7. Create SNS Subscription for User's Email
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.macie_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# 8. Create EventBridge (CloudWatch Events) Rule to detect Macie Findings
resource "aws_cloudwatch_event_rule" "macie_finding_rule" {
  name        = "cdo-macie-findings-rule-${random_id.bucket_suffix.hex}"
  description = "Trigger SNS topic when Macie generates a finding"

  event_pattern = jsonencode({
    source      = ["aws.macie"]
    detail-type = ["Macie Finding"]
  })
}

# 9. Set EventBridge Target to SNS Topic
resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.macie_finding_rule.name
  target_id = "SendToSNSTopic"
  arn       = aws_sns_topic.macie_alerts.arn
}

# 10. SNS Topic Policy to allow EventBridge (Events) service to publish events
data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.macie_alerts.arn
    ]
  }
}

resource "aws_sns_topic_policy" "sns_policy" {
  arn    = aws_sns_topic.macie_alerts.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}
