resource "aws_network_interface" "NIC" {
  subnet_id = var.subnet_id
}

output "arn" {
  value = aws_network_interface.NIC.arn
}

output "id" {
  value = aws_network_interface.NIC.id
}

output "prefixes" {
  value = aws_network_interface.NIC.ipv4_prefixes
}