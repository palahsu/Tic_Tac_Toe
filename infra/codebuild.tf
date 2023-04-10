# CodeBuild project for building the Android app and storing the APK in S3
resource "aws_codebuild_project" "build_phase" {
  name         = "build_phase"
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
      name  = "RELEASE_KEY_PASSWORD"
      value = local.release_key_password
    }

    environment_variable {
      name  = "RELEASE_STORE_PASSWORD"
      value = local.release_store_password
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
  name         = "deploy_phase"
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
