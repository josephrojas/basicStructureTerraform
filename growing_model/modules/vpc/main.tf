#########################################
#---------------VPC---------------------#
#########################################
resource "aws_vpc" "vpc_services" {                
   cidr_block       = var.main_vpc_cidr  
   enable_dns_hostnames = var.vpc_dns_hostname
   tags = {
     "Name" = "pragma-modelo-crecimiento-pdn-vpc",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
}

#########################################
#---------------NAT---------------------#
#########################################
resource "aws_eip" "elastic_ip" {
    vpc = true #Optional
    tags = {
     "Name" = "pragma-modelo-crecimiento-pdn-elastic-ip",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
}

resource "aws_nat_gateway"  "nat_gw"{
    allocation_id = aws_eip.elastic_ip.id
    subnet_id = aws_subnet.public_subnets[0].id
    tags = {
     "Name" = "pragma-modelo-crecimiento-pdn-nat-gateway",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
}

#########################################
#---------------IGW---------------------#
#########################################

resource "aws_internet_gateway" "ig_workshop" {
  vpc_id = aws_vpc.vpc_services.id
  tags = {
     "Name" = "pragma-modelo-crecimiento-pdn-internet-gateway",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
}


#########################################
#---------------SUBNET------------------#
#########################################
data "aws_availability_zones" "available"{

}

resource "aws_subnet" "public_subnets" {    
   vpc_id =  aws_vpc.vpc_services.id
   count = var.public_subnets
   cidr_block =  cidrsubnet(aws_vpc.vpc_services.cidr_block,4,count.index)
   availability_zone = data.aws_availability_zones.available.names[count.index]
   tags = {
     "Name" = "pragma-modelo-crecimiento-pdn-public-subnet-${count.index + 1}",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }    
}
 
resource "aws_subnet" "private_subnets" {    
   vpc_id =  aws_vpc.vpc_services.id
   count = var.private_subnets
   cidr_block =  cidrsubnet(aws_vpc.vpc_services.cidr_block,4,count.index + var.private_subnets)
   availability_zone = data.aws_availability_zones.available.names[count.index]
   tags = {
     "Name" = "pragma-modelo-crecimiento-pdn-private-subnet-${count.index + 1}",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
}


resource "aws_subnet" "data_subnets" {    
   vpc_id =  aws_vpc.vpc_services.id
   count = var.data_subnets
   cidr_block =  cidrsubnet(aws_vpc.vpc_services.cidr_block,4,count.index + var.data_subnets + 2)
   availability_zone = data.aws_availability_zones.available.names[count.index]
   tags = {
     "Name" = "pragma-modelo-crecimiento-pdn-data-subnet-${count.index + 1}",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
}

#########################################
#-------------ROUTE-TABLES--------------#
#########################################

resource "aws_route_table" "public_route_table" {    
    vpc_id =  aws_vpc.vpc_services.id

    route {
        cidr_block = "0.0.0.0/0"               
        gateway_id = aws_internet_gateway.ig_workshop.id
    }
    depends_on = [
      aws_internet_gateway.ig_workshop
    ]
    tags = {
     "Name" = "pragma-modelo-crecimiento-pdn-public-route-table",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
     "provisioned" = "terraform",
     "cost-center" = "9904"
    }
}

resource "aws_route_table" "private_route_table" {    
    vpc_id =  aws_vpc.vpc_services.id
    route {
        cidr_block = "0.0.0.0/0"               
        nat_gateway_id  = aws_nat_gateway.nat_gw.id
    }
    depends_on = [
      aws_nat_gateway.nat_gw
    ]
    tags = {
     "Name" = "pragma-modelo-crecimiento-pdn-private-route-table",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
     "provisioned" = "terraform",
     "cost-center" = "9904"
    }
}

#########################################
#----------SUBNET-ASSOCIATION-----------#
#########################################

resource "aws_route_table_association" "public_rt_association" {
    count = var.public_subnets
    subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_rt_association" {
    count = var.private_subnets
    subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
    route_table_id = aws_route_table.private_route_table.id
    
}


#########################################
#-------------SUBNET-GROUP--------------#
#########################################
resource "aws_db_subnet_group" "subnet_group_data" {
    count = var.data_subnets > 0 ? 1 : 0
    name = "pragma-modelo-crecimiento-pdn-subnet-group"
    subnet_ids =  tolist(aws_subnet.data_subnets.*.id)
    depends_on = [
     aws_subnet.data_subnets
    ]
    tags = {
     "Name" = "pragma-modelo-crecimiento-pdn-subnet-group",
     "environment" = "pdn",
     "project-name" = "modelo-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "cloud-ops",
     "provisioned" = "terraform",
     "cost-center" = "9904"
    }
 }

