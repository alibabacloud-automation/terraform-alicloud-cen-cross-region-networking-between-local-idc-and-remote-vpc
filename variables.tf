
variable "cen_instance_config" {
  description = "The parameters of cen instance."
  type = object({
    cen_instance_name = optional(string, "cen-cross-region")
    description       = optional(string, "CEN instance for cross-region connectivity")
  })
  default = {}
}

# local
variable "local_tr_config" {
  description = "The parameters of transit router."
  type = object({
    transit_router_name        = optional(string, "tr-local")
    transit_router_description = optional(string, null)
  })
  default = {}
}

variable "local_vpc_config" {
  description = "The parameters of local vpc resources. The attributes 'vpc', 'vswitches' are required."
  type = list(object({
    vpc = object({
      cidr_block = string
      vpc_name   = optional(string, null)
    })
    vswitches = list(object({
      zone_id      = string
      cidr_block   = string
      vswitch_name = optional(string, null)
    }))
    tr_vpc_attachment = optional(object({
      transit_router_attachment_name  = optional(string, null)
      auto_publish_route_enabled      = optional(bool, true)
      route_table_propagation_enabled = optional(bool, true)
      route_table_association_enabled = optional(bool, true)
    }), {})
  }))
  default = []
}

variable "local_vbr_config" {
  description = "The list parameters of local vbr resources. The attributes 'vbr', 'vbr_bgp_group' are required."
  type = list(object({
    vbr = object({
      physical_connection_id     = string
      vlan_id                    = number
      local_gateway_ip           = string
      peer_gateway_ip            = string
      peering_subnet_mask        = string
      virtual_border_router_name = optional(string, null)
      description                = optional(string, null)
    })
    tr_vbr_attachment = optional(object({
      transit_router_attachment_name        = optional(string, null)
      transit_router_attachment_description = optional(string, null)
      auto_publish_route_enabled            = optional(bool, true)
      route_table_propagation_enabled       = optional(bool, true)
      route_table_association_enabled       = optional(bool, true)
    }), {})
    vbr_health_check = optional(object({
      health_check_interval = optional(number, 2)
      healthy_threshold     = optional(number, 8)
    }), {})
    vbr_bgp_group = object({
      peer_asn       = string
      auth_key       = optional(string, null)
      bgp_group_name = optional(string, null)
    })
    vbr_bgp_peer = optional(object({
      bfd_multi_hop   = optional(number, 255)
      enable_bfd      = optional(bool, "false")
      ip_version      = optional(string, "IPV4")
      peer_ip_address = optional(string, null)
    }), {})
  }))
  default = []
}

# remote
variable "remote_tr_config" {
  description = "The parameters of transit router."
  type = object({
    transit_router_name        = optional(string, "tr-remote")
    transit_router_description = optional(string, null)
  })
  default = {}
}


variable "remote_vpc_config" {
  description = "The parameters of remote vpc resources. The attributes 'vpc', 'vswitches' are required."
  type = list(object({
    vpc = object({
      cidr_block = string
      vpc_name   = optional(string, null)
    })
    vswitches = list(object({
      zone_id      = string
      cidr_block   = string
      vswitch_name = optional(string, null)
    }))
    tr_vpc_attachment = optional(object({
      transit_router_attachment_name  = optional(string, null)
      auto_publish_route_enabled      = optional(bool, true)
      route_table_propagation_enabled = optional(bool, true)
      route_table_association_enabled = optional(bool, true)
    }), {})
  }))
  default = []
}


variable "tr_peer_attachment" {
  description = "The parameters of transit router peer attachment."
  type = object({
    transit_router_attachment_name  = optional(string, null)
    auto_publish_route_enabled      = optional(bool, true)
    route_table_propagation_enabled = optional(bool, true)
    route_table_association_enabled = optional(bool, true)
    bandwidth_type                  = optional(string, "DataTransfer")
    bandwidth                       = optional(number, 100)

  })
  default = {}
}
