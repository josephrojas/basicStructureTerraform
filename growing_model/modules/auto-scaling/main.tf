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

resource "aws_launch_template" "launch_template" {
  name = "pragma-modelo-crecimiento-pdn-launch-template"
  description = "Launch template para el workshop"
  image_id = var.ami_launch_template
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_groups
  key_name = var.key_name
  user_data = filebase64("./modules/auto-scaling/user_data.sh")
  update_default_version = true
  instance_initiated_shutdown_behavior = "terminate"

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
     "Name" = "pragma-modelo-crecimiento-pdn-ec2-webserver",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
  }

  tags_all = {
     "Name" = "pragma-modelo-crecimiento-pdn-launch-template-webserver",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
}

#########################################
#--------------AUTO-SCALING-------------#
#########################################

resource "aws_autoscaling_group" "autoscaling_workshop" {
  name = "pragma-modelo-crecimiento-pdn-autoscaling-group"
  desired_capacity   = var.capacity.desired_capacity
  max_size           = var.capacity.max_size
  min_size           = var.capacity.min_size
  vpc_zone_identifier  = var.subnets
  
  health_check_type = "EC2"
  health_check_grace_period = 300 # default is 300 seconds  
  # Launch Template
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  
}


resource "aws_autoscaling_attachment" "asg_attachment_workshop" {
  count = var.create_association > 0 ? 1 : 0
  autoscaling_group_name = aws_autoscaling_group.autoscaling_workshop.id
  lb_target_group_arn = var.target_group
}


#########################################
#------------AUTO-SCALING-GP------------#
#########################################

/*
resource "aws_autoscaling_policy" "autoscaling_policy" {
  name                   = "pragma-modelo-crecimiento-pdn-autoscaling-group-policy"
  autoscaling_group_name = aws_autoscaling_group.autoscaling_workshop.name
  estimated_instance_warmup = 200
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}
*/
