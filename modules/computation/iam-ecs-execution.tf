data "aws_iam_policy_document" "ecs_execution_role_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    effect = "Allow"

    principals {
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com",
        "batch.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name = local.ecs_execution_role_name
  # Read more about ECS' `task_role` and `execution_role` here https://stackoverflow.com/a/49947471
  description        = "This role is passed to our AWS ECS' task definition as the `execution_role`. This allows things like the correct image to be pulled and logs to be stored."
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_role_assume_role.json

  tags = var.standard_tags
}


data "aws_iam_policy_document" "db_secrets" {
  statement {
    sid = "AllowDBSecretAccess"

    effect = "Allow"

    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]

    resources = [
      var.database_password_secret_manager_arn
    ]
  }

  statement {
    sid = "AllowSecretsManagerList"

    effect = "Allow"

    actions = [
      "secretsmanager:ListSecrets",
    ]

    resources = [
      "*"
    ]
  }
}


data "aws_iam_policy_document" "ecs_task_execution_policy" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    # The `"Resource": "*"` is not a concern and the policy that Amazon suggests using
    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "grant_ecs_access" {
  name   = "ecs_access"
  role   = aws_iam_role.ecs_execution_role.name
  policy = data.aws_iam_policy_document.ecs_task_execution_policy.json
}

resource "aws_iam_role_policy" "grant_db_secrets" {
  name   = "dbt_secrets"
  role   = aws_iam_role.ecs_execution_role.name
  policy = data.aws_iam_policy_document.db_secrets.json
}
