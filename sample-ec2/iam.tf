# ---------------------------------
# Data: IAM Policy Document
# ---------------------------------

data "aws_iam_policy_document" "ec2-role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "ec2-role-policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:*",
      "ssm:*",
      "ssmmessages:*",
    ]

    resources = [
      "*",
    ]
  }
}

# ---------------------------------
# IAM
# ---------------------------------

resource "aws_iam_role" "default-role" {
  name               = "${local.name}-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2-role.json
}

resource "aws_iam_role_policy" "defaut-policy" {
  name   = "${local.name}-role-policy"
  role   = aws_iam_role.default-role.id
  policy = data.aws_iam_policy_document.ec2-role-policy.json
}

resource "aws_iam_instance_profile" "default-profile" {
  name = "${local.name}-profile"
  role = aws_iam_role.default-role.name
}