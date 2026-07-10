resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames   = true
    enable_dns_support     = true

    tags = {
        Name = "3-tier-app-vpc"
    }
}

# create public subnet AZ1
resource "aws_subnet" "public1" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "public-subnet-az1"
    }
}

# create public subnet AZ2
resource "aws_subnet" "public2" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"

    tags = {
        Name = "public-subnet-az2"
    }
}

# create apptier private AZ1
resource "aws_subnet" "app1" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.11.0/24"
    availability_zone = "us-east-1a"    

    tags = {
        Name = "app-subnet-az1"
    }
}   

# create apptier private AZ2
resource "aws_subnet" "app2" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.12.0/24"
    availability_zone = "us-east-1b"

    tags = {
        Name = "app-subnet-az2"
    }
}   

# Database tier private subnets AZ1
resource "aws_subnet" "db1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "db-subnet-az1"
  }
}

# Database tier private subnets AZ2
resource "aws_subnet" "db2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.22.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "db-subnet-az2"
  }
}

# create internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    
  tags = {
        Name = "3-tier-app-igw"
    }
}

# create public route table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "public-rt"
    }
}

# create route to internet gateway
resource "aws_route" "public_to_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# associate public subnets with public route table
resource "aws_route_table_association" "public1" {
    subnet_id      = aws_subnet.public1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
    subnet_id      = aws_subnet.public2.id
    route_table_id = aws_route_table.public.id
}