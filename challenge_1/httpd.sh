#! /bin/bash
sudo yum update
sudo yum install httpd mysql -y
systemctl start httpd
