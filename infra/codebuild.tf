# CodeBuild project for building the Android app and storing the APK in S3
resource "aws_codebuild_project" "build_phase" {
  name         = "${var.APP_NAME}-build_phase"
  description  = "CodeBuild project for building the Android signed app and storing the APK in S3"
  service_role = aws_iam_role.codebuild_role.arn

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "S3_BUCKET"
      value = aws_s3_bucket.app_bucket.bucket
    }

    environment_variable {
      name  = "RELEASE_STORE_FILE"
      value = "../key.keystore  "
    }
    environment_variable {
      name  = "RELEASE_KEY_ALIAS"
      value = "key"
    }
    environment_variable {
      name  = "RELEASE_KEY_PASSWORD"
      value = aws_secretsmanager_secret_version.release_key_password.secret_string
    }

    environment_variable {
      name  = "RELEASE_STORE_PASSWORD"
      value = aws_secretsmanager_secret_version.release_store_password.secret_string
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
  artifacts {
    type = "CODEPIPELINE"
  }
}

# CodeBuild project for doing other things with the APK
resource "aws_codebuild_project" "appcenter_deploy_phase" {
  name         = "${var.APP_NAME}-deploy_phase"
  description  = "CodeBuild project for deploying the app on appcenter"
  service_role = aws_iam_role.codebuild_role.arn

  # Environment variables used by the CodeBuild project
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:6.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "APPCENTER_TOKEN"
      value = var.APP_CENTER_TOKEN
    }
    environment_variable {
      name  = "APP_ID"
      value = var.APP_ID
    }
    environment_variable {
      name  = "APPCENTER_GROUP"
      value = var.APPCENTER_GROUP
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "deploy.yml"
  }

  depends_on = [
    aws_codebuild_project.build_phase
  ]
  artifacts {
    type = "CODEPIPELINE"
  }
}

resource "aws_iam_role" "codebuild_role" {
  name = "${var.APP_NAME}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "codebuild_policy" {
  name = "${var.APP_NAME}-codebuild_policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.build_phase.name}",
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.build_phase.name}:*",
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.appcenter_deploy_phase.name}",
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.appcenter_deploy_phase.name}:*",
        ],
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        "Sid" : "SecretsManagerAccess",
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${aws_secretsmanager_secret_version.release_key_password.secret_string}",
          "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${aws_secretsmanager_secret_version.release_store_password.secret_string}"
        ]
        "Action" : [
          "secretsmanager:GetSecretValue"
        ],
      },
      {
        "Effect" : "Allow",
        "Resource" : [
          "${aws_s3_bucket.app_bucket.arn}*",
          "${aws_s3_bucket.app_bucket.arn}/*"
        ],
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
      },
      {
        "Effect" : "Allow",
        "Resource" : [

          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:report-group:/aws/codebuild/${aws_codebuild_project.build_phase.name}-*",
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:report-group:/aws/codebuild/${aws_codebuild_project.appcenter_deploy_phase.name}-*",
        ]
        "Action" : [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  policy_arn = aws_iam_policy.codebuild_policy.arn
  role       = aws_iam_role.codebuild_role.name
}

