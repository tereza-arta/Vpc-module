#Variables for key
variable "algorithm" {
	type        = string
	description = "Key_algorithm(rsa,ecdsa,ed25519)"
	default     = "RSA"
}

variable "rsa_bits" {
	type        = string
	description = "Length of key with rsa_algorithm"
	default     = 2048 
}

#Variables for VPC
variable "vpc_cidr" {
	type        = string
	description = "Cidr_block value of vpc"
	default     = "10.0.0.0/16"
}

variable "pub_sub_cidr" {
	type       	= string
	description = "Cidr_block of public subnet"
	default     = "10.0.1.0/24"
}

variable "priv_sub_cidr" {
	type        = string
	description = "Cidr_block of private subnet" 
	default     = "10.0.2.0/24"
}

variable "az" {
	type        = list(string)
	description = "Availability Zones in Region" 
	default     = ["us-east-1a", "us-east-1b"]
}

variable "default_gateway" {
	type        = string
	description = "Gateway for access to the internet"
	default     = "0.0.0.0/0"
}

#Variables for Instance
variable "ami" {
	type        = string
	description = "Ami_id of instance"
	default     = "ami-0a7187996cbd8989f"
}

variable "instance_type" {
	type        = string
	description = "Type of EC2 instance(CPU,RAM,Disk,Network components)"
	default     = "t3.micro" 
}

variable "pub_ec2_tag" {
  type        = map(string)
  description = "Tag of ec2 in pub-sub"
  default     = {
    Name = "Custom EC2 first"
    Tag  = "Instance in public subnet"
  }
}

variable "priv_ec2_tag" {
  type        = map(string)
  description = "Tag of ec2 in priv-sub"
  default     = {
    Name = "Custom EC2 second"
    Tag  = "Instance in private subnet"
  }
}
