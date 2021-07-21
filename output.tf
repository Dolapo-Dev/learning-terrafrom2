output "IP-Address" {
  value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "The IP address and the external port of the container"

}

output "container-name" {
  value       = docker_container.nodered_container[*].name
  description = "This is the name of the container"
}