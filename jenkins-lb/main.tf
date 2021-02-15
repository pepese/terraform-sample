#####################################
# Jenkins LB
#####################################

resource "aws_lb" "lb-jenkins" {
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.sg-lb-jenkins.id
  ]

  subnets = [
    data.terraform_remote_state.vpc.outputs.vpc.subnet_public_1a_id,
    data.terraform_remote_state.vpc.outputs.vpc.subnet_public_1c_id,
    data.terraform_remote_state.vpc.outputs.vpc.subnet_public_1d_id
  ]

  tags   = merge(local.base_tags, map("Name", "${local.base_name}-lb-jenkins"))
}

resource "aws_lb_target_group" "tg-lb-jenkins" {
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc.vpc_id

  tags   = merge(local.base_tags, map("Name", "${local.base_name}-tg-lb-jenkins"))
}

resource "aws_lb_listener" "listener-lb-jenkins" {
  load_balancer_arn = aws_lb.lb-jenkins.arn
  port              = "80"
  protocol          = "HTTP"
  # port              = "443"
  # protocol          = "HTTPS"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-lb-jenkins.arn
  }
}

#####################################
# Security Group Settings
#####################################

resource "aws_security_group" "sg-lb-jenkins" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc.vpc_id
  tags   = merge(local.base_tags, map("Name", "${local.base_name}-sg-lb-jenkins"))
}

resource "aws_security_group_rule" "egress-rule" {
  security_group_id = aws_security_group.sg-lb-jenkins.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress-rule" {
  security_group_id = aws_security_group.sg-lb-jenkins.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  self        = false
}