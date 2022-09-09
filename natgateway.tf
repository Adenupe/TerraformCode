# CREATE ELASTIC IPs
resource "aws_eip" "EIP1" {
  vpc      = true

  tags  = {
    Name  = "Elastic IP Address 1"
  }
}

resource "aws_eip" "EIP2" {
  vpc      = true

  tags  = {
    Name  = "Elastic IP Address 2"
  }
}

# CREATE NAT GATEWAYS
resource "aws_nat_gateway" "NATGateway1" {
  allocation_id     = aws_eip.EIP1.id
  subnet_id         = aws_subnet.PublicSubnet1.id

  tags = {
    Name = "NAT Gateway | PublicSubnet1"
  }
}

resource "aws_nat_gateway" "NATGateway2" {
  allocation_id     = aws_eip.EIP2.id
  subnet_id         = aws_subnet.PublicSubnet2.id

  tags = {
    Name = "NAT Gateway | PublicSubnet2"
  }
}

# CREATE PRIVATE ROUTE TABLES
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "aws_nat_gateway.NATGateway1.id"
  }

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table" "PrivateRT2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "aws_nat_gateway.NATGateway2.id"
  }

  tags = {
    Name = "Private Route Table 2"
  }
}

# CREATE SUBNET-ROUTE TABLE ASSOCIATIONS
resource "aws_route_table_association" "PrivateSubnet1RouteTableAssociation" {
  route_table_id        = aws_route_table.PrivateRT.id
  subnet_id             = aws_subnet.PublicSubnet1.id
}

resource "aws_route_table_association" "PrivateSubnet1RouteTableAssociation" {
  route_table_id        = aws_route_table.PrivateRT.id
  subnet_id             = aws_subnet.PublicSubnet3.id
}

resource "aws_route_table_association" "PrivateSubnet2RouteTableAssociation" {
  subnet_id             = aws_subnet.PublicSubnet2.id
  route_table_id        = aws_route_table.PrivateRT2.id
}

resource "aws_route_table_association" "PrivateSubnet2RouteTableAssociation" {
  subnet_id             = aws_subnet.PublicSubnet4.id
  route_table_id        = aws_route_table.PrivateRT2.id
}