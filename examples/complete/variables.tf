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
  default = [{
    vpc = {
      cidr_block = "10.0.0.0/16"
    }
    vswitches = [{
      zone_id    = "cn-hangzhou-j"
      cidr_block = "10.0.1.0/24"
      }, {
      zone_id    = "cn-hangzhou-k"
      cidr_block = "10.0.2.0/24"
    }]
  }]
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
  default = [{
    vpc = {
      cidr_block = "10.1.0.0/16"
    }
    vswitches = [{
      zone_id    = "cn-beijing-j"
      cidr_block = "10.1.1.0/24"
      }, {
      zone_id    = "cn-beijing-k"
      cidr_block = "10.1.2.0/24"
    }]
  }]
}


