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
  
  vcn_id = var.vcn_id
  public_addr_id = var.public_addr_id
  
  subnet = module.subnet.subnet
  public_addr = try(data.oci_core_public_ip.public_addr[0], oci_core_public_ip.public_addr[0])
}

module "subnet" {
  source  = "Terraform-Modules-Lib/subnet/oci"
  
  name = local.name
  cidr = local.cidr
  vcn_id = local.vcn_id
  public = false
}
