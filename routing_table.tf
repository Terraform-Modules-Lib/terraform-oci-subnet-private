resource "oci_core_route_table" "routing_table" {
  compartment_id = local.subnet.compartment_id
  vcn_id = local.subnet.vcn_id

  display_name = local.name
  
  route_rules {
    network_entity_id = local.internet_gw.id

    description = format("Internet route for %s subnet", local.name)
    destination_type = "CIDR_BLOCK"
    destination = "0.0.0.0/0"
  }
}
