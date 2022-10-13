#create s3 bucket
resource "aws_s3_bucket" "dileep-webapp-s3-demo" {
  bucket = "dileep-webapp-demo"
}

#enable versioning
resource "aws_s3_bucket_versioning" "dileep-webapp-s3-versioning" {
  bucket = aws_s3_bucket.dileep-webapp-s3-demo.id
  versioning_configuration {
    status = "Enabled"
  }
}