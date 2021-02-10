output "vpc" {
  value = {
    id = aws_vpc.vpc.id
    public_subnet_a_id = aws_subnet.public_subnet_a.id
    public_subnet_c_id = aws_subnet.public_subnet_c.id
    public_subnet_d_id = aws_subnet.public_subnet_d.id
    private_subnet_a_id = aws_subnet.private_subnet_a.id
    private_subnet_c_id = aws_subnet.private_subnet_c.id
    private_subnet_d_id = aws_subnet.private_subnet_d.id
  }
}