################################################################################
# JSON de la trust policy para la ejecución de codebuild
################################################################################
data "aws_iam_policy_document" "trust_policy_codebuild" {
  statement {
    sid     = "GetSecurityCredentials"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

################################################################################
# Service Role para la ejecución del build project
################################################################################
resource "aws_iam_role" "codebuild_service_role" {
  name               = local.aws_iam_role_service_role_codebuild_name
  description        = "Role encargado de la ejecución de los proyectos de CodeBuild"
  path               = "/service-role/codebuild/"
  assume_role_policy = data.aws_iam_policy_document.trust_policy_codebuild.json
}

resource "aws_iam_role_policy_attachment" "codebuild_role_s3_artifacts_store_policy" {
  policy_arn = aws_iam_policy.s3_artifacts_store.arn
  role       = aws_iam_role.codebuild_service_role.name
}

resource "aws_iam_role_policy_attachment" "codebuild_role_cloudwatch_logs_policy" {
  policy_arn = aws_iam_policy.cloudwatch_logs.arn
  role       = aws_iam_role.codebuild_service_role.name
}

################################################################################
# Build Project para la web app de Vue
################################################################################
resource "aws_codebuild_project" "build_vue_project" {
  name         = local.aws_codebuild_vue_project_name
  description  = "Compila la aplicación de VueJS"
  service_role = aws_iam_role.codebuild_service_role.arn

  build_timeout = 7

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file(abspath("./buildspecs/vue_buildspec.yml"))
  }

  logs_config {
    cloudwatch_logs {
      group_name = local.aws_codebuild_project_group_log_name
      status     = "ENABLED"
    }
  }
}
