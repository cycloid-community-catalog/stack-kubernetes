#
# Scaleway
#

output "scw_region" {
  description = "Scaleway region where the resources were created."
  value       = var.scw_region
}

output "scw_zone" {
  description = "Scaleway zone where the resources were created."
  value       = local.scw_zone
}

#
# Kapsule Cluster
#

output "cluster_id" {
  description = "Kapsule Cluster ID."
  value       = try(module.kapsule.cluster_id, null)
}

output "cluster_name" {
  description = "Kapsule Cluster name."
  value       = try(module.kapsule.cluster_name, null)
}

output "cluster_version" {
  description = "Kapsule Cluster version."
  value       = try(module.kapsule.cluster_version, null)
}

output "cluster_wildcard_dns" {
  description = "The DNS wildcard that points to all ready nodes."
  value       = try(module.kapsule.cluster_wildcard_dns, null)
}

output "cluster_status" {
  description = "Kapsule Cluster status of the Kubernetes cluster."
  value       = try(module.kapsule.cluster_status, null)
}

output "cluster_upgrade_available" {
  description = "Set to `true` if a newer Kubernetes version is available."
  value       = try(module.kapsule.cluster_upgrade_available, null)
}

output "control_plane_endpoint" {
  description = "Kapsule Cluster URL of the Kubernetes API server."
  value       = try(module.kapsule.control_plane_endpoint, null)
}

output "control_plane_host" {
  description = "Kapsule Cluster URL of the Kubernetes API server."
  value       = try(module.kapsule.control_plane_host, null)
  sensitive   = true
}

output "control_plane_ca" {
  description = "Kapsule Cluster CA certificate of the Kubernetes API server."
  value       = try(module.kapsule.control_plane_ca, null)
  sensitive   = true
}

output "control_plane_token" {
  description = "Kapsule Cluster token to connect to the Kubernetes API server."
  value       = try(module.kapsule.control_plane_token, null)
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubernetes config to connect to the Kapsule cluster."
  value       = try(module.kapsule.kubeconfig, null)
  sensitive   = true
}


# VPC

output "scaleway_vpc_id" {
  value = try(module.kapsule.scaleway_vpc_id, null)
}

output "scaleway_vpc_private_network_id" {
  value = try(module.kapsule.scaleway_vpc_private_network_id, null)
}

output "nat_gw_ip" {
  value = try(module.kapsule.nat_gw_ip, null)
}

output "private_network_cidr" {
  value = try(module.kapsule.private_network_cidr, null)
}

#
# Kapsule Node Pool
#

output "node_pool_id" {
  description = "Kapsule node pool ID."
  value       = try(module.node_pool.node_pool_id, null)
}

output "node_pool_status" {
  description = "Kapsule node pool status."
  value       = try(module.node_pool.node_pool_status, null)
}

output "node_pool_version" {
  description = "Kapsule node pool version."
  value       = try(module.node_pool.node_pool_version, null)
}

output "node_pool_current_size" {
  description = "Kapsule node pool current size."
  value       = try(module.node_pool.node_pool_current_size, null)
}

output "node_pool_nodes" {
  description = "Kapsule node pool nodes informations."
  value       = try(module.node_pool.node_pool_nodes, null)
}

output "node_pool_public_ips" {
  description = "Kapsule node pool public IPs."
  value       = try(module.node_pool.node_pool_public_ips, null)
}

output "node_pool_public_ipv6s" {
  description = "Kapsule node pool public IPv6s."
  value       = try(module.node_pool.node_pool_public_ipv6s, null)
}
