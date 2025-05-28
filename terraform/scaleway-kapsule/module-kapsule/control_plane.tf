#
# Kapsule Cluster
#
# VPC
resource "scaleway_vpc" "vpc" {
  name = "${var.project}-${var.env}"
  tags = compact(concat(local.merged_tags, [
    "role=control-plane"
  ]))
}

# Subnet
resource "scaleway_vpc_private_network" "priv" {
  name   = "${var.project}-${var.env}-prv"
  vpc_id = scaleway_vpc.vpc.id
  ipv4_subnet {
    subnet = var.private_network_cidr
  }
  tags = compact(concat(local.merged_tags, [
    "role=control-plane"
  ]))
}

# Nat GW
resource "scaleway_vpc_public_gateway_ip" "pub" {
  tags = compact(concat(local.merged_tags, [
    "role=control-plane"
  ]))
}

resource "scaleway_vpc_public_gateway" "nat" {
  name  = "${var.project}-${var.env}-nat-gw"
  type  = "VPC-GW-S"
  ip_id = scaleway_vpc_public_gateway_ip.pub.id
  tags = compact(concat(local.merged_tags, [
    "role=control-plane"
  ]))

  # Allow to use nat as a bastion
  bastion_enabled = true
  bastion_port    = 61000

  # By default, the SMTP ports (25, 465, 587, 2525) are blocked to avoid spam.
  # If you wish to send emails from resources located behind your Public Gateway, open these ports by enabling SMTP.
  enable_smtp = true
}

# Attatch private network to nat
resource "scaleway_vpc_gateway_network" "nat" {
  gateway_id         = scaleway_vpc_public_gateway.nat.id
  private_network_id = scaleway_vpc_private_network.priv.id
  enable_masquerade  = true
  ipam_config {
    push_default_route = true
  }
}

resource "scaleway_k8s_cluster" "cluster" {
  name                        = var.cluster_name
  description                 = "${var.customer} ${var.project} Kapsule ${var.env} cluster"
  version                     = var.cluster_version
  cni                         = var.cni
  private_network_id          = scaleway_vpc_private_network.priv.id
  feature_gates               = var.feature_gates
  admission_plugins           = var.admission_plugins
  delete_additional_resources = false

  tags = compact(concat(local.merged_tags, [
    "role=control-plane"
  ]))

  auto_upgrade {
    enable                        = var.auto_upgrade
    maintenance_window_day        = var.maintenance_window_day
    maintenance_window_start_hour = var.maintenance_window_start_hour
  }

  autoscaler_config {
    disable_scale_down              = var.disable_scale_down
    scale_down_delay_after_add      = var.scale_down_delay_after_add
    scale_down_unneeded_time        = var.scale_down_unneeded_time
    estimator                       = var.estimator
    expander                        = var.expander
    ignore_daemonsets_utilization   = var.ignore_daemonsets_utilization
    balance_similar_node_groups     = var.balance_similar_node_groups
    expendable_pods_priority_cutoff = var.expendable_pods_priority_cutoff
  }
}
