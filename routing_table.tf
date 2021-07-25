locals {
  __rtable = concat([{
    
      network_entity_id = local.internet_gw.id

      description = format("Internet route for %s subnet", local.name)
      destination_type = "CIDR_BLOCK"
      destination = "0.0.0.0/0"
    
    }], [ for service in data.oci_core_services.oci_services.services: {
      
      network_entity_id = local.oci_gw.id

      description = format("%s route for %s subnet", service.name, local.name)
      destination_type = "SERVICE_CIDR_BLOCK"
      destination = service.cidr_block
      
    }])
}

resource "oci_core_route_table" "routing_table" {
  compartment_id = local.subnet.compartment_id
  vcn_id = local.subnet.vcn_id

  display_name = local.name
  
  route_rules = local.__rtable
}
