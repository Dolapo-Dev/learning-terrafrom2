variable "env" {
  type = string
  default = "dev"
  description = "Env to deploy to"
}

variable "image" {
  type = map
  description = "Image for container"
  default = {
    dev = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}

variable "ext_port" {
  type = map


  validation {
    condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) >= 1980
    error_message = "The external port must be within the range 0 - 65536."
  }
  
    validation {
    condition     = max(var.ext_port["prod"]...) < 1980 && min(var.ext_port["prod"]...) >= 1880
    error_message = "The external port must be within the range 0 - 65536."
  }
}

variable "int_port" {
  type    = number
  default = 1880

  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

# variable "container_count" {
#   type    = number
#   default = 3
# }

locals {
  container_count = length(lookup(var.ext_port, var.env))
}