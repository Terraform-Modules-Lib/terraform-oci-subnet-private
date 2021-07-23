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
  vcn = data.oci_core_vcn.vcn
}

data "oci_core_vcn" "vcn" {
  vcn_id = var.vcn_id
}

resource "oci_core_subnet" "this" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
  prohibit_public_ip_on_vnic = false

  cidr_block = var.cidr
  route_table_id = oci_core_route_table.this.id
  display_name = var.name
  dns_label = var.name
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
  
  display_name = var.name
}

resource "oci_core_route_table" "test_route_table" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id

  display_name = var.name
  
  route_rules {
    network_entity_id = oci_core_internet_gateway.this.id
    
    description = "Internet route"
    destination_type = "CIDR_BLOCK"
    destination = "0.0.0.0/0"
  }
}
