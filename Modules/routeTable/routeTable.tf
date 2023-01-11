resource "aws_route_table" "routeble" {
  vpc_id = var.vpc_id
  route  = var.route



  tags = var.tags

}

output "id" {
  value = aws_route_table.routeble.id
}
