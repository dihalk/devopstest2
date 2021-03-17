provider "aws" {
  region = "us-east-1"
}

module "djangoserver" {
  source = "./modules/djangoserver"
}

resource "aws_lb" "lb_main" {
  name               = var.lb_name
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [module.djangoserver.subnet1_id, module.djangoserver.subnet2_id]
  tags = {
    Name = "${var.server_name}-lb"
  }
}

resource "aws_lb_target_group" "lb_tg_main" {
  name        = var.lb_tg_name
  port        = var.lb_tg_port
  target_type = var.lb_tg_type
  vpc_id      = module.djangoserver.vpc_id
  protocol    = var.lb_protocol
  health_check {
    enabled  = var.health_check_enabled
    interval = var.health_check_interval
    path     = var.health_check_path
    port     = var.health_check_port
    protocol = var.lb_protocol
    matcher  = var.lb_matcher
  }
  tags = {
    Name = "${var.server_name}-lb-tg"
  }
}

resource "aws_lb_listener" "django_listener_http" {
  load_balancer_arn = aws_lb.lb_main.arn
  port              = var.lb_listner_port
  protocol          = var.lb_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_main.arn
  }
}

resource "aws_lb_target_group_attachment" "lb_target_grp_1" {

  target_group_arn = aws_lb_target_group.lb_tg_main.arn
  target_id        = module.djangoserver.ec2_1_instance_id
  port             = var.lb_tg_group_att_port
}

resource "aws_lb_target_group_attachment" "lb_target_grp_2" {

  target_group_arn = aws_lb_target_group.lb_tg_main.arn
  target_id        = module.djangoserver.ec2_2_instance_id
  port             = var.lb_tg_group_att_port
}


#Create SG for LB, only TCP/80 and access to app-sgs
resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "Allow 80 traffic"
  vpc_id      = module.djangoserver.vpc_id
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
    security_groups = [module.djangoserver.ec2_1_instance_sg, module.djangoserver.ec2_2_instance_sg]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}