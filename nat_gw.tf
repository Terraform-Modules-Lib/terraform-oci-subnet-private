data "oci_core_nat_gateway" "nat_gw" {
  nat_gateway_id = local.nat_gw_id
}
