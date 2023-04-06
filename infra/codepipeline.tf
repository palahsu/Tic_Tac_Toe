resource "aws_codepipeline" "android_app_pipeline" {
  name = "android-app-pipeline"
  # IAM role used by CodePipeline to perform actions on your behalf
  role_arn = aws_iam_role.codepipeline_role.arn

  # Stages and actions in the pipeline
  stage {
    name = "Source"
    # Source stage: retrieve the source code from the GitHub repository
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      # Configuration parameters for the GitHub source action
      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo_url
        Branch     = "main"
        OAuthToken = var.github_token
      }
    }
  }
  stage {
    name = "build"
    # Build stage: build the Android app using CodeBuild
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["app"]
      version          = "1"

      # Configuration parameters for the CodeBuild build action
      configuration = {
        ProjectName = aws_codebuild_project.build_phase.name
      }
    }
  }
  stage {
    name = "deploy"
    # Deploy stage: deploy the Android app to a device or emulator
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["app"]
      output_artifacts = []
      version          = "1"
      # Configuration parameters for the DeviceFarm deploy action
      configuration = {
        ProjectName = aws_codebuild_project.appcenter_deploy_phase.name
      }
    }
  }

  # Artifacts used in the pipeline
  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.app_bucket.bucket
    encryption_key {
      id   = aws_kms_key.aziz_key.id
      type = "KMS"
    }
  }
}




data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline-aziz-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_aziz_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = file("${path.module}/codepipeline_policy.json")
}
