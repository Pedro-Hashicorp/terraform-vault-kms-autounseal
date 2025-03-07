variable "region" {
  default = "eu-west-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_key_path" {
  type        = string
  description = "Path to the SSH private key value"
  default     = "./portiz.pem"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"

}
variable "name_prefix" {
  type        = string
  description = "Prefix to be used for naming resources"
  default     = "vault-cluster"
}
variable "private_ips" {
  type        = list(string)
  description = "Private Ips of different 3 instances"
  default     = ["10.0.1.100", "10.0.2.100", "10.0.3.100"]
}

variable "availability_zones" {
  type = list(string)
  description = "Availability Zones"
  default = [ "eu-west-1a","eu-west-1b","eu-west-1c" ]
}



