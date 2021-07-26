resource "oci_core_route_table" "routing_table" {
  compartment_id = local.subnet.compartment_id
  vcn_id = local.subnet.vcn_id

  display_name = local.name

  route_rules {
    network_entity_id = local.gw.nat.id

    description = format("Internet route for %s subnet", local.name)
    destination_type = "CIDR_BLOCK"
    destination = "0.0.0.0/0"
  }
  
  dynamic "route_rules" {
    for_each = data.oci_core_services.oci_services[*].services
    
    content {
      network_entity_id = local.gw.oci.id
      
      description = format("%s route for %s subnet", route_rules.value.name, local.name)
      destination_type = "SERVICE_CIDR_BLOCK"
      destination = route_rules.value.cidr_block
    }
  }
}
