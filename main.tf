resource "aws_vpc" "bisoye" {
  cidr_block       = "192.168.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "bisoye-infrastructure"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.bisoye.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.bisoye.id
  cidr_block = "192.168.0.0/28"

  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "public" {
  vpc_id                 = aws_vpc.bisoye.id
  cidr_block             = "192.168.0.16/28"
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.bisoye.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id

    }
    tags = {
        name = "public-route-table"
    }
}

resource "aws_route_table_association" "subnet_association" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "http"
  vpc_id      = aws_vpc.bisoye.id

  ingress {
    description      = "http traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
}






