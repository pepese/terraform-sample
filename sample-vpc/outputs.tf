output "vpc" {
  value = {
    vpc_id = aws_vpc.vpc.id
    subnet_public_1a_id = aws_subnet.subnet-public-1a.id
    subnet_public_1c_id = aws_subnet.subnet-public-1c.id
    subnet_public_1d_id = aws_subnet.subnet-public-1d.id
    subnet_protected_1a_id = aws_subnet.subnet-protected-1a.id
    subnet_protected_1c_id = aws_subnet.subnet-protected-1c.id
    subnet_protected_1d_id = aws_subnet.subnet-protected-1d.id
    subnet_private_1a_id = aws_subnet.subnet-private-1a.id
    subnet_private_1c_id = aws_subnet.subnet-private-1c.id
    subnet_private_1d_id = aws_subnet.subnet-private-1d.id
  }
}