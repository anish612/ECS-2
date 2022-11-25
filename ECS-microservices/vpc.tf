# Creating VPC 
resource "aws_vpc" "testvpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = "true"
    tags = {
        Name = "testvpc"
    }  
}

#creating subnets to my VPC
resource "aws_subnet" "testsubnet-1" {
    vpc_id = aws_vpc.testvpc.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.0.0/24"
    tags = {
      "Name" = "testsubnet-1"
    } 
}

#creating another subnet

resource "aws_subnet" "testsubnet-2" {
    vpc_id = aws_vpc.testvpc.id
    availability_zone = "us-east-1b"
    cidr_block = "10.0.1.0/24"
    tags = {
      "Name" = "testsubnet-2"
    } 
}

#creating a route table
resource "aws_route_table" "test-route" {
    vpc_id = aws_vpc.testvpc.id
     route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }
    tags = {
      "Name" = "test-route"
    } 
}

#associating subnets to route table
resource "aws_route_table_association" "rtb-association-1" {
    subnet_id = aws_subnet.testsubnet-1.id
    route_table_id = aws_route_table.test-route.id
}


resource "aws_route_table_association" "rtb-association-2" {
    subnet_id = aws_subnet.testsubnet-2.id
    route_table_id = aws_route_table.test-route.id
}

#creating an internet gateway to VPC
resource "aws_internet_gateway" "test-igw" {
    vpc_id = aws_vpc.testvpc.id
    tags = {
      "Name" = "test-igw"
    } 
}