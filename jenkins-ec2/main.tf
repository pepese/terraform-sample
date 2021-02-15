#####################################
# EC2 Settings
#####################################

resource "aws_instance" "ec2-jenkins" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = data.terraform_remote_state.vpc.outputs.vpc.subnet_protected_1a_id

  vpc_security_group_ids = [
    aws_security_group.default.id,
  ]

  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.default-profile.name

  credit_specification {
    cpu_credits = "unlimited"
  }

  root_block_device {
    volume_size = "20"
  }

  tags = merge(local.base_tags, map("Name", "${local.base_name}-ec2-jenkins"))
}

#####################################
# Security Group Settings
#####################################

resource "aws_security_group" "default" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc.vpc_id
  tags = merge(local.base_tags, map("Name", "${local.base_name}-sg-ec2-jenkins"))
}

resource "aws_security_group_rule" "egress-rule" {
  security_group_id = aws_security_group.default.id

  type      = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "self-ingress-rule" {
  security_group_id = aws_security_group.default.id

  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  self      = true
}

resource "aws_security_group_rule" "http-ingress-rule" {
  security_group_id = aws_security_group.default.id

  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = data.terraform_remote_state.lb.outputs.lb.id
}

#####################################
# Data: IAM Policy Document
#####################################

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

#####################################
# IAM Settings
#####################################

resource "aws_iam_role" "default-role" {
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2-role.json
  tags = merge(local.base_tags, map("Name", "${local.base_name}-role-jenkins"))
}

resource "aws_iam_role_policy" "defaut-policy" {
  role   = aws_iam_role.default-role.id
  policy = data.aws_iam_policy_document.ec2-role-policy.json
}

resource "aws_iam_instance_profile" "default-profile" {
  role = aws_iam_role.default-role.name
}