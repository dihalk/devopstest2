#Create SG for app1 allowing TCP/8000 from *, TCP/22 from my IP in us-east-1
resource "aws_security_group" "app1_sg_devopstest" {
  provider    = aws.region-devopstest
  name        = "app1-sg-devopstest"
  description = "Allow TCP/8000 & TCP/22"
  vpc_id      = aws_vpc.vpc_devopstest.id
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
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow port 3306 from us-east-1b subnet"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create SG for app2 allowing TCP/8000 from *, TCP/22 from my IP in us-east-1
resource "aws_security_group" "app2_sg_devopstest" {
  provider    = aws.region-devopstest
  name        = "app2-sg-devopstest"
  description = "Allow TCP/8000 & TCP/22"
  vpc_id      = aws_vpc.vpc_devopstest.id
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
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow port 3306 from us-east-1a subnet"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create SG for LB, only TCP/80 and access to app-sgs
resource "aws_security_group" "lb_sg_devopstest" {
  provider    = aws.region-devopstest
  name        = "lb-sg-devopstest"
  description = "Allow 443,80 and traffci to devopstest SG"
  vpc_id      = aws_vpc.vpc_devopstest.id
  ingress {
    description = "Allow 80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "Allow traffic to app-sgs"
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    security_groups = [aws_security_group.app1_sg_devopstest.id, aws_security_group.app2_sg_devopstest.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}





