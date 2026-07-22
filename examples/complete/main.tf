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

resource "alicloud_cen_bandwidth_package" "example" {
  provider                   = alicloud.local_region
  bandwidth                  = 5
  cen_bandwidth_package_name = "tf-cen-cross-region"
  geographic_region_a_id     = "China"
  geographic_region_b_id     = "China"
  payment_type               = "PostPaid"
}

resource "alicloud_cen_bandwidth_package_attachment" "example" {
  provider             = alicloud.local_region
  instance_id          = module.complete.cen_instance_id
  bandwidth_package_id = alicloud_cen_bandwidth_package.example.id
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

  tr_peer_attachment = {
    bandwidth_type           = "BandwidthPackage"
    bandwidth                = 5
    cen_bandwidth_package_id = alicloud_cen_bandwidth_package_attachment.example.bandwidth_package_id
  }
}
