output "jenkins" {
  value = {
    ec2_id = aws_instance.ec2-jenkins.id
    sg_id = aws_security_group.default.id
  }
}