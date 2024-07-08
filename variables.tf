variable "region" {
  default = "eu-west-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24","10.0.3.0/24"]
}


variable "private_key_path" {
  type = string
  description = "Path to the SSH private key value"
  default = "./portiz.pem"
}

