resource "aws_internet_gateway" "inetgw" {
  vpc_id = var.vpc_id
  tags = var.tags
}

output "id" {
  value = aws_internet_gateway.inetgw.id
}

output "arn" {
  value = aws_internet_gateway.inetgw.arn
}

