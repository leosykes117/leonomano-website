locals {
  application = "services_website"

  aws_s3_bucket_hosting = "${var.project_name}.${var.env}.com"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "bucket_public_website" {
  statement {
    sid = "PublicReadGetObject"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::${local.aws_s3_bucket_hosting}/*"
    ]
  }
}

module "s3_bucket_hosting" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.10.1"

  bucket        = local.aws_s3_bucket_hosting
  force_destroy = var.delete_bucket_hosting

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  # acl                     = "public-read"
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  #bucket policy
  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_public_website.json

  # Versioning
  /*versioning = {
    status = true
  }*/

  # website config
  website = {
    index_document = "index.html"
  }
}