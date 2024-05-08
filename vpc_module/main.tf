locals {
	key_name = "private_key"
	protocol = "tcp"
}

resource "tls_private_key" "key-gen" {
	algorithm = var.algorithm
	rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "key" {
	key_name   = local.key_name
	public_key = tls_private_key.key-gen.public_key_openssh
}

resource "local_file" "key-file" {
	content  = tls_private_key.key-gen.private_key_pem
	filename = local.key_name
}

resource "aws_vpc" "vpc" {
	cidr_block           = var.vpc_cidr
	#enable_dns_hostname = true
	instance_tenancy     = "default"
	tags = {
		Name = "Custom VPC"
		Tag  = "Vpc from module"
	}
}

resource "aws_subnet" "pub-sub" {
	vpc_id                   = aws_vpc.vpc.id
	cidr_block               = var.pub_sub_cidr
	availability_zone        = var.az[0]
	#This allocate public_ip for public ec2
	#map_public_ip_on_launch = true
	tags = {
		Name = "Public Subnet"
	}
}

resource "aws_subnet" "priv-sub" {
	vpc_id             = aws_vpc.vpc.id
	cidr_block         = var.priv_sub_cidr
	availability_zone  = var.az[1]
	tags = {
		Name = "Private Subnet"
	}
}

resource "aws_internet_gateway" "int-gw" {
	vpc_id = aws_vpc.vpc.id
	tags = {
		Name = "My Internet Gateway"
	}
}

resource "aws_route_table" "rt-table1"{
	vpc_id = aws_vpc.vpc.id
	tags = {
		Name = "Route Table 1"
	}
}

resource "aws_route" "for-igw" {
	route_table_id         = aws_route_table.rt-table1.id
	destination_cidr_block = var.default_gateway
	gateway_id             = aws_internet_gateway.int-gw.id
}

resource "aws_route_table_association" "rt-ass1" {
	subnet_id      = aws_subnet.pub-sub.id
	route_table_id = aws_route_table.rt-table1.id
}

resource "aws_eip" "eip" {
	#domain = "vpc"
	#This is depricated version
	vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
	allocation_id = aws_eip.eip.id
	subnet_id     = aws_subnet.pub-sub.id
	tags = {
		Name = "My NAT Gateway"
	}
}

resource "aws_route_table" "rt-table2" {
	vpc_id = aws_vpc.vpc.id
	tags = {
		Name = "Route Table 2"
	}
}

resource "aws_route" "for-ngw" {
	route_table_id         = aws_route_table.rt-table2.id
	destination_cidr_block = var.default_gateway
	gateway_id             = aws_nat_gateway.nat-gw.id
}

resource "aws_route_table_association" "rt-ass2" {
	subnet_id      = aws_subnet.priv-sub.id
	route_table_id = aws_route_table.rt-table2.id
} 

resource "aws_security_group" "tf-sg" {
	name        = "custom-sg"
	description = "Some desc of sg"
	vpc_id      = aws_vpc.vpc.id

	ingress {
		description = "SSH" 
		from_port   = 22
		to_port     = 22
		protocol    = local.protocol
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description = "HTTP"
		from_port   = 80
		to_port     = 80
		protocol    = local.protocol
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = local.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "Custom Security Group"
	}
}

