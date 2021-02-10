resource "aws_instance" "ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = data.terraform_remote_state.key.outputs.default_key_pair.key_name

  subnet_id = var.subnet_id

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

  tags = merge(local.base_tags, map("Name", "${local.base_name}-ec2"))
}