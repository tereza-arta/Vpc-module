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
