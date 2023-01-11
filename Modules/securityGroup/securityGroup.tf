resource "aws_security_group" "security_group" {
  name = var.name
  description = var.description
  vpc_id = var.vpc_id
}

output "id" {
  value = aws_security_group.security_group.id
}

output "arn" {
  value = aws_security_group.security_group.arn
}


