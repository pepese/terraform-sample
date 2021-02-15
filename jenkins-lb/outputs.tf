output "lb" {
  value = {
    id = aws_security_group.sg-lb-jenkins.id
  }
}