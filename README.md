# 🚀 Build a Static Website with Terraform, S3, and CloudFront

This guide walks you through creating a simple website hosted on **AWS S3** with **CloudFront** as a CDN — using **Terraform**.

By the end, you’ll be able to:
- ✅ Host a working static website on AWS  
- ✅ Understand how Terraform provisions AWS resources  
- ✅ Deploy your own HTML files to S3  

---

## 1. Prerequisites

Make sure you have the following installed and configured:
- An **AWS account**
- **AWS CLI** (`aws configure`)
- **Terraform**

---

## 2. Project Setup

1. Create a new directory for your project:

   mkdir my-terraform-website && cd my-terraform-website

2. Initialize a new Terraform project:

   terraform init

3. You’ll create three Terraform files:
   - main.tf → defines resources  
   - variables.tf → stores configurable inputs  
   - outputs.tf → shows important info after deployment  

*(Don’t worry, the details are below — you’ll write them step by step!)*

---

## 3. Define the Provider

In `main.tf`, start with:

    provider "aws" {
      region = var.aws_region
    }

---

## 4. Create an S3 Bucket

In `main.tf`, add:
- An S3 bucket resource  
- A bucket policy for public read  
- Website hosting configuration (`index.html`, `error.html`)  

---

## 5. Add CloudFront

Still in `main.tf`, define:
- An aws_cloudfront_distribution resource  
- Point it to the S3 bucket as the origin  
- Set a default cache behavior  

---

## 6. Variables

In `variables.tf`, add:

    variable "aws_region" {
      default = "us-east-1"
    }

    variable "bucket_name" {
      description = "Unique bucket name"
    }

---

## 7. Outputs

In `outputs.tf`, add:

    output "cloudfront_url" {
      value = aws_cloudfront_distribution.cdn.domain_name
    }

---

## 8. Deploy 🚀

Run the following:

    terraform init
    terraform apply -var="bucket_name=my-unique-bucket-name"

---

## 9. Upload Your Website

1. Create a folder called `site/` with at least:  
   - index.html  
   - error.html  

2. Upload your site files to S3:

    aws s3 cp ./site/ s3://my-unique-bucket-name/ --recursive

---

## 10. Visit Your Website 🎉

Check the CloudFront URL:

    terraform output cloudfront_url

Open it in your browser and see your site live! 🚀  

---
