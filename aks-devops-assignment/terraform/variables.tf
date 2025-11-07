variable "prefix" { type = string }
variable "location" { type = string  default = "eastus" }
variable "admin_group_object_ids" { type = list(string) default = [] }
variable "kubernetes_version" { type = string  default = "1.30.3" }
variable "node_count" { type = number default = 2 }
variable "node_size" { type = string  default = "Standard_D4s_v5" }
variable "enable_private_cluster" { type = bool default = true }
variable "authorized_ip_ranges" { type = list(string) default = [] }
