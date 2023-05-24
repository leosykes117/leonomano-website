resource "godaddy_domain_record" "leonomano_com" {
  domain = var.domain_name

  nameservers = [
    "ns71.domaincontrol.com",
    "ns72.domaincontrol.com"
  ]

  record {
    type = "A"
    name = "@"
    data = "34.102.136.180"
    ttl  = 600
  }

  record {
    type = "CNAME"
    name = "www"
    data = "@"
    ttl  = 3600
  }

  record {
    type = "CNAME"
    name = "_domainconnect"
    data = "_domainconnect.gd.domaincontrol.com"
    ttl  = 3600
  }

  dynamic "record" {
    for_each = aws_acm_certificate.ssl.domain_validation_options

    content {
      type = record.value["resource_record_type"]
      name = join(".", slice(split(".", record.value["resource_record_name"]), 0, 2))
      data = trimsuffix(record.value["resource_record_value"], ".")
      ttl  = 3600
    }
  }

  record {
    type = "CNAME"
    data = aws_cloudfront_distribution.website.domain_name
    name = var.env == "prod" ? "" : var.env
    ttl  = 3600
  }
}
