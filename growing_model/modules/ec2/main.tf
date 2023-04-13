resource "aws_instance" "private_instance" {
    ami = "ami-0568773882d492fc8"
    instance_type = "t2.micro"
    //subnet_id = aws_subnet.privatesubnets.id
    subnet_id = var.subnet_id
    key_name = aws_key_pair.workshop_key_pair.key_name
    vpc_security_group_ids = var.security_group
    associate_public_ip_address = false
    tags = {
        Name = "private_instance"
    }
 }

 
