resource "aws_vpc" "mandala" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.vpc_name}"
    Owner       = "Sreeharsha Veerapalli"
    environment = "${var.env}"
  }
}
resource "aws_internet_gateway" "kiriti" {
  vpc_id = aws_vpc.mandala.id
  tags = {
    Name = "${var.IGW_name}"
  }
}
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.mandala.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.public_subnet1_name}"
  }
}
resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.mandala.id
  cidr_block        = var.public_subnet2_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.public_subnet2_name}"
  }
}
resource "aws_subnet" "subnet3" {
  vpc_id            = aws_vpc.mandala.id
  cidr_block        = var.public_subnet3_cidr
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.public_subnet3_name}"
  }
}
resource "aws_route_table" "kiriti" {
  vpc_id = aws_vpc.mandala.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kiriti.id
  }

  tags = {
    Name = "${var.Main_Routing_Table}"
  }
}

resource "aws_route_table_association" "terraform-public-1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.kiriti.id
}
resource "aws_route_table_association" "terraform-public-2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.kiriti.id
}
resource "aws_route_table_association" "terraform-public-3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.kiriti.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.mandala.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}