resource "aws_s3_bucket" "pipeline_artifact_store" {
  bucket        = local.aws_s3_bucket_pipeline_artifact_store_name
  force_destroy = var.delete_bucket_artifact

  tags = {
    Name        = local.aws_s3_bucket_pipeline_artifact_store_name
    Description = "Bucket para alojar los artefactos generados por el pipeline del proyecto ${var.project_name}"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "pipeline_artifact_store" {
  bucket = aws_s3_bucket.pipeline_artifact_store.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "pipeline_artifact_store" {
  bucket = aws_s3_bucket.pipeline_artifact_store.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Enable private bucket
resource "aws_s3_bucket_acl" "pipeline_artifact_store" {
  bucket = aws_s3_bucket.pipeline_artifact_store.id
  acl    = "private"

  depends_on = [
    aws_s3_bucket_public_access_block.pipeline_artifact_store,
    aws_s3_bucket_ownership_controls.pipeline_artifact_store
  ]
}


# Enable versioning of objects in the bucket if enviroment is not development
resource "aws_s3_bucket_versioning" "pipeline_artifact_store" {
  bucket = aws_s3_bucket.pipeline_artifact_store.id
  versioning_configuration {
    status = "Enabled"
  }
}


# Enable server side encryption on S3 with a KMS key AWS
resource "aws_s3_bucket_server_side_encryption_configuration" "pipeline_artifact_stores" {
  bucket = aws_s3_bucket.pipeline_artifact_store.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
