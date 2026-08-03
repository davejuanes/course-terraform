output "ip_de_spring" {
  value = [for i in aws_instance.mi_servidor : i.public_ip] # gnu linux hardlinks y soft links 
}
