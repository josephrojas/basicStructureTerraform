#Using 10.0.0.0/16 as CIDR to VPC
resource "aws_vpc" "lamp_lab" {
  cidr_block = var.lamp_vpc_CIDR
  tags = {
    Name = "lamp-vpc"
  }
}



#Allocate public IP and NAT creation


resource "aws_eip" "ipNTG" {
tags = {
    Name = "lamp-eip"
}
}

resource "aws_nat_gateway" "NATgw" {
    allocation_id = aws_eip.ipNTG.id
    subnet_id = aws_subnet.lamp-pub-1a.id
    tags = {
        Name = "lamp-ntg"
    }
}

#Getting available zones
data "aws_availability_zones" "available" {

}

#Creation of subnets

resource "aws_subnet" "lamp-pub-1a" {
  vpc_id = aws_vpc.lamp_lab.id
  cidr_block = cidrsubnet(aws_vpc.lamp_lab.cidr_block, 8, 0)
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "lamp-pub-1a"
  }
}

resource "aws_subnet" "lamp-pub-1b" {
  vpc_id = aws_vpc.lamp_lab.id
  cidr_block = cidrsubnet(aws_vpc.lamp_lab.cidr_block, 8, 1)
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "lamp-pub-1b"
  }
}

resource "aws_subnet" "lamp-app-1a" {
  vpc_id = aws_vpc.lamp_lab.id
  cidr_block = cidrsubnet(aws_vpc.lamp_lab.cidr_block, 8, 2)
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "lamp-app-1a"
  }
}

resource "aws_subnet" "lamp-app-1b" {
  vpc_id = aws_vpc.lamp_lab.id
  cidr_block = cidrsubnet(aws_vpc.lamp_lab.cidr_block, 8, 3)
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "lamp-app-1b"
  }
}

resource "aws_subnet" "lamp-rds-1a" {
  vpc_id = aws_vpc.lamp_lab.id
  cidr_block = cidrsubnet(aws_vpc.lamp_lab.cidr_block, 8, 4)
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "lamp-rds-1a"
  }
}

resource "aws_subnet" "lamp-rds-1b" {
  vpc_id = aws_vpc.lamp_lab.id
  cidr_block = cidrsubnet(aws_vpc.lamp_lab.cidr_block, 8, 5)
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "lamp-rds-1b"
  }
}

#Creation of IGW
resource "aws_internet_gateway" "lamp-igw" {
    vpc_id = aws_vpc.lamp_lab.id
    tags = {
        Name = "lamp-igw"
    }
    
}

#Creation of route tables 
resource "aws_route_table" "lamp-pub-rt" {
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.lamp-igw.id
    }
    depends_on = [
      aws_internet_gateway.lamp-igw
    ]
    tags = {
        Name = "lamp-pub-rt"
    }
    
}

resource "aws_route_table" "lamp-app-rt" {
    route = {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.NATgw.id
    }
    depends_on = [
      aws_nat_gateway.NATgw
    ]
    tags = {
        Name = "lamp-app-rt"
    }
    
}

resource "aws_route_table" "lamp-rds-rt" {
    tags = {
        Name = "lamp-rds-rt"
    }  
}

#Associate subnets in route table

resource "aws_route_table_association" "lamp-pub-rt-association-1a" {
    subnet_id = aws_subnet.lamp-pub-1a.id
    route_table_id = aws_route_table.lamp-pub-rt.id
}

resource "aws_route_table_association" "lamp-pub-rt-association-1b" {
    subnet_id = aws_subnet.lamp-pub-1b.id
    route_table_id = aws_route_table.lamp-pub-rt.id
}

resource "aws_route_table_association" "lamp-app-rt-association-1a" {
    subnet_id = aws_subnet.lamp-app-1a.id
    route_table_id = aws_route_table.lamp-app-rt.id
}

resource "aws_route_table_association" "lamp-app-rt-association-1b" {
    subnet_id = aws_subnet.lamp-app-1b.id
    route_table_id = aws_route_table.lamp-app-rt.id
}

resource "aws_route_table_association" "lamp-rds-rt-association-1a" {
    subnet_id = aws_subnet.lamp-rds-1a.id
    route_table_id = aws_route_table.lamp-rds-rt.id
}

resource "aws_route_table_association" "lamp-rds-rt-association-1b" {
    subnet_id = aws_subnet.lamp-rds-1b.id
    route_table_id = aws_route_table.lamp-rds-rt.id
}

#Creation of subnet groups
resource "aws_db_subnet_group" "lamp-rds-group" {
   name = "lamp-rds-group"
   subnet_ids = [ aws_subnet.lamp-rds-1a.id, aws_subnet.lamp-rds-1b.id]
   tags = {
     Name = "lamp-rds-group"
   }
 }