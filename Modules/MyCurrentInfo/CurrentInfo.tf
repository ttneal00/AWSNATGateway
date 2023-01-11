data "http" "ip" {
  url = "http://ipv4.icanhazip.com"
}

output "MyextIP" {
  value = chomp(data.http.ip.response_body)
}

output "myextIPCIDR" {
  value = "${chomp(data.http.ip.response_body)}/32"
}

