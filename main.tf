resource "random_string" "random" {
  length = 6
  special = false
  upper = false
} 

##### Creating an S3 Bucket #####
resource "aws_s3_bucket" "project2_bucket" {
  bucket = "project2-${random_string.random.result}"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "project2_bucket_configuration" {
  bucket = aws_s3_bucket.project2_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "project2_bucket_ownership" {
  bucket = aws_s3_bucket.project2_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "project2_public_access_block" {
  bucket = aws_s3_bucket.project2_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "name" {
  bucket = aws_s3_bucket.project2_bucket.id
  acl = "public-read"

  depends_on = [ aws_s3_bucket_public_access_block.project2_public_access_block, aws_s3_bucket_ownership_controls.project2_bucket_ownership ]
}

resource "aws_s3_bucket_policy" "project2_bucket_policy" {
  bucket = aws_s3_bucket.project2_bucket.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.project2_bucket.id}/*"
      }
    ]
  })
}


resource "aws_s3_object" "project2_upload_object" {
  for_each      = fileset("html/", "*") //path to your build folder
  bucket        = aws_s3_bucket.project2_bucket.id
  key           = each.value
  source        = "html/${each.value}" //path to your index/error.html files
  etag          = filemd5("html/${each.value}")
  content_type  = "text/html"
}

