terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.33.0"
    }
  }
  backend "s3" {
    bucket         = "dileep-webapp-demo"
    key            = "dileep/terraform/remote/s3/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "dynamodb-state-locking"

  }
}
provider "aws" {
  # Configuration options
  region = "ap-south-1"

}

#creating the vpc infra
resource "aws_vpc" "demo-vpc" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "demo_vpc"
  }
}

#creating the subnets
resource "aws_subnet" "subnet-1a" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-1a"
  }
}

resource "aws_subnet" "subnet-1b" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-1b"
  }
}






#creating Internet Gateway
resource "aws_internet_gateway" "Demo_IG" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "Demo_IG"
  }
}


#creating route table
resource "aws_route_table" "webapp-route-table" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Demo_IG.id
  }

  tags = {
    Name = "webapp-route-table"
  }
}

#create route table association
resource "aws_route_table_association" "webapp-RT-association-1A" {
  subnet_id      = aws_subnet.subnet-1a.id
  route_table_id = aws_route_table.webapp-route-table.id
}

resource "aws_route_table_association" "webapp-RT-association-1B" {
  subnet_id      = aws_subnet.subnet-1b.id
  route_table_id = aws_route_table.webapp-route-table.id
}

#creating target group for LB
resource "aws_lb_target_group" "Webapp-LB-target-group" {
  name     = "Webapp-LB-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo-vpc.id

}

#Creating LB group attachment
resource "aws_lb_target_group_attachment" "Webapp-LB-target-group-attachment-1" {
  target_group_arn = aws_lb_target_group.Webapp-LB-target-group.arn
  target_id        = aws_instance.backend_server.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "Webapp-LB-target-group-attachment-2" {
  target_group_arn = aws_lb_target_group.Webapp-LB-target-group.arn
  target_id        = aws_instance.frontend_server.id
  port             = 80
}

#creating the load balancer
resource "aws_lb" "Webapp-LB1" {
  name               = "Webapp-LB1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-80-for-LB.id]
  subnets            = [aws_subnet.subnet-1a.id, aws_subnet.subnet-1b.id]

  #enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

# creating the listener

resource "aws_lb_listener" "webapp-LB-listener" {
  load_balancer_arn = aws_lb.Webapp-LB1.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Webapp-LB-target-group.arn
  }
}

