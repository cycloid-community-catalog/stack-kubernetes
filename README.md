# stack-kubernetes

This stack allows to deploy a chosen kubernetes managed service in one of the available providers, with it's own dedicated VPC and one or more pools

# Requirements

In order to run this task, couple elements are required within the infrastructure:

***azure-aks***
  * Having an Azure Storage Account to store Terraform remote states [Here](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&tabs=azure-portal)

***gcp-gke***
  * Having an Google Cloud Storage bucket to store Terraform remote states [Here](https://cloud.google.com/storage/docs/creating-buckets).
  * Having the `Compute Engine API` and `Kubernetes Engine API` Services APIs enabled for your Google Cloud project ([documentation](https://cloud.google.com/endpoints/docs/openapi/enable-api#console)).

***scaleway-kapsule***
  * Having an Object Storage Bucket to store Terraform remote states [Here](https://www.scaleway.com/en/docs/block-storage-overview/)


# Details

## Pipeline

> **Note** The pipeline contains a manual approval between terraform plan and terraform apply.
> That means if you trigger a terraform plan, to apply it, you have to go on terraform apply job
> and click on the `+` button to trigger it.

<img src="docs/pipeline.png" width="800">

**Jobs description**

  * `terraform-plan`: Terraform job that will simply make a plan of the stack.
  * `terraform-apply`: Terraform job similar to the plan one, but will actually create/update everything that needs to. Please see the plan diff for a better understanding.
  * `terraform-destroy`: :warning: Terraform job meant to destroy the whole stack - **NO CONFIRMATION ASKED**. If triggered, the full project **WILL** be destroyed. Use with caution.

**Variations**

There are 4 versions of the pipeline supported in this stack, one per supported provider:
  * azure-aks: `azure-aks.yml` + `variables.azure-aks.sample.yml`
  * gcp-gke: `gcp-gke.yml` + `variables.gcp-gke.sample.yml`
  * scaleway-kapsule: `scaleway-kapsule.yml` + `variables.scaleway-kapsule.sample.yml`

**Params**

***azure-aks***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`aks_service_principal_client_id`|The Client ID for the Service Principal used by the AKS cluster.|`-`|`((custom_($ .project $)-($ .environment $)-sp.client_id))`|`True`|
|`aks_service_principal_client_secret`|The Client Secret for the Service Principal used by the AKS cluster.|`-`|`((custom_($ .project $)-($ .environment $)-sp.client_secret))`|`True`|
|`azure_client_id`|Azure client ID to use for Terraform.|`-`|`((azure_admin.client_id))`|`True`|
|`azure_client_secret`|Azure client secret to use for Terraform.|`-`|`((azure_admin.client_secret))`|`True`|
|`azure_env`|Azure environment to use for Terraform. Can be either `public`, `usgovernment`, `german` or `china`.|`-`|`public`|`True`|
|`azure_location`|Azure location to use for terraform. |`-`|`West Europe`|`True`|
|`azure_subscription_id`|Azure subscription ID to use for Terraform.|`-`|`((azure_admin.subscription_id))`|`True`|
|`azure_tenant_id`|Azure tenant ID to use for Terraform.|`-`|`((azure_admin.tenant_id))`|`True`|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-aks.git`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ .project $)/terraform/($ .environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ .organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ .environment $)`|`True`|
|`project`|Name of the project.|`-`|`($ .project $)`|`True`|
|`stack_git_branch`|Branch to use on the public stack Git repository|`-`|`master`|`True`|
|`terraform_resource_group_name`|Azure Resource Group of the Storage Account to use to store terraform remote state file.|`-`|`($ .organization_canonical $)-terraform`|`True`|
|`terraform_storage_account_key`|Azure Storage Account key to use to store terraform remote state file.|`-`|`((azure_storage_aks.account_key))`|`True`|
|`terraform_storage_account_name`|Azure Storage Account name to use to store terraform remote state file.|`-`|`((azure_storage_aks.account_name))`|`True`|
|`terraform_storage_container_name`|Azure Storage container name to store terraform remote state file.|`-`|`($ .organization_canonical $)`|`True`|
|`terraform_storage_container_path`|Azure Storage container path to store terraform remote state file.|`-`|`($ .project $)/($ .environment $)`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'1.0.4'`|`True`|


***gcp-gke***

Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-eks.git`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ .project $)/terraform/($ .environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ .organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ .environment $)`|`True`|
|`gcp_credentials_json`|Google Cloud Platform credentials JSON for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((gcp_credentials.json))`|`True`|
|`gcp_project`|Google Cloud Platform project to use for Terraform.|`-`|`kubernetes-gke`|`True`|
|`gcp_region`|Google Cloud Platform region to use for Terraform.|`-`|`europe-west1`|`True`|
|`project`|Name of the project.|`-`|`($ .project $)`|`True`|
|`stack_git_branch`|Branch to use on the public stack Git repository|`-`|`master`|`True`|
|`terraform_storage_bucket_name`|Google Cloud Storage bucket name to store terraform remote state file.|`-`|`($ .organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'1.0.4'`|`True`|

***scaleway-kapsule***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-kapsule.git`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ .project $)/terraform/($ .environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ .organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ .environment $)`|`True`|
|`project`|Name of the project.|`-`|`($ .project $)`|`True`|
|`scw_access_key`|Scaleway access key for Terraform. See [here](https://console.scaleway.com/account/organization/credentials).|`-`|`((scaleway.access_key))`|`True`|
|`scw_default_region`|Scaleway region to use for Terraform.|`-`|`fr-par`|`True`|
|`scw_organization_id`|Scaleway secret key for Terraform. See [here](https://console.scaleway.com/account/organization/credentials).|`-`|`((scaleway.organization_id))`|`True`|
|`scw_secret_key`|Scaleway organization ID for Terraform. See [here](https://console.scaleway.com/account/organization/credentials).|`-`|`((scaleway.secret_key))`|`True`|
|`stack_git_branch`|Branch to use on the public stack Git repository|`-`|`master`|`True`|
|`terraform_storage_bucket_name`|AWS S3 bucket name to store terraform remote state file.|`-`|`($ .organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'0.13.3'`|`True`|


## Terraform

**Inputs**

***azure-aks***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`address_space`|The virtual network address space.|`-`|`10.8.0.0/16`|`False`|
|`cluster_allowed_ips`|Allow Inbound IP CIDRs to access the Kubernetes API.|`-`|`[]`|`False`|
|`cluster_version`|AKS Cluster version to use, defaults to the latest recommended but no auto-upgrade.|`-`|`null`|`False`|
|`enable_kube_dashboard`|Should be `true` to enable the Kubernetes Dashboard.|`-`|`false`|`False`|
|`enable_oms_agent`|Should be `true` to enable OMS agent for log analytics.|`-`|`true`|`False`|
|`enable_pod_security_policy`|Should be `true` to enable Pod Security Policies. Pod Security Policies needs to be enabled via the Azure CLI. @see https://github.com/Azure/AKS/blob/master/previews.md#kubernetes-pod-security-policies-|`-`|`false`|`False`|
|`enable_rbac`|Should be `true` to enable Role Based Access Control.|`-`|`true`|`False`|
|`extra_tags`|Dict of extra tags to add on aws resources. format { "foo" = "bar" }.|`-`|`{}`|`False`|
|`log_analytics_workspace_sku`|The Log Analytics workspace SKU to use if `enable_oms_agent = true`.|`-`|`PerGB2018`|`False`|
|`log_retention_in_days`|The Log Analytics retention in days to use if `enable_oms_agent = true`.|`-`|`30`|`False`|
|`network_docker_bridge_cidr`|AKS cluster service CIDR to use, required if `network_plugin = azure`.|`-`|`172.17.0.1/16`|`False`|
|`network_load_balancer_sku`|AKS cluster load balancer SKU, can be either `basic` or `standard`.|`-`|`basic`|`False`|
|`network_plugin`|AKS cluster network plugin to use, can be either `azure` or `kubenet`.|`-`|`azure`|`False`|
|`network_pod_cidr`|AKS cluster pod CIDR to use, required if `network_plugin = kubenet`.|`-`|`10.9.0.0/16`|`False`|
|`network_policy_plugin`|AKS cluster network policy plugin to use, can be either `azure` or `calico`. `azure` only available with `network_plugin = azure`.|`-`|`azure`|`False`|
|`network_service_cidr`|AKS cluster service CIDR to use, required if `network_plugin = azure`.|`-`|`10.10.0.0/16`|`False`|
|`node_admin_username`|AKS node admin username for SSH connection.|`-`|`cycloid`|`False`|
|`node_availability_zones`|To use specific Azure Availability Zones for the default nodes pool. @see https://docs.microsoft.com/en-us/azure/availability-zones/az-overview|`-`|`[]`|`False`|
|`node_count`|AKS default nodes desired count.|`-`|`1`|`False`|
|`node_disk_size`|AKS default nodes root disk size.|`-`|`60`|`False`|
|`node_enable_auto_scaling`|Enable auto scaling of AKS default nodes.|`-`|`true`|`False`|
|`node_enable_public_ip`|Should be true if public IPs should be associated to AKS default nodes.|`-`|`false`|`False`|
|`node_max_count`|AKS default nodes auto scaling group maximum count.|`-`|`10`|`False`|
|`node_max_pods`|Maximum number of pods per AKS default node (can't be more than 250).|`-`|`250`|`False`|
|`node_min_count`|AKS default nodes auto scaling minimum count.|`-`|`1`|`False`|
|`node_network_subnet_id`|Network subnet ID that should be used by AKS default nodes.|`-`|``|`True`|
|`node_pool_name`|AKS default nodes pool given name.|`-`|`default`|`False`|
|`node_pool_type`|AKS default nodes pool type, can be either `AvailabilitySet` or `VirtualMachineScaleSets`.|`-`|`Linux`|`False`|
|`node_size`|AKS default nodes virtualmachine size.|`-`|`Standard_DS2_v2`|`False`|
|`node_ssh_key`|AKS node admin SSH key for SSH connection.|`-`|`""`|`False`|
|`node_taints`|AKS nodes taints to setup.|`-`|`[]`|`False`|
|`rbac_client_app_id`|The Client ID of an Azure Active Directory Application for Role Based Access Control.|`-`|`""`|`False`|
|`rbac_client_app_secret`|The Server Secret of an Azure Active Directory Application for Role Based Access Control.|`-`|`""`|`False`|
|`rbac_server_app_id`|The Server ID of an Azure Active Directory Application for Role Based Access Control.|`-`|`""`|`False`|
|`rbac_use_active_directory`|Should be `true` to enable Role Based Access Control with an Azure Active Directory.|`-`|`false`|`False`|
|`ssh_allowed_ips`|Allow Inbound IP CIDRs to access the instances via SSH.|`-`|`["*"]`|`False`|
|`subnets`|The private subnets for the VPC.|`list`|`{"nodes" = "10.8.0.0/16", "pods"  = "10.9.0.0/16", "loadbalancers" = "10.11.0.0/16",}`|`False`|


***gcp-gke***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`cluster_regional`|If the GKE Cluster must be regional or zonal. Be careful, this setting is destructive.|`-`|`false`|`False`|
|`cluster_release_channel`|GKE Cluster release channel to use. Accepted values are UNSPECIFIED, RAPID, REGULAR and STABLE.|`-`|`UNSPECIFIED`|`False`|
|`cluster_version`|GKE Cluster version to use.|`-`|`latest`|`False`|
|`default_max_pods_per_node`|The maximum number of pods to schedule per node.|`-`|`110`|`False`|
|`enable_binary_authorization`|Enable GKE Cluster BinAuthZ Admission controller.|`-`|`false`|`False`|
|`enable_cloudrun`|Enable GKE Cluster Cloud Run for Anthos addon.|`-`|`false`|`False`|
|`enable_horizontal_pod_autoscaling`|Enable GKE Cluster horizontal pod autoscaling addon.|`-`|`true`|`False`|
|`enable_http_load_balancing`|Enable GKE Cluster HTTP load balancing addon.|`-`|`false`|`False`|
|`enable_istio`|Enable GKE Cluster Istio addon.|`-`|`false`|`False`|
|`enable_network_policy`|Enable GKE Cluster network policies addon.|`-`|`true`|`False`|
|`enable_only_private_endpoint`|If true, only enable the private endpoint which disable the Public endpoint entirely. If false, private endpoint will be enabled, and the public endpoint will be only accessible by master authorized networks.|`-`|`false`|`False`|
|`enable_sandbox`|Enable GKE Sandbox (Do not forget to set image_type = COS_CONTAINERD and node_version = 1.12.7-gke.17 or later to use it).|`-`|`false`|`False`|
|`enable_shielded_nodes`|Enable GKE Cluster Shielded Nodes features on all nodes.|`-`|`true`|`False`|
|`enable_vertical_pod_autoscaling`|Enable GKE Cluster vertical pod autoscaling addon. Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it.|`-`|`false`|`False`|
|`extra_labels`|Dict of extra labels to add on GCP resources. format { "foo" = "bar" }.|`-`|`{}`|`False`|
|`gcp_project`|The Google Cloud Platform project to use. |`-`|``|`True`|
|`gcp_region`|The Google Cloud Platform region to use.|`-`|`eu-central1`|`False`|
|`gcp_zones`|To use specific Google Cloud Platform zones if not regional, otherwise it will be chosen randomly.|`-`|`[]`|`False`|
|`master_authorized_networks`|List of master authorized networks.|`-`|`[]`|`False`|
|`network_routing_mode`|The network routing mode.|`-`|`GLOBAL`|`False`|
|`node_pools`|GKE Cluster node pools to create.|`-`|`[]`|`False`|
|`pods_cidr`|The CIDR of the pods secondary range.|`-`|`10.9.0.0/16`|`False`|
|`services_cidr`|The CIDR of the services secondary range.|`-`|`10.10.0.0/16`|`False`|
|`subnet_cidr`|The CIDR of the VPC subnet.|`-`|`10.8.0.0/16`|`False`|


***scaleway-kapsule***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`admission_plugins`|The list of admission plugins to enable on the cluster.|`-`|`[]`|`False`|
|`auto_upgrade`|Set to `true` to enable Kubernetes patch version auto upgrades. Important: When enabling auto upgrades, the `cluster_version` variable take a minor version like x.y (ie 1.18).|`-`|`true`|`False`|
|`cluster_version`|Kapsule cluster version.|`-`|`1.19`|`False`|
|`cni`|The Container Network Interface (CNI) for the Kubernetes cluster (either `cilium`, `calico`, `weave` or `flannel`).|`-`|`cilium`|`False`|
|`container_runtime`|The container runtime of the pool. Important: Updates to this field will recreate a new resource.|`-`|`docker`|`False`|
|`enable_autohealing`|Enables the autohealing feature for this pool.|`-`|`true`|`False`|
|`enable_autoscaling`|Enables the autoscaling feature for this pool. Important: When enabled, an update of the size will not be taken into account.|`-`|`false`|`False`|
|`enable_dashboard`|Enables the Kubernetes dashboard for the Kubernetes cluster.|`-`|`true`|`False`|
|`extra_tags`|Dict of extra tags to add on aws resources. format { "foo" = "bar" }.|`-`|`{}`|`False`|
|`feature_gates`|The list of feature gates to enable on the cluster.|`-`|`[]`|`False`|
|`ingress`|The ingress controller to be deployed on the Kubernetes cluster (either `nginx`, `traefik` or `traefik2`).|`-`|`nginx`|`False`|
|`node_autoscaling_max_size`|The maximum size of the pool, used by the autoscaling feature.|`-`|`10`|`False`|
|`node_autoscaling_min_size`|The minimum size of the pool, used by the autoscaling feature.|`-`|`1`|`False`|
|`node_count`|Desired number of node servers.|`-`|`1`|`False`|
|`node_pool_name`|Node group given name.|`-`|`standard`|`False`|
|`node_type`|Type of instance to use for node servers.|`-`|`GP1-XS`|`False`|
|`placement_group_id`|The placement group the nodes of the pool will be attached to. Important: Updates to this field will recreate a new resource.|`-`|`""`|`False`|
|`wait_for_pool_ready`|Whether to wait for the pool to be ready.|`-`|`true`|`False`|


**Outputs**

***azure-aks***

| Name | Description |
|------|-------------|
| `vnet_id` | AKS Cluster dedicated vNet ID. |
| `vnet_name` | AKS Cluster dedicated vNet name. |
| `vnet_location` | AKS Cluster dedicated vNet location. |
| `vnet_subnet_ids` | AKS Cluster dedicated vNet subnet IDs. |
| `vnet_address_space` | AKS Cluster dedicated vNet address space. |
| `nodes_sg_allow` | AKS Cluster dedicated vNet security group to allow SSH and metrics access to instances. |
| `cluster_id` | AKS Cluster ID. |
| `cluster_public_fqdn` | AKS Cluster public FQDN. |
| `cluster_private_fqdn` | AKS Cluster private FQDN. |
| `control_plane_host` | AKS Cluster kubeconfig host. |
| `control_plane_ca` | AKS Cluster certificate authority. |
| `kubeconfig` | Kubernetes config to connect to the AKS Cluster. |


***gcp-gke***

| Name | Description |
|------|-------------|
| `cluster_ca` | GKE Cluster certificate authority. |
| `cluster_endpoint` | GKE Cluster endpoint. |
| `cluster_location` | GKE Cluster location (region if regional cluster, zone if zonal cluster). |
| `cluster_master_authorized_networks_config` | GKE Cluster networks from which access to master is permitted. |
| `cluster_master_version` | GKE Cluster master version. |
| `cluster_name` | GKE Cluster name. |
| `cluster_region` | GKE Cluster region." |
| `cluster_release_channel` | GKE Cluster release channel. |
| `cluster_type` | GKE Cluster type. |
| `cluster_zones` | GKE Cluster zones. |
| `kubeconfig` | Kubernetes config to connect to the GKE cluster. |
| `network_name` | GKE Cluster dedicated network name. |
| `network_self_link` | GKE Cluster dedicated network URI. |
| `node_pools_names` | GKE Cluster node pools names. |
| `node_pools_service_account` | GKE Cluster nodes default service account if not overriden in `node_pools`. |
| `node_pools_versions` | GKE Cluster node pools versions. |
| `pods_ip_range` | GKE Cluster dedicated pods IP range. |
| `services_ip_range` | GKE Cluster dedicated services IP range. |
| `subnet_name` | GKE Cluster dedicated subnet name. |
| `subnet_region` | GKE Cluster dedicated subnet region. |
| `subnet_self_link` | GKE Cluster dedicated subnet URI. |


***scaleway-kapsule***

| Name | Description |
|------|-------------|
|`cluster_id`|Kapsule Cluster ID.|
|`cluster_name`|Kapsule Cluster name.|
|`cluster_status`|Kapsule Cluster status of the Kubernetes cluster.|
|`cluster_upgrade_available`|Set to `true` if a newer Kubernetes version is available.|
|`cluster_version`|Kapsule Cluster version.|
|`cluster_wildcard_dns`|The DNS wildcard that points to all ready nodes.|
|`control_plane_ca`|Kapsule Cluster CA certificate of the Kubernetes API server.|
|`control_plane_endpoint`|Kapsule Cluster URL of the Kubernetes API server.|
|`control_plane_host`|Kapsule Cluster URL of the Kubernetes API server.|
|`control_plane_token`|Kapsule Cluster token to connect to the Kubernetes API server.|
|`kubeconfig`|Kubernetes config to connect to the Kapsule cluster.|
|`node_pool_current_size`|Kapsule node pool current size.|
|`node_pool_id`|Kapsule node pool ID.|
|`node_pool_nodes`|Kapsule node pool nodes informations.|
|`node_pool_public_ips`|Kapsule node pool public IPs.|
|`node_pool_public_ipv6s`|Kapsule node pool public IPv6s.|
|`node_pool_status`|Kapsule node pool status.|
|`node_pool_version`|Kapsule node pool version.|
|`scw_region`|Scaleway region where the resources were created.|
|`scw_zone`|Scaleway zone where the resources were created.|
