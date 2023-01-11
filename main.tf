provider "aws" {
  region     = "us-east-1"
}

module "Spoke01" {
  source = "./Modules/VPC"
  cidr_block = local.spoke01CIDR
  instance_tenancy = "default"
  tags = local.tags
}    

module "Spoke01Subnet01" {
    source = "./Modules/subnet"
    cidr_block = local.subnet01
    tags = local.tags
    vpc_id = module.Spoke01.vpcID
}

module "Spoke01Subnet02" {
    source = "./Modules/subnet"
    cidr_block = local.subnet02
    tags = local.tags
    vpc_id = module.Spoke01.vpcID
}

module "natGWEip" {
  source = "./Modules/ElasticIp"
  tags = local.tags
  network_interface = null

}

module "ExtIP" {
  source = "./Modules/MyCurrentInfo"
}

module "SecurityGroup" {
  source = "./Modules/securityGroup"
  name = "${var.prefix}-NAT-Lab-SG"
  description = "RDP into JumpBox"
  vpc_id = module.Spoke01.vpcID
  depends_on = [
    module.Spoke01
  ]
}

module "IngressRule" {
  source = "./Modules/securityGroupRule"
  type = "ingress"
  to_port = 3389
  from_port = 3389
  security_group_id = module.SecurityGroup.id
  CIDRBlock = [module.ExtIP.myextIPCIDR]
  protocol = "tcp"
  depends_on = [
    module.SecurityGroup
  ]
}

module "IngressRuleInt" {
  source = "./Modules/securityGroupRule"
  type = "ingress"
  to_port = 0
  from_port = 65535
  security_group_id = module.SecurityGroup.id
  CIDRBlock = [module.Spoke01.vpcCIDR]
  protocol = "all"
  depends_on = [
    module.SecurityGroup
  ]
}

module "EgressRule" {
  source = "./Modules/securityGroupRule"
  type = "egress"
  to_port = 0
  from_port = 0
  security_group_id = module.SecurityGroup.id
  CIDRBlock = ["0.0.0.0/0"]
  protocol = "-1"
  depends_on = [
    module.SecurityGroup
  ]
}

module "InternetGW" {
  source = "./Modules/internetGateway"
  vpc_id = module.Spoke01.vpcID
  tags = local.tags
}

module "internetegressRoutetable" {
  source = "./Modules/routeTable"
   route = [ 
   {
     cidr_block = "0.0.0.0/0"
     gateway_id = "${module.InternetGW.id}"
     carrier_gateway_id = ""
     core_network_arn = ""
     destination_prefix_list_id = ""
     egress_only_gateway_id = ""
     instance_id = ""
     ipv6_cidr_block = null
     local_gateway_id = ""
     nat_gateway_id = ""
     network_interface_id = ""
     transit_gateway_id = ""
     vpc_endpoint_id = ""
     vpc_peering_connection_id = ""
   }]
  vpc_id = module.Spoke01.vpcID
  tags = local.tags
}

# natgw modules
module "internetegressRoutetableNATGW" {
  source = "./Modules/routeTable"
   route = [ 
   {
     cidr_block = "0.0.0.0/0"
     gateway_id = "${module.natgw.id}"
     carrier_gateway_id = ""
     core_network_arn = ""
     destination_prefix_list_id = ""
     egress_only_gateway_id = ""
     instance_id = ""
     ipv6_cidr_block = null
     local_gateway_id = ""
     nat_gateway_id = ""
     network_interface_id = ""
     transit_gateway_id = ""
     vpc_endpoint_id = ""
     vpc_peering_connection_id = ""
   }]
  vpc_id = module.Spoke01.vpcID
  tags = local.tags
}

module "natgw" {
  source = "./Modules/PublicNAT"
  subnet_id = module.Spoke01Subnet02.subnet_id
  EIPId = module.natGWEip.EipID
  tags = local.tags
  depends_on = [
    module.natGWEip,
    module.Spoke01Subnet02,
    module.InternetGW
  ]
  
}

module "mainassocation" {
  source = "./Modules/mainRouteTableAssociation"
  vpc_id = module.Spoke01.vpcID
  route_table_id = module.internetegressRoutetableNATGW.id
  depends_on = [
    module.internetegressRoutetable,
    module.Spoke01
  ]
}

module "internetgatewayRouteAssociation" {
  source = "./Modules/RouteAssociation"
  subnet_id = module.Spoke01Subnet02.subnet_id
  gateway_id = null
  route_table_id = module.internetegressRoutetable.id
  depends_on = [
    module.Spoke01Subnet02,
    module.internetegressRoutetable
  ]
}

module "privatekey" {
  source = "./Modules/pemkey"
  key_name = "${var.prefix}-key"
}

module "VMNic01" {
  source = "./Modules/networkInterface"
  subnet_id = module.Spoke01Subnet01.subnet_id

}

module "VMNic02" {
  source = "./Modules/networkInterface"
  subnet_id = module.Spoke01Subnet02.subnet_id

}

module "Spoke01VM" {
  source = "./Modules/Compute"
  ami = "ami-0db0a93f937948bf7"
  instance_type = "t2.medium"
  subnet_id = module.Spoke01Subnet01.subnet_id
  vpc_security_group_ids = module.SecurityGroup.id
  key_name = module.privatekey.key_name
    depends_on = [
    module.privatekey
  ]
}


module "Jumpbox" {
  source = "./Modules/Compute"
  ami = "ami-0db0a93f937948bf7"
  instance_type = "t2.medium"
  subnet_id = module.Spoke01Subnet02.subnet_id
  vpc_security_group_ids = module.SecurityGroup.id
  key_name = module.privatekey.key_name
  depends_on = [
    module.privatekey
  ]
  associate_public_ip_address = true
}

output "eipPublicIP" {
  value = module.natGWEip.EipPublicIP
  
}

output "jumpboxIP" {
  value = module.Jumpbox.extip
  
}

output "VPCid" {
  value = module.Spoke01.vpcID
}

output "routetableid" {
  value = module.internetegressRoutetable.id
}