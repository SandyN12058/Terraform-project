variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "anywhere_ip_range" {
  default = "0.0.0.0/0"
}

variable "az_1" {
  default = "ap-south-1a"
}

variable "az_2" {
  default = "ap-south-1b"
}

variable "public_subnet_cidr_1" {
  default = "10.0.0.0/24"
}

variable "public_subnet_cidr_2" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_1" {
  default = "10.0.2.0/24"
}

variable "private_subnet_cidr_2" {
  default = "10.0.3.0/24"
}

variable "ubuntu_ami_id" {
  default = "ami-0e35ddab05955cf57"
}

variable "instance_type" {
  default = "t2.micro"
}