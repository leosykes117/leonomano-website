################################################################################
# JSON de la trust policy para la ejecucion de los resolvers lambda
################################################################################
data "aws_iam_policy_document" "trust_policy_codepipeline" {
  statement {
    sid     = "GetSecurityCredentials"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

################################################################################
# Politica para manegar las herramientas de CICD (CodePipeline, CodeBuild)
################################################################################
data "aws_iam_policy_document" "cicd_tools" {
  statement {
    sid = "AllowCodeBuildActions"
    actions = [
      "codebuild:BatchGetBuildBatches",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:StartBuildBatch"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:codebuild:${var.aws_region}:${data.aws_caller_identity.current.account_id}:project/${var.project_name}"
    ]
  }
  statement {
    sid = "AllowCodeDeployActions"
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication*",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:codedeploy:${var.aws_region}:${data.aws_caller_identity.current.account_id}:application:${var.project_name}",
      "arn:aws:codedeploy:${var.aws_region}:${data.aws_caller_identity.current.account_id}:deploymentgroup:${var.project_name}/*",
      "arn:aws:codedeploy:${var.aws_region}:${data.aws_caller_identity.current.account_id}:deploymentconfig:${var.project_name}"
    ]
  }

  statement {
    sid = "AllowCodeStarConnectionActions"
    actions = [
      "codestar-connections:UseConnection"
    ]
    resources = [
      aws_codestarconnections_connection.github_source_code.arn
    ]
  }
}

resource "aws_iam_policy" "cicd_tools_management" {
  name        = local.aws_iam_policy_cicd_tools_manager
  path        = "/"
  description = "Politica que permite crear y ejecutar builds de codebuild"
  policy      = data.aws_iam_policy_document.cicd_tools.json
}


################################################################################
# Service Role para la ejecución del pipeline
################################################################################
resource "aws_iam_role" "codepipeline_service_role" {
  name               = local.aws_iam_role_service_role_codepipeline_name
  description        = "Role encargado de la ejecución del pipeline de CICD"
  path               = "/service-role/codepipeline/"
  assume_role_policy = data.aws_iam_policy_document.trust_policy_codepipeline.json
}

resource "aws_iam_role_policy_attachment" "cicd_tools_management_policy" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = aws_iam_policy.cicd_tools_management.arn
}