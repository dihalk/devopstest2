resource "aws_lb" "django_application_lb" {
  provider           = aws.region-devopstest
  name               = "django-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg_devopstest.id]
  subnets            = [aws_subnet.subnet_1_devopstest.id, aws_subnet.subnet_2_devopstest.id]
  tags = {
    Name = "Django-LB"
  }
}

resource "aws_lb_target_group" "django_lb_tg" {
  provider    = aws.region-devopstest
  name        = "django-lb-tg"
  port        = 8000
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_devopstest.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = 8000
    protocol = "HTTP"
    matcher  = "200"
  }
  tags = {
    Name = "Django-target-group"
  }
}

resource "aws_lb_listener" "django_listener_http" {
  provider          = aws.region-devopstest
  load_balancer_arn = aws_lb.django_application_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.django_lb_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "django_app1_attach" {
  provider         = aws.region-devopstest
  target_group_arn = aws_lb_target_group.django_lb_tg.arn
  target_id        = aws_instance.ec2_app1.id
  port             = 8000
}

resource "aws_lb_target_group_attachment" "django_app2_attach" {
  provider         = aws.region-devopstest
  target_group_arn = aws_lb_target_group.django_lb_tg.arn
  target_id        = aws_instance.ec2_app2.id
  port             = 8000
}
