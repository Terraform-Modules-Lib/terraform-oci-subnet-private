data "oci_core_public_ip" "public_addr" {
  # Create if a public_addr_id is provided
  count = length(local.public_addr_id) > 0 ? 1 : 0
  
  id = local.public_addr_id
}

resource "oci_core_public_ip" "public_addr" {
  # Create if a public_addr_id isn't provided
  count = length(local.public_addr_id) > 0 ? 0 : 1

  compartment_id = local.subnet.compartment_id
  lifetime = "RESERVED"

  display_name = local.name
}

resource "oci_core_nat_gateway" "nat_gw" {
  vcn_id = local.subnet.vcn_id
  compartment_id = local.subnet.compartment_id

  display_name = local.name
  public_ip_id = local.public_addr.id
}
