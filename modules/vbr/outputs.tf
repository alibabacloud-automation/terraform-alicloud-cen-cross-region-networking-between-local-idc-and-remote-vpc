# VBR
output "vbr_id" {
  value       = alicloud_express_connect_virtual_border_router.this.id
  description = "The id of VBR."
}

output "vbr_route_table_id" {
  value       = alicloud_express_connect_virtual_border_router.this.route_table_id
  description = "The route table id of VBR."
}

# tr_vbr_attachment
output "tr_vbr_attachment_id" {
  value       = one(alicloud_cen_transit_router_vbr_attachment.this[*].transit_router_attachment_id)
  description = "The id of attachment bewteen TR and VBR."
}

# vbr_health_check
output "health_check_id" {
  value       = alicloud_cen_vbr_health_check.this[*].id
  description = "The id of health check."
}

# bgp_group
output "bgp_group_id" {
  value       = alicloud_vpc_bgp_group.this.id
  description = "The id of BGP group."
}

# bgp_peer
output "bgp_peer_id" {
  value       = alicloud_vpc_bgp_peer.this.id
  description = "The id of BGP peer."
}
