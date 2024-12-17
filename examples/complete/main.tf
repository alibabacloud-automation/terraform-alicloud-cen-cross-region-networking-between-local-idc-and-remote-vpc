provider "alicloud" {
  alias  = "local_region"
  region = "cn-hangzhou"
}

provider "alicloud" {
  alias  = "remote_region"
  region = "cn-beijing"
}

data "alicloud_express_connect_physical_connections" "example" {
  provider   = alicloud.local_region
  name_regex = "^preserved-NODELETING"
}

module "complete" {
  source = "../.."
  providers = {
    alicloud.local_region  = alicloud.local_region
    alicloud.remote_region = alicloud.remote_region
  }

  local_vpc_config = var.local_vpc_config


  local_vbr_config = [
    {
      vbr = {
        physical_connection_id     = data.alicloud_express_connect_physical_connections.example.connections[0].id
        vlan_id                    = 210
        local_gateway_ip           = "192.168.0.1"
        peer_gateway_ip            = "192.168.0.2"
        peering_subnet_mask        = "255.255.255.252"
        virtual_border_router_name = "vbr_1_name"
        description                = "vbr_1_description"
      },
      vbr_bgp_group = {
        peer_asn = 45000
      }
    },
    {
      vbr = {
        physical_connection_id     = data.alicloud_express_connect_physical_connections.example.connections[1].id
        vlan_id                    = 211
        local_gateway_ip           = "192.168.1.1"
        peer_gateway_ip            = "192.168.1.2"
        peering_subnet_mask        = "255.255.255.252"
        virtual_border_router_name = "vbr_2_name"
        description                = "vbr_2_description"
      },
      vbr_bgp_group = {
        peer_asn = 45000
      }
    }
  ]


  remote_vpc_config = var.remote_vpc_config

}
