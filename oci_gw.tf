data "oci_core_service_gateways" "oci_gw" {
  compartment_id = local.subnet.compartment_id
  vcn_id = local.subnet.vcn_id
  
  filter {
    name = "id"
    values = [local.oci_gw_id]
  }
}

data "oci_core_services" "oci_services" {
  for_each = { for service in local.gw.oci.services:
    service.service_id => service
  }

  filter {
    name = "id"
    values = [each.key]
  }
}

/*
resource "oci_core_service_gateway" "oci_gw" {
  compartment_id = local.subnet.compartment_id
  vcn_id = local.subnet.vcn_id

  display_name = local.name

  dynamic "services" {
    for_each = { for service in data.oci_core_services.oci_services.services: 
      service.id => service
    }

    content {
      service_id = services.value.id
    }
  }
}
*/
