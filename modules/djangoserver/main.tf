terraform {
  required_version = ">= 0.12.0"
}

resource "aws_vpc" "vpc_main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.vpc_dns_support
  enable_dns_hostnames = var.vpc_dns_hostnames
  tags = {
    Name = "${var.server_name}-vpc"
  }
}

resource "aws_subnet" "subnet-main" {
  count             = 2
  availability_zone = var.vpc_azs[count.index]
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.vpc_subnets[count.index]
  tags = {
    Name = "${var.server_name}-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "rt_main" {
  vpc_id = aws_vpc.vpc_main.id
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "${var.server_name}-rt"
  }
}

resource "aws_route_table_association" "rta_main" {
  count          = 2
  route_table_id = aws_route_table.rt_main.id
  subnet_id      = aws_subnet.subnet-main[count.index].id
}

resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = "${var.server_name}-igw"
  }
}

resource "aws_route" "public_internet_igw_route" {
  route_table_id         = aws_route_table.rt_main.id
  gateway_id             = aws_internet_gateway.igw_main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_security_group" "sg-main" {
  count       = 2
  name        = "${var.server_name}-sg-${count.index + 1}"
  description = "Allow TCP/8000 & TCP/22"
  vpc_id      = aws_vpc.vpc_main.id
  ingress {
    description = "Allow port 22 from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow anyone on port 8000"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    #security_groups = [aws_security_group.lb-sg.id]
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow port 3306 from us-east-1b subnet"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "appkey" {
  key_name   = "django_appkey"
  public_key = file(var.ssh_pubkey_file)
}

data "aws_ssm_parameter" "UbuntuAmi" {
  name = "/aws/service/canonical/ubuntu/server/18.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

resource "aws_instance" "ec2" {
  count                       = 2
  ami                         = data.aws_ssm_parameter.UbuntuAmi.value
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.appkey.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg-main[count.index].id]
  subnet_id                   = aws_subnet.subnet-main[count.index].id
  user_data                   = <<-EOF
		#! /bin/bash
                sudo apt-get update
		            sudo apt-get install -y git
                sudo apt-get remove docker docker-engine docker.io containerd runc
                sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release
                sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
                echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                sudo apt-get update
                sudo apt-get install -y docker-ce docker-ce-cli containerd.io
                sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                sudo chmod +x /usr/local/bin/docker-compose
                sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
                sudo git clone https://github.com/dihalk/devopstest2.git -b feature/tf-modules
                sudo docker-compose -f ${var.dcompose_files[count.index]} up -d
	EOF
  tags = {
    Name = "${var.server_name}-ec2-${count.index + 1}"
  }
}