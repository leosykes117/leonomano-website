data "aws_caller_identity" "current" {}

locals {
  application = "base_cicd-pipeline"

  aws_codepipeline_pipeline_name              = "${var.project_name}-${var.env}-pipeline"
  aws_iam_policy_cicd_tools_manager           = "${var.project_name}-${var.env}-cicd-tools-management"
  aws_iam_policy_s3_artifacts_store_name      = "${var.project_name}-${var.env}-artifacts-store-management"
  aws_iam_policy_s3_website_hosting_name      = "${var.project_name}-${var.env}-website-hosting-management"
  aws_iam_policy_cloudwatch_logs_name         = "${var.project_name}-${var.env}-cloudwatch-send-logs"
  aws_iam_role_service_role_codepipeline_name = "${var.project_name}-${var.env}-codepipeline-service-role"
  aws_iam_role_service_role_codebuild_name    = "${var.project_name}-${var.env}-codebuild-service-role"
  aws_s3_bucket_pipeline_artifact_store_name  = "${var.project_name}-${var.env}-pipeline-artifact-store"
  aws_codestar_connection_github_name         = "${var.project_name}-github"
  aws_codebuild_vue_project_name              = "${var.project_name}-${var.env}-build-vue-project"
  aws_codebuild_project_group_log_name        = "${var.project_name}-${var.env}-build-vue-project"
  aws_s3_bucket_website_hosting_name          = "${var.project_name}.${var.env}.com"
}

resource "aws_codestarconnections_connection" "github_source_code" {
  name          = local.aws_codestar_connection_github_name
  provider_type = "GitHub"
}

resource "aws_codepipeline" "this" {
  name     = local.aws_codepipeline_pipeline_name
  role_arn = aws_iam_role.codepipeline_service_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifact_store.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github_source_code.arn
        FullRepositoryId = "leosykes117/leonomano-website"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.build_vue_project.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      version         = "1"
      input_artifacts = ["build_output"]
      configuration = {
        BucketName = local.aws_s3_bucket_website_hosting_name
        Extract    = "true"
      }
    }
  }
}
