#creating ec2 instance on our vpc and our subnet

resource "aws_instance" "frontend_server" {
  #ami                   = "ami-062f7200baf2fa504"
  ami                    = "ami-062df10d14676e201"
  key_name               = "FirstKeyPair"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet-1a.id
  vpc_security_group_ids = [aws_security_group.allow_80_22.id]

  tags = {
    Name  = "terraform provided ec2"
    App   = "frontend"
    Owner = "dileep"
  }
}

resource "aws_instance" "backend_server" {
  #ami                   = "ami-062f7200baf2fa504"
  ami                    = "ami-062df10d14676e201"
  key_name               = "FirstKeyPair"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet-1b.id
  vpc_security_group_ids = [aws_security_group.allow_80_22.id]

  tags = {
    Name  = "terraform provided ec2 backend server"
    App   = "backend"
    Owner = "dileep"
  }
}