resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  instance_tenancy = var.instance_tenancy
  tags = var.tags
}

output "vpcID" {
  value = aws_vpc.vpc.id
  
}

output "vpcCIDR" {
  value = aws_vpc.vpc.cidr_block
}