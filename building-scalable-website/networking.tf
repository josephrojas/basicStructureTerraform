#########################################
#----------.----VPC---------------------#
#########################################
resource "aws_vpc" "workshop_vpc" {                # Creating VPC here
   cidr_block       = var.main_vpc_cidr  
   enable_dns_hostnames = var.vpc_dns_hostname
   tags = {
     "Name" = "pragma-mapa-crecimiento-pdn-vpc",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
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
     "Name" = "pragma-mapa-crecimiento-pdn-elastic-ip",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
}

resource "aws_nat_gateway"  "nat_gw"{
    allocation_id = aws_eip.elastic_ip.id
    subnet_id = aws_subnet.public_subnets[0].id
    tags = {
     "Name" = "pragma-mapa-crecimiento-pdn-nat-gateway",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
}

#########################################
#---------------IGW---------------------#
#########################################

resource "aws_internet_gateway" "ig_workshop" {
  vpc_id = aws_vpc.workshop_vpc.id
  tags = {
     "Name" = "pragma-mapa-crecimiento-pdn-internet-gateway",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
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
   vpc_id =  aws_vpc.workshop_vpc.id
   count = var.public_subnets
   cidr_block =  cidrsubnet(aws_vpc.workshop_vpc.cidr_block,4,count.index)
   availability_zone = data.aws_availability_zones.available.names[count.index]
   tags = {
     "Name" = "pragma-mapa-crecimiento-pdn-public-subnet-${count.index + 1}",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }    
}
 
resource "aws_subnet" "private_subnets" {    
   vpc_id =  aws_vpc.workshop_vpc.id
   count = var.private_subnets
   cidr_block =  cidrsubnet(aws_vpc.workshop_vpc.cidr_block,4,count.index + var.private_subnets)
   availability_zone = data.aws_availability_zones.available.names[count.index]
   tags = {
     "Name" = "pragma-mapa-crecimiento-pdn-private-subnet-${count.index + 1}",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
     "provisioned" = "terraform",
     "cost-center" = "9904"
   }
}

#########################################
#-------------ROUTE-TABLES--------------#
#########################################

resource "aws_route_table" "public_route_table" {    
    vpc_id =  aws_vpc.workshop_vpc.id

    route {
        cidr_block = "0.0.0.0/0"               
        gateway_id = aws_internet_gateway.ig_workshop.id
    }
    depends_on = [
      aws_internet_gateway.ig_workshop
    ]
    tags = {
     "Name" = "pragma-mapa-crecimiento-pdn-public-route-table",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
     "provisioned" = "terraform",
     "cost-center" = "9904"
    }
}

resource "aws_route_table" "private_route_table" {    
    vpc_id =  aws_vpc.workshop_vpc.id
    route {
        cidr_block = "0.0.0.0/0"               
        nat_gateway_id  = aws_nat_gateway.nat_gw.id
    }
    depends_on = [
      aws_nat_gateway.nat_gw
    ]
    tags = {
     "Name" = "pragma-mapa-crecimiento-pdn-private-route-table",
     "environment" = "pdn",
     "project-name" = "mapa-de-crecimiento",
     "owner" = "Joseph-Rojas",
     "area" = "talent-pool",
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
