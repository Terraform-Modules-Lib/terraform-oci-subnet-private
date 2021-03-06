terraform {
  required_version = "~> 1"

  required_providers {
    oci = {
      source = "hashicorp/oci"
      version = "~> 4"
    }
  }
  
}

locals {
  name = var.name
  cidr = var.cidr
  acl = var.acl
  
  vcn_id = var.vcn_id
  nat_gw_id = var.nat_gw_id
  oci_gw_id = var.oci_gw_id
  
  subnet = module.subnet.subnet

  gw = {
    nat = data.oci_core_nat_gateway.nat_gw
    oci = data.oci_core_service_gateways.oci_gw.service_gateways[0]
  }

  routing_table = oci_core_route_table.routing_table
}

module "subnet" {
  source  = "Terraform-Modules-Lib/subnet/oci"
  
  name = local.name
  cidr = local.cidr
  vcn_id = local.vcn_id
  public = false
  acl = local.acl
}

resource "oci_core_route_table_attachment" "routing" {
  subnet_id = local.subnet.id
  route_table_id = local.routing_table.id
}
