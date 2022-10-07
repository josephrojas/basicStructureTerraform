#Create VPC, user this if is necesary to create a new VPC
resource "aws_vpc" "main_vpc" {                # Creating VPC here
   cidr_block       = var.main_vpc_cidr     
 }
#Getting vpc use this if VPC already exists
# data "aws_vpc" "main_vpc" { 
#    tags = {
#    Name = "name_vpc"
#   }
# }

#allocate public IP and creat NAT
resource "aws_eip" "ipNTG" {
    vpc = true
    
 }
 resource "aws_nat_gateway"  "NATgw"{
    allocation_id = aws_eip.ipNTG.id
    subnet_id = aws_subnet.publicsubnets.id
 }

 #Creation of public and private subnets for EC2
 resource "aws_subnet" "publicsubnets" {    
   vpc_id =  aws_vpc.main_vpc.id
   cidr_block =  cidrsubnet(aws_vpc.main_vpc.cidr_block,8,var.publicSubnetEC2)
   tags = {
    Name = "name_public_subntet_ec2"
   }      
 }
 
 resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.main_vpc.id
   cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block,8,var.privateSubnetEC2)
   tags = {
    Name = "name_private_subnet_ec2"
   }       
 }

data "aws_availability_zones" "available"{

}

#Creation of private subnets for BD
 resource "aws_subnet" "privatesubnet_db_1" {    
   vpc_id =  aws_vpc.main_vpc.id
   availability_zone = data.aws_availability_zones.available.names[1]
   cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block,8,3)
   tags = {
    Name = "joseph_rojas_rds_psn_1"
   }      
 }

 resource "aws_subnet" "privatesubnet_db_2" {    
   vpc_id =  aws_vpc.main_vpc.id
   availability_zone = data.aws_availability_zones.available.names[2]
   cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block,8,4)
   tags = {
    Name = "joseph_rojas_rds_psn_2"
   }      
 }

 

#Getting IGW, use this in case of existing IGW
# data "aws_internet_gateway" "IGW" {    
#    tags = {
#        Name = "name_IGW"
#    }            
# }
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "name_IGW"
  }
}

#Creation of route tables
 resource "aws_route_table" "PublicRT" {    
    vpc_id =  aws_vpc.main_vpc.id
    route {
        cidr_block = "0.0.0.0/0"               
        gateway_id = aws_internet_gateway.IGW.id
    }
    depends_on = [
      aws_internet_gateway.IGW
    ]
    tags = {
    Name = "name_public_route_table"
   }
 }

 resource "aws_route_table" "PrivateRT" {    
    vpc_id =  aws_vpc.main_vpc.id
    route {
        cidr_block = "0.0.0.0/0"               
        nat_gateway_id  = aws_nat_gateway.NATgw.id
    }
    depends_on = [
      aws_nat_gateway.NATgw
    ]
    tags = {
    Name = "name_private_route_table"
   }
 }

  #Asociate subnets in route table
 resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }

 resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.PrivateRT.id
 }
 
 #Creation of subnet groups
resource "aws_db_subnet_group" "subnet_group_joseph" {
   name = "rds-group"
   subnet_ids = [ aws_subnet.privatesubnet_db_1.id, aws_subnet.privatesubnet_db_2.id ]
   tags = {
     Name = "rds-group"
   }
 }