resource "aws_codepipeline" "android_app_pipeline" {
  name     = "${var.APP_NAME}-android-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  stage {
    name = "${var.APP_NAME}-Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]
      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo_url
        Branch     = "main"
        OAuthToken = var.github_token
      }
    }
  }
  stage {
    name = "${var.APP_NAME}-build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["app"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_phase.name
      }
    }
  }
  stage {
    name = "${var.APP_NAME}-deploy"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["app"]
      output_artifacts = []
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.appcenter_deploy_phase.name
      }
    }
  }
  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.app_bucket.bucket
    encryption_key {
      id   = aws_kms_key.kms_key.id
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
  name               = "${var.APP_NAME}-codepipelines-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "${var.APP_NAME}-codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = file("${path.module}/codepipeline_policy.json")
}
