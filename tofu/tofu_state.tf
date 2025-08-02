# Naturally this had to be applied before creating backend.tf,
# and if I ever want to delete it that will need to be deleted first
resource "aws_s3_bucket" "tofu_state" {
  bucket = "d13r-tofu-state"
}

resource "aws_s3_bucket_versioning" "tofu_state" {
  bucket = aws_s3_bucket.tofu_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "tofu_state" {
  bucket = aws_s3_bucket.tofu_state.id

  rule {
    id     = "ExpireOldVersions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}
