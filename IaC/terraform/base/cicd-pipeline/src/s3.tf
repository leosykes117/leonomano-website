resource "aws_s3_bucket" "pipeline_artifact_store" {
  bucket        = local.aws_s3_bucket_pipeline_artifact_store_name
  force_destroy = var.delete_bucket_artifact

  tags = {
    Name        = local.aws_s3_bucket_pipeline_artifact_store_name
    Description = "Bucket para alojar los artefactos generados por el pipeline del proyecto ${var.project_name}"
  }
}

# Enable private bucket
resource "aws_s3_bucket_acl" "pipeline_artifac_store" {
  bucket = aws_s3_bucket.pipeline_artifact_store.id
  acl    = "private"
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.pipeline_artifact_store.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning of objects in the bucket if enviroment is not development
resource "aws_s3_bucket_versioning" "lambda_resolvers" {
  bucket = aws_s3_bucket.pipeline_artifact_store.id
  versioning_configuration {
    status = "Enabled"
  }
}


# Enable server side encryption on S3 with a KMS key AWS
resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_resolvers" {
  bucket = aws_s3_bucket.pipeline_artifact_store.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}