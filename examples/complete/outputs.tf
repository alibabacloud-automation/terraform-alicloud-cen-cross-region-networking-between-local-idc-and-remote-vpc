output "cen_instance_id" {
  description = "The id of CEN instance."
  value       = module.complete.cen_instance_id
}

# local
output "local_cen_transit_router_id" {
  description = "The id of local CEN transit router."
  value       = module.complete.local_cen_transit_router_id
}

output "local_vpc_id" {
  value       = module.complete.local_vpc_id
  description = "The local vpc id."
}

output "local_vpc_route_table_id" {
  value       = module.complete.local_vpc_route_table_id
  description = "The route table id of local vpc."
}

output "local_vswitch_ids" {
  value       = module.complete.local_vswitch_ids
  description = "The local ids of vswitches."
}

output "local_tr_vpc_attachment_id" {
  value       = module.complete.local_tr_vpc_attachment_id
  description = "The id of attachment between TR and local VPC."
}

# VBR
output "local_vbr_id" {
  value       = module.complete.local_vbr_id
  description = "The id of VBR."
}

output "local_vbr_route_table_id" {
  value       = module.complete.local_vbr_route_table_id
  description = "The route table id of VBR."
}

output "local_tr_vbr_attachment_id" {
  value       = module.complete.local_tr_vbr_attachment_id
  description = "The id of attachment bewteen TR and VBR."
}

output "local_health_check_id" {
  value       = module.complete.local_health_check_id
  description = "The id of health check."
}

output "local_bgp_group_id" {
  value       = module.complete.local_bgp_group_id
  description = "The id of BGP group."
}

output "local_bgp_peer_id" {
  value       = module.complete.local_bgp_peer_id
  description = "The id of BGP peer."
}

# remote 
output "remote_cen_transit_router_id" {
  description = "The id of remote CEN transit router."
  value       = module.complete.remote_cen_transit_router_id
}

output "remote_vpc_id" {
  value       = module.complete.remote_vpc_id
  description = "The remote vpc id."
}

output "remote_vpc_route_table_id" {
  value       = module.complete.remote_vpc_route_table_id
  description = "The route table id of remote vpc."
}

output "remote_vswitch_ids" {
  value       = module.complete.remote_vswitch_ids
  description = "The remote ids of vswitches."
}

output "remote_tr_vpc_attachment_id" {
  value       = module.complete.remote_tr_vpc_attachment_id
  description = "The id of attachment between TR and remote VPC."
}

# DataTransfer
output "tr_peer_attachment_id" {
  description = "The id of attachment between local TR and remote TR."
  value       = module.complete.tr_peer_attachment_id
}