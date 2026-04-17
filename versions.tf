terraform {
  required_version = ">= 0.13"

  required_providers {
    alicloud = {
      source                = "aliyun/alicloud"
      version               = ">= 1.200.0"
      configuration_aliases = [alicloud.local_region, alicloud.remote_region]
    }
  }
}


