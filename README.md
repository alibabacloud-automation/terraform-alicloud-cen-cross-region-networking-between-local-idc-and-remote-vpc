Terraform module to build cross-region network communication between different regions in the cloud and on-premises for Alibaba Cloud

terraform-alicloud-cen-cross-region-networking-between-local-idc-and-remote-vpc
======================================


English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-cen-cross-region-networking-between-local-idc-and-remote-vpc/blob/main/README-CN.md)


This module focuses on instances of private network VPCs and dedicated line VBRs connected to a forwarding router, allowing for the creation of cross-region connections under the forwarding router and the allocation of bandwidth for these connections. This enables cross-region network communication between different regions in the cloud and on-premises. The overall solution is as follows:
- Dedicated Line Access for IDC to Cloud: Connect the IDC (Internet Data Center) to Alibaba Cloud in Hangzhou via dedicated lines. To enhance redundancy, it is recommended to prioritize dual physical dedicated lines for the enterprise IDC and Alibaba Cloud POP point, and configure them as needed for either active-passive dual links or load-balanced redundancy, thereby improving the overall reliability of hybrid cloud connectivity.
- Cross-Region on Cloud: Establish a cross-region connection between Alibaba Cloud Shanghai and Hangzhou through a TR (TransRegional) connection. Additionally, activate the CDT (Cross-Domain Traffic) bandwidth billed on a per-traffic basis to connect the Shanghai VPC with the Hangzhou IDC.


Architecture Diagram:

<img src="https://raw.githubusercontent.com/alibabacloud-automation/terraform-alicloud-cen-cross-region-networking-between-local-idc-and-remote-vpc/main/scripts/diagram.png" alt="Architecture Diagram" width="600" height="200">


## Usage

create VPC in cn-beijing and VPC, VBRs in cn-hangzhou.

```hcl
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
  source = "alibabacloud-automation/cen-cross-region-networking-between-local-idc-and-remote-vpc/alicloud"
  providers = {
    alicloud.local_region  = alicloud.local_region
    alicloud.remote_region = alicloud.remote_region
  }

  local_vpc_config = [{
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


  remote_vpc_config = [{
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
```


## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-cen-cross-region-networking-between-local-idc-and-remote-vpc/tree/main/examples/complete)


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |
| <a name="provider_alicloud.local_region"></a> [alicloud.local\_region](#provider\_alicloud.local\_region) | n/a |
| <a name="provider_alicloud.remote_region"></a> [alicloud.remote\_region](#provider\_alicloud.remote\_region) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_local_vbr"></a> [local\_vbr](#module\_local\_vbr) | ./modules/vbr | n/a |
| <a name="module_local_vpc"></a> [local\_vpc](#module\_local\_vpc) | ./modules/vpc | n/a |
| <a name="module_remote_vpc"></a> [remote\_vpc](#module\_remote\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_cen_instance.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_instance) | resource |
| [alicloud_cen_transit_router.tr_local](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router) | resource |
| [alicloud_cen_transit_router.tr_remote](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router) | resource |
| [alicloud_cen_transit_router_peer_attachment.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_peer_attachment) | resource |
| [alicloud_cen_transit_router_route_table_association.tr_local](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_association.tr_remote](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_propagation.tr_local](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_route_table_propagation.tr_remote](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_route_tables.tr_local](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/cen_transit_router_route_tables) | data source |
| [alicloud_cen_transit_router_route_tables.tr_remote](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/cen_transit_router_route_tables) | data source |
| [alicloud_regions.remote](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cen_instance_config"></a> [cen\_instance\_config](#input\_cen\_instance\_config) | The parameters of cen instance. | <pre>object({<br>    cen_instance_name = optional(string, "cen-cross-region")<br>    description       = optional(string, "CEN instance for cross-region connectivity")<br>  })</pre> | `{}` | no |
| <a name="input_local_tr_config"></a> [local\_tr\_config](#input\_local\_tr\_config) | The parameters of transit router. | <pre>object({<br>    transit_router_name        = optional(string, "tr-local")<br>    transit_router_description = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_local_vbr_config"></a> [local\_vbr\_config](#input\_local\_vbr\_config) | The list parameters of local vbr resources. The attributes 'vbr', 'vbr\_bgp\_group' are required. | <pre>list(object({<br>    vbr = object({<br>      physical_connection_id     = string<br>      vlan_id                    = number<br>      local_gateway_ip           = string<br>      peer_gateway_ip            = string<br>      peering_subnet_mask        = string<br>      virtual_border_router_name = optional(string, null)<br>      description                = optional(string, null)<br>    })<br>    tr_vbr_attachment = optional(object({<br>      transit_router_attachment_name        = optional(string, null)<br>      transit_router_attachment_description = optional(string, null)<br>      auto_publish_route_enabled            = optional(bool, true)<br>      route_table_propagation_enabled       = optional(bool, true)<br>      route_table_association_enabled       = optional(bool, true)<br>    }), {})<br>    vbr_health_check = optional(object({<br>      health_check_interval = optional(number, 2)<br>      healthy_threshold     = optional(number, 8)<br>    }), {})<br>    vbr_bgp_group = object({<br>      peer_asn       = string<br>      auth_key       = optional(string, null)<br>      bgp_group_name = optional(string, null)<br>    })<br>    vbr_bgp_peer = optional(object({<br>      bfd_multi_hop   = optional(number, 255)<br>      enable_bfd      = optional(bool, "false")<br>      ip_version      = optional(string, "IPV4")<br>      peer_ip_address = optional(string, null)<br>    }), {})<br>  }))</pre> | `[]` | no |
| <a name="input_local_vpc_config"></a> [local\_vpc\_config](#input\_local\_vpc\_config) | The parameters of local vpc resources. The attributes 'vpc', 'vswitches' are required. | <pre>list(object({<br>    vpc = object({<br>      cidr_block = string<br>      vpc_name   = optional(string, null)<br>    })<br>    vswitches = list(object({<br>      zone_id      = string<br>      cidr_block   = string<br>      vswitch_name = optional(string, null)<br>    }))<br>    tr_vpc_attachment = optional(object({<br>      transit_router_attachment_name  = optional(string, null)<br>      auto_publish_route_enabled      = optional(bool, true)<br>      route_table_propagation_enabled = optional(bool, true)<br>      route_table_association_enabled = optional(bool, true)<br>    }), {})<br>  }))</pre> | `[]` | no |
| <a name="input_remote_tr_config"></a> [remote\_tr\_config](#input\_remote\_tr\_config) | The parameters of transit router. | <pre>object({<br>    transit_router_name        = optional(string, "tr-remote")<br>    transit_router_description = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_remote_vpc_config"></a> [remote\_vpc\_config](#input\_remote\_vpc\_config) | The parameters of remote vpc resources. The attributes 'vpc', 'vswitches' are required. | <pre>list(object({<br>    vpc = object({<br>      cidr_block = string<br>      vpc_name   = optional(string, null)<br>    })<br>    vswitches = list(object({<br>      zone_id      = string<br>      cidr_block   = string<br>      vswitch_name = optional(string, null)<br>    }))<br>    tr_vpc_attachment = optional(object({<br>      transit_router_attachment_name  = optional(string, null)<br>      auto_publish_route_enabled      = optional(bool, true)<br>      route_table_propagation_enabled = optional(bool, true)<br>      route_table_association_enabled = optional(bool, true)<br>    }), {})<br>  }))</pre> | `[]` | no |
| <a name="input_tr_peer_attachment"></a> [tr\_peer\_attachment](#input\_tr\_peer\_attachment) | The parameters of transit router peer attachment. | <pre>object({<br>    transit_router_attachment_name  = optional(string, null)<br>    auto_publish_route_enabled      = optional(bool, true)<br>    route_table_propagation_enabled = optional(bool, true)<br>    route_table_association_enabled = optional(bool, true)<br>    bandwidth_type                  = optional(string, "DataTransfer")<br>    bandwidth                       = optional(number, 100)<br><br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cen_instance_id"></a> [cen\_instance\_id](#output\_cen\_instance\_id) | The id of CEN instance. |
| <a name="output_local_bgp_group_id"></a> [local\_bgp\_group\_id](#output\_local\_bgp\_group\_id) | The id of BGP group. |
| <a name="output_local_bgp_peer_id"></a> [local\_bgp\_peer\_id](#output\_local\_bgp\_peer\_id) | The id of BGP peer. |
| <a name="output_local_cen_transit_router_id"></a> [local\_cen\_transit\_router\_id](#output\_local\_cen\_transit\_router\_id) | The id of local CEN transit router. |
| <a name="output_local_health_check_id"></a> [local\_health\_check\_id](#output\_local\_health\_check\_id) | The id of health check. |
| <a name="output_local_tr_vbr_attachment_id"></a> [local\_tr\_vbr\_attachment\_id](#output\_local\_tr\_vbr\_attachment\_id) | The id of attachment bewteen TR and VBR. |
| <a name="output_local_tr_vpc_attachment_id"></a> [local\_tr\_vpc\_attachment\_id](#output\_local\_tr\_vpc\_attachment\_id) | The id of attachment between TR and local VPC. |
| <a name="output_local_vbr_id"></a> [local\_vbr\_id](#output\_local\_vbr\_id) | The id of VBR. |
| <a name="output_local_vbr_route_table_id"></a> [local\_vbr\_route\_table\_id](#output\_local\_vbr\_route\_table\_id) | The route table id of VBR. |
| <a name="output_local_vpc_id"></a> [local\_vpc\_id](#output\_local\_vpc\_id) | The local vpc id. |
| <a name="output_local_vpc_route_table_id"></a> [local\_vpc\_route\_table\_id](#output\_local\_vpc\_route\_table\_id) | The route table id of local vpc. |
| <a name="output_local_vswitch_ids"></a> [local\_vswitch\_ids](#output\_local\_vswitch\_ids) | The local ids of vswitches. |
| <a name="output_remote_cen_transit_router_id"></a> [remote\_cen\_transit\_router\_id](#output\_remote\_cen\_transit\_router\_id) | The id of remote CEN transit router. |
| <a name="output_remote_tr_vpc_attachment_id"></a> [remote\_tr\_vpc\_attachment\_id](#output\_remote\_tr\_vpc\_attachment\_id) | The id of attachment between TR and remote VPC. |
| <a name="output_remote_vpc_id"></a> [remote\_vpc\_id](#output\_remote\_vpc\_id) | The remote vpc id. |
| <a name="output_remote_vpc_route_table_id"></a> [remote\_vpc\_route\_table\_id](#output\_remote\_vpc\_route\_table\_id) | The route table id of remote vpc. |
| <a name="output_remote_vswitch_ids"></a> [remote\_vswitch\_ids](#output\_remote\_vswitch\_ids) | The remote ids of vswitches. |
| <a name="output_tr_peer_attachment_id"></a> [tr\_peer\_attachment\_id](#output\_tr\_peer\_attachment\_id) | The id of attachment between local TR and remote TR. |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
