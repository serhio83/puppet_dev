variable "memory" {
  description = "The amount of RAM (MB) for a node"
  default     = 4096
}

variable "vcpu" {
  description = "The amount of virtual CPUs for a node"
  default     = 3
}

variable "vm_names" {
  description = "The names of the VMs to create"
  type        = list(string)
  default     = ["node-01.dev.lab", "node-02.dev.lab", "pmstr.dev.lab"]
}
