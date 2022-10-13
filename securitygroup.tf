
#creating security group
resource "aws_security_group" "allow_80_22" {
  name        = "allow-port-22-and-port-80"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    description = "allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_HTTP_SSH"
  }
}


#creating SG for LB
resource "aws_security_group" "allow-80-for-LB" {
  name        = "allow-port-80"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.demo-vpc.id



  ingress {
    description = "allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_HTTP"
  }
}