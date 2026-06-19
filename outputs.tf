output "s3_bucket_name" {
  value       = aws_s3_bucket.macie_target.id
  description = "The name of the S3 bucket scanned by Macie"
}

output "macie_job_id" {
  value       = aws_macie2_classification_job.sensitive_data_job.id
  description = "The ID of the Amazon Macie classification job"
}

output "sns_topic_arn" {
  value       = aws_sns_topic.macie_alerts.arn
  description = "The ARN of the SNS Topic for alerts"
}

output "sns_topic_name" {
  value       = aws_sns_topic.macie_alerts.name
  description = "The Name of the SNS Topic for alerts"
}

output "alert_email" {
  value       = var.alert_email
  description = "The configured email address for alerts"
}
