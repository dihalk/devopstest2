#Create VPC in us-east-1
resource "aws_vpc" "vpc_devopstest" {
  provider             = aws.region-devopstest
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-devopstest"
  }
}

#Get all available AZ's in VPC for devopstest region
#data "aws_availability_zones" "azs_devopstest" {
#  provider = aws.region-devopstest
#  state    = "available"
#}

#Create public subnet in us-east-1a
resource "aws_subnet" "subnet_1_devopstest" {
  provider = aws.region-devopstest
  #availability_zone = element(data.aws_availability_zones.azs_devopstest.names, 0)
  availability_zone = var.availability_zones[0]
  vpc_id            = aws_vpc.vpc_devopstest.id
  cidr_block        = var.public_subnet_1_cidr
  tags = {
    Name = "subnet1_devopstest"
  }
}

#Create public subnet in us-east-1b
resource "aws_subnet" "subnet_2_devopstest" {
  provider = aws.region-devopstest
  #availability_zone = element(data.aws_availability_zones.azs_devopstest.names, 1)
  availability_zone = var.availability_zones[1]
  vpc_id            = aws_vpc.vpc_devopstest.id
  cidr_block        = var.public_subnet_2_cidr
  tags = {
    Name = "subnet2_devopstest"
  }
}

#Create route table for subnets
resource "aws_route_table" "rt_devopstest" {
  provider = aws.region-devopstest
  vpc_id   = aws_vpc.vpc_devopstest.id
  #route {
  #  cidr_block = "0.0.0.0/0"
  #  gateway_id = aws_internet_gateway.igw_devopstest.id
  #}
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "devopstest region rt"
  }
}

# Associate the newly created route tables to the subnets
resource "aws_route_table_association" "public_subnet_1_association" {
  provider       = aws.region-devopstest
  route_table_id = aws_route_table.rt_devopstest.id
  subnet_id      = aws_subnet.subnet_1_devopstest.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  provider       = aws.region-devopstest
  route_table_id = aws_route_table.rt_devopstest.id
  subnet_id      = aws_subnet.subnet_2_devopstest.id
}


#Create Internet Gateway for subnets
resource "aws_internet_gateway" "igw_devopstest" {
  provider = aws.region-devopstest
  vpc_id   = aws_vpc.vpc_devopstest.id
  tags = {
    Name = "igw-devopstest"
  }
}

#Route the public subnet traffic through the Internet Gateway
resource "aws_route" "public_internet_igw_route" {
  provider               = aws.region-devopstest
  route_table_id         = aws_route_table.rt_devopstest.id
  gateway_id             = aws_internet_gateway.igw_devopstest.id
  destination_cidr_block = "0.0.0.0/0"
}