variable "vpc_id" {
  
}

variable "route" {
  type = list(object({ cidr_block=string, gateway_id=string, carrier_gateway_id=string,core_network_arn=string, destination_prefix_list_id=string, egress_only_gateway_id=string, instance_id=string, ipv6_cidr_block=string, local_gateway_id=string, nat_gateway_id=string, network_interface_id=string, transit_gateway_id=string,vpc_endpoint_id=string, vpc_peering_connection_id=string}))
}

variable "tags" {
  
}