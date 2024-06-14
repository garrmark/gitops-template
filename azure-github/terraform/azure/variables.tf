variable "azure_region" {
  type        = string
  default     = "eastus"
  description = "value of the resource group location"
}
variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}
variable "kubernetes_cluster_name" {
  type        = string
  default     = "demoaks"
  description = "The name of the Kubernetes cluster."
}
variable "kubernetes_version" {
  type        = string
  default     = "1.29.4"
  description = "value of the kubernetes version"
}
variable "system_node_pool_name" {
  type        = string
  default     = "systemnode"
  description = "Define the name of system node pool name"
  validation {
    condition     = can(regex("^([a-z])([a-z0-9]){0,11}$", var.system_node_pool_name))
    error_message = "Name must begin with a lowercase letter, contain only lowercase letters and numbers, and be between 1 and 12 characters in length."
  }
}
variable "mode" {
  type        = string
  default     = "System" #System or User
  description = "Define the mode of the cluster's Node"
}
variable "os_sku" {
  type        = string
  default     = "Ubuntu" #Ubuntu, CBLMariner, Mariner, Windows2019, Windows2022.
  description = "value of the System Node OS Sku"
}
variable "vm_size" {
  type        = string
  default     = "Standard_B2s"
  description = "value of the System Node VM Size"
}
variable "subscription_id" {
  default = ""
  type    = string
}
variable "tenant_id" {
  default = ""
  type    = string
}
variable "client_id" {
  default = ""
  type    = string
}
variable "client_secret" {
  default = ""
  type    = string
}
