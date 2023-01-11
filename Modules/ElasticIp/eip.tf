resource "aws_eip" "eip" {
  network_interface = var.network_interface
  tags              = var.tags

}

output "EipPublicIP" {
  value = aws_eip.eip.public_ip


}

output "EipID" {
  value = aws_eip.eip.id
}