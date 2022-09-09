# CREATE VPC
resource "aws_vpc" "vpc" {
    cidr_block            = "${var.vpc-cidr}"
    instance_tenancy      = "default"
    enable_dns_hostnames = true
    tags = {
      Name = "test-vpc"
  }
}

# CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id   = aws_vpc.vpc.id

  tags = {
    Name = "test-igw"
  }
}

# CREATE PUBLIC SUBNET 1
resource "aws_subnet" "PublicSubnet1" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "${var.PublicSubnet1-cidr}"
    availability_zone   = "us-east-1a"
    enable_resource_name_dns_a_record_on_launch = true
    map_public_ip_on_launch = true
    tags= {
      Name    = "Public Subnet 1"
    }
}

# CREATE ROUTE TABLE 
resource "aws_route_table" "RouteTable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block          = "0.0.0.0/0"
    gateway_id          = aws_internet_gateway.igw.id
  }

  tags  = {
    Name    = "Public Route Table"
  }
}

# CREATE ROUTE
#resource "aws_route" "route" {
#  route_table_id            = "aws_route_table.RouteTable.id"
#  gateway_id                = aws_internet_gateway.igw.id
#  destination_cidr_block    = "0.0.0.0/0"
#  depends_on                = [aws_route_table.RouteTable]
#}

resource "aws_route_table_association" "PublicSubnet1-RTAssociation" {
  subnet_id             = aws_subnet.PublicSubnet1.id
  route_table_id        = aws_route_table.RouteTable.id
}

# CREATE PUBLIC SUBNET 2
resource "aws_subnet" "PublicSubnet2" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "${var.PublicSubnet2-cidr}
    availability_zone   = "us-east-1b"
    enable_resource_name_dns_a_record_on_launch = true
    map_public_ip_on_launch = true
    tags= {
        Name    = "Public Subnet 2"
    }
}

resource "aws_route_table_association" "PublicSubnet2-RTAssociation" {
  subnet_id             = aws_subnet.PublicSubnet2.id
  route_table_id        = aws_route_table.RouteTable.id
}

# CREATE PRIVATE SUBNETS
resource "aws_subnet" "PrivateSubnet1" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "${var.PrivateSubnet1-cidr}"
    availability_zone   = "us-east-1a"
  
    tags= {
      Name    = "Private Subnet 1 | Application Tier"
    }
}

resource "aws_subnet" "PrivateSubnet2" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "${var.PrivateSubnet2-cidr}"
    availability_zone   = "us-east-1b"
    
    tags= {
      Name    = "Private Subnet 2 | Application Tier"
    }
}

resource "aws_subnet" "PrivateSubnet3" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "${var.PrivateSubnet3-cidr}"
    availability_zone   = "us-east-1a"
    
    tags= {
      Name    = "Private Subnet 3 | Database Tier"
    }
}

resource "aws_subnet" "PrivateSubnet4" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "${var.PrivateSubnet4-cidr}"
    availability_zone   = "us-east-1b"
    
    tags= {
      Name    = "Private Subnet 4 | Database Tier"
    }
}

# CREATE SECURITY GROUPS
#resource "aws_security_group" "SSHSecurityGroup" {
 # name        = "SSH Security Group"
 # description = "Allow SSH inbound traffic"
 # vpc_id      = aws_vpc.vpc.id

  #ingress {
  #  description      = "SSH from IP"
  #  from_port        = 22
  #  to_port          = 22
  #  protocol         = "ssh"
  #  cidr_blocks      = ["0.0.0.0/0"]
  #}

  #egress {
   # from_port        = 0
    #to_port          = 0
    #protocol         = "-1"
    #cidr_blocks      = ["0.0.0.0/0"]
  #}

  #tags = {
  #  Name = "allow_ssh"
  #}
#}

resource "aws_security_group" "WebServerSecurityGroup" {
  name        = "WebServerSecurity Group"
  description = "Allow SSH, HTTP and HTTPS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTP from IP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "HTTPS from IP"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH from IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow SSH, HTTP and HTTPS"
  }
}

resource "aws_security_group" "DBSecurityGroup" {
  name        = "DataBase Security Group"
  description = "Allow only sg inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "access from sg"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["aws_security_group.WebServerSecurityGroup.id"]
    #"${aws_security_group.WebServerSecurityGroup.id}"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow access to the Database security group "
  }
}

