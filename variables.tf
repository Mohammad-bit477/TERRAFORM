variable "project" { type = string }
variable "region"  { type = string }

variable "vpc_cidr"            { type = string }
variable "private_subnet_cidr" { type = string }
variable "az"                  { type = string }

variable "instance_type" { type = string }
variable "ec2_ami"       { type = string }
