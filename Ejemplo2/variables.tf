variable "mi_region_aws" {
  type    = string
  default = "us-east-1"
}

variable "nombres_servicios" {
  description = "Nombre de los repositrorios EC2"
  type        = set(string)
}
