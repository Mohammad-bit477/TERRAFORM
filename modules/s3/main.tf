resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_s3_bucket" "bucket" {
  bucket = lower("${var.project}-${random_string.suffix.result}")

  tags = {
    Name = "${var.project}-bucket"
  }
}

# VPC Endpoint for S3 (Gateway type)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids
}

# Bucket policy to allow access only via VPC endpoint
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          "${aws_s3_bucket.bucket.arn}",
          "${aws_s3_bucket.bucket.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:sourceVpce" = aws_vpc_endpoint.s3.id
          }
        }
      }
    ]
  })
}