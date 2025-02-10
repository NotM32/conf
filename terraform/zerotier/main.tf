variable "host_netconfigurations" {
  type = string
}

locals {
  network_configs = flatten([for host, config in jsondecode(var.host_netconfigurations) : [for networkId, netconf in config : merge(netconf, { "networkId" = networkId, "host" = host })] if config != {}])
}

resource "zerotier_member" "host" {
  for_each       = { for config in local.network_configs : "${config.memberId}-${config.networkId}" => config }
  name           = each.value.host
  member_id      = each.value.memberId
  network_id     = each.value.networkId
  ip_assignments = each.value.ipAssignments
}
