provider "aws" {
    region = "us-east-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_vpc" "vpc1" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.0.0/16"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_route_table" "RT1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "RTA" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.RT1.id
}

resource "aws_security_group" "sg1" {
  name = "sg1"
  vpc_id = aws_vpc.vpc1.id

ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

}

tags = {
    Name = "sg1"
  }
}

resource "aws_key_pair" "kp1" {
  key_name = "kp1"
  public_key = file("C:/Users/hf/.ssh/id_rsa.pub")
}

resource "aws_instance" "server" {
    ami = "ami-0b6d9d3d33ba97d99"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.sub1.id
    vpc_security_group_ids = [aws_security_group.sg1.id]
    key_name = aws_key_pair.kp1.key_name

connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("C:/Users/hf/.ssh/id_rsa")
    host = self.public_ip
}
provisioner "file" {
  source = "app.py"
  destination = "/home/ubuntu/app.py"
}
provisioner "remote-exec" {
  inline = [ 
    "echo 'Hello from the remote exec'",
    "sudo apt update -y",
    "sudo apt-get install python3-pip -y",
    "cd /home/ubuntu",
    "sudo apt install python3-flask -y",
    "snohup sudo python3 /home/ubuntu/app.py > /home/ubuntu/flask.log 2>&1 &",
   ]
}

}