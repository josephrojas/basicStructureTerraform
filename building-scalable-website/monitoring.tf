#########################################
#--------------CLOUDWATCH---------------#
#########################################
resource "aws_cloudwatch_dashboard" "dashboard_workshop" {
  dashboard_name = var.dashboard_name
  dashboard_body = <<EOF
  {
    "widgets" : [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${aws_autoscaling_group.autoscaling_workshop.name}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "EC2 Instance CPU"
      }
    },
    {
      "type": "metric",
      "x": 13,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/AutoScaling", "GroupTotalInstances", "AutoScalingGroupName", "${aws_autoscaling_group.autoscaling_workshop.name}"]
        ],
        "stat": "Average",
        "region": "us-east-1",
        "view": "singleValue",
        "title": "Number of instances"
      }
    }
  ]
  }
  EOF
}
