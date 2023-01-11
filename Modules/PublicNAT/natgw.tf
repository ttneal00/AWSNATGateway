resource "aws_nat_gateway" "nat" {
  allocation_id = var.EIPId
  subnet_id     = var.subnet_id

  tags = var.tags


}

output "id" {
  value = aws_nat_gateway.nat.id
}