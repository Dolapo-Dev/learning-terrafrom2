terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.13.0"

    }
  }

}

provider "docker" {}

resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
  }
}

resource "docker_image" "nodered_image" {
  name = lookup(var.image, terraform.workspace)
}

resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = lookup(var.ext_port, terraform.workspace)[count.index]
  }

  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/noderedvol"
  }
}

# resource "docker_container" "nodered_container2" {
#   name  = join("-", ["nodered2", random_string.random2.result])
#   image = docker_image.nodered_image.latest
#   ports {
#     internal = 1880
#     # external = 1880
#   }
# }



# output "IP-Address2" {
#   value       = join(":", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].external])
#   description = "The IP address and the external port of the second container"
# }



# output "container-name2" {
#   value       = docker_container.nodered_container[1].name
#   description = "This is the name of the second container"
# }