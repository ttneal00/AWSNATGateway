resource "tls_private_key" "privkey" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "kp" {
  key_name   = var.key_name
  public_key = tls_private_key.privkey.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.privkey.private_key_pem}' > ./${var.key_name}.pem"
  }
}

resource "local_file" "ssh_key" {
  filename = "${var.key_name}.pem"
  content  = tls_private_key.privkey.private_key_pem
}

output "id" {
  value = aws_key_pair.kp.id
}

output "key_name" {
  value = aws_key_pair.kp.key_name
}


