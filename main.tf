# Provider configuration (using default AWS credentials)
provider "aws" {
  region = var.aws_region
}

# Creating VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
}

# Creating Subnet within VPC
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.subnet_cidr
}

# Creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Creating route table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"  # any traffic heading to the internet
    gateway_id = aws_internet_gateway.igw.id  # to route the traffic use internet gateway
  }
}

# Creating route table association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt.id
}

# Creating security group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow inbound traffic for HTTP and SSH"
  vpc_id      = aws_vpc.main_vpc.id  # Make sure it's associated with the right VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating EC2 instance
resource "aws_instance" "web"{
    ami                    = "ami-0c02fb55956c7d316"  # Ubuntu AMI
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.public_subnet.id
    associate_public_ip_address = true
    security_groups        = [aws_security_group.web_sg.name]
    depends_on = [
        aws_security_group.web_sg,    # Ensure security group is created first
        aws_subnet.public_subnet,     # Ensure subnet is created
        aws_vpc.main_vpc,             # Ensure VPC is created
        aws_internet_gateway.igw     # Ensure internet gateway is available
        
     ]
    tags = {
        Name = "Test-EC2-Instance"
    }
    # Install Apache via user data
    user_data = <<-EOF
            #!/bin/bash
              sudo apt update
              sudo apt install apache2 -y
              sudo systemctl enable apache2
              sudo systemctl start apache2
              
        EOF
}
  

# Output the web URL to access the EC2 instance
output "web_url" {
  value = "http://${aws_instance.web.public_ip}"
}

