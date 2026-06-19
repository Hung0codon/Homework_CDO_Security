variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "alert_email" {
  type        = string
  description = "The email address to receive Macie alerts"
}

variable "bucket_prefix" {
  type        = string
  description = "Prefix for the S3 bucket scanned by Macie"
  default     = "cdo-macie-sensitive-data"
}
