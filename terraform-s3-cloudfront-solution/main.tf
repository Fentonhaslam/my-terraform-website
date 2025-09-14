provider "aws" {
  region = var.aws_region
}

# S3 bucket
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
}

# S3 website configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Ownership controls
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Public access block (allow policies, but still block ACLs)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = true
  block_public_policy     = false   # <-- allow policy
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Bucket policy for public read
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "s3-website"
  }

  default_cache_behavior {
    target_origin_id       = "s3-website"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    # ✅ modern way: use AWS managed cache policy
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
