resource "aws_cloudwatch_dashboard" "dashboard" {
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
          [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${var.autoscaling_name}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-2",
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
          [ "AWS/AutoScaling", "GroupTotalInstances", "AutoScalingGroupName", "${var.autoscaling_name}"]
        ],
        "stat": "Average",
        "region": "us-east-2",
        "view": "singleValue",
        "title": "Number of instances"
      }
    }
  ]
  }
  EOF
}
