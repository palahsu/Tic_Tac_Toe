resource "aws_s3_bucket" "app_bucket" {
  bucket = "aziz-android-apk-bucket"
}

resource "null_resource" "create_keystore" {
  depends_on = [aws_s3_bucket.app_bucket]
  provisioner "local-exec" {
    command = "keytool -genkey -noprompt -alias 'key'  -dname 'CN=mqttserver.ibm.com, OU=ID, O=IBM, L=Hursley, S=Hants, C=GB'  -keystore key.keystore  -keyalg RSA  -keysize 2048  -validity 10000  -storepass ${aws_secretsmanager_secret_version.release_store_password.secret_string}  -keypass ${aws_secretsmanager_secret_version.release_key_password.secret_string}"
    # command = "keytool -genkey -noprompt -alias 'alias1' - dname 'CN=mqttserver.ibm.com, OU=ID, O=IBM, L=Hursley, S=Hants, C=GB' -keystore key.keystore -keyalg RSA -keysize 2048 -validity 10000 -storepass '${local.release_store_password}' -keypass  '${local.release_key_password}' "
  }
}

resource "aws_s3_bucket_acl" "app_bucket_acl" {
  bucket = aws_s3_bucket.app_bucket.id
  acl    = "private"
}

resource "aws_kms_key" "aziz_key" {
  description             = "Example KMS key"
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-policy"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow administration of the key"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.codebuild_role.arn
        }
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow use of the key"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_s3_object" "keystore" {
  
  depends_on = [null_resource.create_keystore]
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "keystore/key.keystore"
  source = "./key.keystore"

}