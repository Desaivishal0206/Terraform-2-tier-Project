# create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true
  enable_dns_support =  true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}
# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet pub_sub_1a in Nat gateway will be there
resource "aws_subnet" "pub_sub_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_1a_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public_subnet_1a_Natgateway"
  }
}

# create public subnet pub_sub_2a in Nat gateway will be there
resource "aws_subnet" "pub_sub_2b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_2b_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public_subnet_2b_Natgateway"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "Public-rt"
  }
}

# associate public subnet pub-sub-1a to public route table
resource "aws_route_table_association" "pub-sub-1a_route_table_association" {
  subnet_id           = aws_subnet.pub_sub_1a.id
  route_table_id      = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "pub-sub-2-b_route_table_association" {
  subnet_id           = aws_subnet.pub_sub_2b.id
  route_table_id      = aws_route_table.public_route_table.id
}

# create private app subnet pri-sub-3a  private-subnet-3a-forEC2
resource "aws_subnet" "pri_sub_3a" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_3a_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private-subnet-3a-forEC2"
  }
}

# create private app pri-sub-4b  private-subnet-4b-for-EC2
resource "aws_subnet" "pri_sub_4b" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_4b_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private-subnet-4b-for-EC2"
  }
}

# create private data subnet pri-sub-5a private-subnet-5a-for-RDS
resource "aws_subnet" "pri_sub_5a" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_5a_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private-subnet-5a-for-RDS"
  }
}

# create private data subnet private-subnet-6b-for-RDS
resource "aws_subnet" "pri_sub_6b" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_6b_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private-subnet-6b-for-RDS"
  }
}