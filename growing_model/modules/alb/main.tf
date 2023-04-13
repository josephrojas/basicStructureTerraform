
#########################################
#------------------ALB------------------#
#########################################
resource "aws_lb" "alb_workshop" {
  name               = "pragma-pdn-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = false

  tags_all = {
     "Name" = "pragma-pdn-alb",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
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
  vpc_id      = var.vpc
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
