variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "The Azure region for the resources."
  type        = string
}


variable "kubernetes_version" {
  description = "The version of Kubernetes."
  type        = string
}

# variable "ssh_public_key" {
#   description = "The path to the SSH public key file."
#   type        = string
#   default     = "~/.ssh/id_rsa.pub"
# }

variable "node_vm_size" {
  description = "The size of the VMs in the node pool."
  type        = string
}

variable "enable_auto_scaling" {
  description = "Enable auto scaling for the node pool."
  type        = bool
  default     = true
}

variable "min_node_count" {
  description = "The minimum number of nodes in the node pool."
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "The maximum number of nodes in the node pool."
  type        = number
}

