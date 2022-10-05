#Getting vpc
 data "aws_vpc" "joseph_rojas_vpc" { 
    tags = {
    Name = "joseph_rojas_vpc_lab"
   }
 }

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
   vpc_id =  data.aws_vpc.joseph_rojas_vpc.id
   cidr_block = "10.1.13.0/24"   
   tags = {
    Name = "joseph_rojas_psn_ec2"
   }      
 }
 
 resource "aws_subnet" "privatesubnets" {
   vpc_id =  data.aws_vpc.joseph_rojas_vpc.id
   cidr_block = "10.1.20.0/24"  
   tags = {
    Name = "joseph_rojas_private_ec2"
   }       
 }

data "aws_availability_zones" "available"{

}
#Creation of private subnets for BD
 resource "aws_subnet" "privatesubnet_db_1" {    
   vpc_id =  data.aws_vpc.joseph_rojas_vpc.id
   availability_zone = data.aws_availability_zones.available.names[1]
   cidr_block = "10.1.6.0/24"   
   tags = {
    Name = "joseph_rojas_rds_psn_1"
   }      
 }

 resource "aws_subnet" "privatesubnet_db_2" {    
   vpc_id =  data.aws_vpc.joseph_rojas_vpc.id
   availability_zone = data.aws_availability_zones.available.names[2]
   cidr_block = "10.1.7.0/24"   
   tags = {
    Name = "joseph_rojas_rds_psn_2"
   }      
 }

#Getting IGW
 data "aws_internet_gateway" "IGW" {    
    tags = {
        Name = "joseph_rojas_IGW"
    }            
 }

#Creation of route tables
 resource "aws_route_table" "PublicRT" {    
    vpc_id =  data.aws_vpc.joseph_rojas_vpc.id
    route {
        cidr_block = "0.0.0.0/0"               
        gateway_id = data.aws_internet_gateway.IGW.id
    }
    tags = {
    Name = "joseph_rojas_route_table"
   }
 }

 resource "aws_route_table" "PrivateRT" {    
    vpc_id =  data.aws_vpc.joseph_rojas_vpc.id
    route {
        cidr_block = "0.0.0.0/0"               
        nat_gateway_id  = aws_nat_gateway.NATgw.id
    }
    tags = {
    Name = "joseph_rojas_private_route_table"
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
   name = "test-rds"
   subnet_ids = [ aws_subnet.privatesubnet_db_1.id, aws_subnet.privatesubnet_db_2.id ]
   tags = {
     Name = "test-rds"
   }
 }