#########################################
#------------------ALB------------------#
#########################################
resource "aws_lb" "alb_workshop" {
  name               = "pragma-mapa-crecimiento-pdn-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group_load_balancer.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]

  enable_deletion_protection = false

  tags_all = {
     "Name" = "pragma-mapa-crecimiento-pdn-alb",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
}

#########################################
#-------------TARGET-GROUP--------------#
#########################################

resource "aws_lb_target_group" "alb_workshop_target_group" {
  name        = "pragma-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.workshop_vpc.id
  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 10
    matcher = 200
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "listener_workshop" {
  load_balancer_arn = aws_lb.alb_workshop.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_workshop_target_group.arn
  }
}

