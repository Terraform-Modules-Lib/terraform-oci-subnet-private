data "oci_core_services" "oci_services" {
  
}

resource "oci_core_service_gateway" "oci_gw" {
  compartment_id = local.subnet.compartment_id
  vcn_id = local.subnet.vcn_id

  display_name = local.name

  dynamic "services" {
    for_each = { for service in data.oci_core_services.oci_services: 
      service.id => service
    }

    content {
      service_id = services.value.id
    }
  }
}
