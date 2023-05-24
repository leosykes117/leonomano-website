resource "aws_cloudfront_origin_access_identity" "website" {
  comment = module.s3_bucket_hosting.s3_bucket_website_endpoint
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  comment             = "Distrubución con S3 para el website ${local.domain_name}"
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  aliases = [
    local.domain_name,
  ]

  origin {
    domain_name = module.s3_bucket_hosting.s3_bucket_bucket_regional_domain_name
    origin_id   = module.s3_bucket_hosting.s3_bucket_website_endpoint

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = module.s3_bucket_hosting.s3_bucket_website_endpoint
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["HEAD", "GET"]
    cached_methods         = ["HEAD", "GET"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.ssl.arn
    ssl_support_method             = "sni-only"
  }


  depends_on = [
    module.s3_bucket_hosting,
    aws_acm_certificate_validation.ssl
  ]
}