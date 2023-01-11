resource "aws_route_table_association" "routeTableAssociation" {
  subnet_id = var.subnet_id
  gateway_id = var.gateway_id
  route_table_id = var.route_table_id
}

output "id" {
  value = aws_route_table_association.routeTableAssociation.id
}