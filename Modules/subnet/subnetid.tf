resource "aws_subnet" "subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block

  tags = var.tags
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}