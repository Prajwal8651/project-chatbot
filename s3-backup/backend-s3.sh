#!/bin/bash
set -e

BUCKET_NAME="terraform-state-$(date +%s)"
REGION="us-west-2"

echo "Creating S3 bucket in $REGION..."
echo "Bucket: $BUCKET_NAME"

aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region "$REGION" \
  --create-bucket-configuration LocationConstraint="$REGION"

aws s3api put-public-access-block \
  --bucket "$BUCKET_NAME" \
  --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket "$BUCKET_NAME" \
  --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'

echo "======================================"
echo "S3 Backend Setup Complete!"
echo "======================================"
echo "Bucket Name: $BUCKET_NAME"
echo "Region: $REGION"
echo "Versioning: Enabled"
echo "Encryption: Enabled (AES256)"
echo "State Locking: S3 Native (.tflock)"
echo ""

cat <<EOF
terraform {
  backend "s3" {
    bucket       = "$BUCKET_NAME"
    key          = "pre-prod/terraform.tfstate"
    region       = "$REGION"
    use_lockfile = true
    encrypt      = true
  }
}
EOF
