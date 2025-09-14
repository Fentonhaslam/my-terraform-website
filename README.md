🚀 Build a Static Website with Terraform, S3, and CloudFront

This guide walks you through creating a simple website hosted on AWS S3 with CloudFront as a CDN — using Terraform.

By the end, you’ll:

Have a working static website hosted on AWS

Understand how Terraform provisions AWS resources

Deploy your own HTML files to S3

1. Prerequisites

An AWS account

AWS CLI installed & configured (aws configure)

Terraform
 installed

2. Project Setup

Create a new directory for your project:

mkdir my-terraform-website && cd my-terraform-website


Initialize a new Terraform project:

terraform init


You’ll create three Terraform files:

main.tf → defines resources

variables.tf → stores configurable inputs

outputs.tf → shows important info after deployment

(Don’t worry, details are below — you’ll write them step by step!)

3. Define the Provider

In main.tf, start with:

provider "aws" {
  region = var.aws_region
}

4. Create an S3 Bucket

Add to main.tf:

A bucket resource

A bucket policy for public read

Website hosting configuration (index.html, error.html)

5. Add CloudFront

Still in main.tf, define:

A aws_cloudfront_distribution resource

Point it to the S3 bucket as the origin

Set default cache behavior

6. Variables

In variables.tf, add:

variable "aws_region" {
  default = "us-east-1"
}

variable "bucket_name" {
  description = "Unique bucket name"
}

7. Outputs

In outputs.tf, add:

output "cloudfront_url" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

8. Deploy 🚀

Run:

terraform init
terraform apply -var="bucket_name=my-unique-bucket-name"

9. Upload Your Website

Create a folder site/ with index.html and error.html.

Upload:

aws s3 cp ./site/ s3://my-unique-bucket-name/ --recursive

10. Visit Your Website 🎉

Check the output URL:

terraform output cloudfront_url