locals {
  spoke01CIDR = "${var.spoke01PriAddress}0.0/16"
  subnet01 = "${var.spoke01PriAddress}10.0/24"
   subnet02 = "${var.spoke01PriAddress}20.0/24"
    subnetdmz = "${var.spoke01PriAddress}50.0/24"
  
   

  tags = {
    creationDate = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
    environment = "test"
    project = "My Personal Lab"
  }
}