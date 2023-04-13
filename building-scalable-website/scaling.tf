#########################################
#-----------------AMI-------------------#
#########################################
data "aws_ami" "amazon_2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}
#########################################
#------------LAUNCH-TEMPLATE------------#
#########################################

resource "aws_launch_template" "launch_template_workshop" {
  name = "pragma-mapa-crecimiento-pdn-launch-template"
  description = "Launch template para el workshop"
  image_id = "ami-05bfbece1ed5beb54"
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.security_group_template.id]
  key_name = aws_key_pair.workshop_key_pair.key_name 
  user_data = filebase64("user_data.sh")
  update_default_version = true
  instance_initiated_shutdown_behavior = "terminate"

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
     "Name" = "pragma-mapa-crecimiento-pdn-ec2-webserver",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
  }

  tags_all = {
     "Name" = "pragma-mapa-crecimiento-pdn-launch-template-webserver",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
}

#########################################
#--------------AUTO-SCALING-------------#
#########################################

resource "aws_autoscaling_group" "autoscaling_workshop" {
  name = "pragma-mapa-crecimiento-pdn-autoscaling-group"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  vpc_zone_identifier  = aws_subnet.private_subnets.*.id
  
  health_check_type = "EC2"
  health_check_grace_period = 300 # default is 300 seconds  
  # Launch Template
  launch_template {
    id      = aws_launch_template.launch_template_workshop.id
    version = "$Latest"
  }
  
}

resource "aws_autoscaling_attachment" "asg_attachment_workshop" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling_workshop.id
  lb_target_group_arn = aws_lb_target_group.alb_workshop_target_group.arn
}

#########################################
#------------AUTO-SCALING-GP------------#
#########################################

resource "aws_autoscaling_policy" "autoscaling_policy" {
  name                   = "pragma-mapa-crecimiento-pdn-autoscaling-group-policy"
  autoscaling_group_name = aws_autoscaling_group.autoscaling_workshop.name
  estimated_instance_warmup = 200
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}