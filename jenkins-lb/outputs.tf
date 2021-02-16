output "lb" {
  value = {
    dns_name = aws_lb.lb_jenkins.dns_name
    tg_arn   = aws_lb_target_group.tg_jenkins.arn
  }
}

output "sg" {
  value = {
    id = aws_security_group.sg_lb_jenkins.id
  }
}