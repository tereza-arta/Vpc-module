module "my-vpc" {
	source = "./vpc_module"
}

/*
locals {
	pub_sub_id = module.my-vpc.pub_sub_id
	key_name   = module.my-vpc.key_name 
}
*/

resource "aws_instance" "in-public" {
	ami                         = var.ami
	instance_type               = var.instance_type
	associate_public_ip_address = true

	#Get value from <locals> block
	#subnet_id = local.pub_sub_id

	subnet_id   = module.my-vpc.pub_sub_id
	vpc_security_group_ids      = [module.my-vpc.security_group_id]
	key_name                    = module.my-vpc.key_name
	user_data                   = "${file("install_apache.sh")}"
	tags                        = var.pub_ec2_tag
}

resource "aws_instance" "in-private" {
	ami                    = var.ami
	instance_type          = var.instance_type
	subnet_id              = module.my-vpc.priv_sub_id
	vpc_security_group_ids = [module.my-vpc.security_group_id]
	key_name               = module.my-vpc.key_name
	user_data              = "${file("install_docker.sh")}"
	tags                   = var.priv_ec2_tag
}
