region = "us-east-2"

main_vpc_cidr = "10.0.0.0/16"

vpc_dns_hostname = true

private_subnets = 2

public_subnets = 2

data_subnets = 2

ami_launch_template = "ami-05bfbece1ed5beb54"

instance_type = "t2.micro"

capacity = {
  desired_capacity = 2
  max_size         = 4
  min_size         = 2
}

sg_config = [{
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "TCP rule"
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
  }]
  egress = [{
    description      = "Outbound rule"
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]
  name = "pragma-modelo-crecimiento-pdn-sg-lt"
  }
  ,
  {
    name = "pragma-modelo-crecimiento-pdn-sg-lb"

    ingress = [{
      from_port        = 80
      description      = "HTTP rule"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      to_port          = 80
    }]
    egress = [{
      description      = "Outbound rule"
      cidr_blocks      = ["0.0.0.0/0"]
      from_port        = 0
      protocol         = "-1"
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }]
  },
  {
    name = "pragma-modelo-crecimiento-pdn-sg-rds"
    ingress = [
      {
        from_port        = 3306
        protocol         = "tcp"
        description      = "TCP rule"
        cidr_blocks      = []
        to_port          = 3306
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
    }]
    egress = [{
      description      = "Outbound rule"
      cidr_blocks      = ["0.0.0.0/0"]
      from_port        = 0
      protocol         = "-1"
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }]
}]

create_association = 1

bucket_name = "pragma-modelo-crecimiento-pdn-s3-front"

objects = [{
  content_type = "application/javascript"
  key          = "app.js"
  source       = "./modules/s3/objects/app.js"
  }, {
  content_type = "text/html"
  key          = "index.html"
  source       = "./modules/s3/objects/index.html"
  }, {
  content_type = "text/css"
  key          = "style.css"
  source       = "./modules/s3/objects/style.css"
}]


cloudfront_origin = "modelo-crecimiento"

acl_name = "pragma-modelo-crecimiento-pdn-acl"

scope = "CLOUDFRONT"


#########################################
#-------------------RDS-----------------#
#########################################

rds_config = [{
  allocated_storage = 20
  db_name           = "rdsModeloCrecimiento"
  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t3.micro"
  port              = 3306
  multi_az          = true
}]

credentials = [{
  password = "lab-rds-master"
  username = "master"
}]

proxy_conf = []

#########################################
#-------------SECRETS-MANAGER-----------#
#########################################

secrets = [{
  name = "rds-credential1"
  secret = {
    password = "lab-rds-master"
    username = "master"
  }
}]

dashboard_name = "dashboard-solution"

#########################################
#-------------------IAM-----------------#
#########################################

policies = [{
  description = "Politica para logs"
  name        = "lambda-policy"
}]

document = {
  actions = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"]
  effect    = "Allow"
  resources = ["arn:aws:logs:*:*:*"]
}

#########################################
#----------------LAMBDA-----------------#
#########################################

function_conf = [{
  code_name     = "hello_world"
  function_name = "lambda_auth"
  runtime       = "python3.8"
}]
