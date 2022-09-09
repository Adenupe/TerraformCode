variable "vpc-cidr" {
    default         = "10.0.0.0/16"
    description     = "vpc cidr block"
    type            = String
}

variable "PublicSubnet1-cidr" {
    default         = "10.0.0.0/24"
    description     = "public subnet 1 cidr block"
    type            = String
}

variable "PublicSubnet2-cidr" {
    default         = "10.0.1.0/24"
    description     = "public subnet 2 cidr block"
    type            = String
}

variable "PrivateSubnet1-cidr" {
    default         = "10.0.2.0/24"
    description     = "private subnet 1 cidr block"
    type            = String
}

variable "PrivateSubnet2-cidr" {
    default         = "10.0.3.0/24"
    description     = "private subnet 2 cidr block"
    type            = String
}

variable "PrivateSubnet3-cidr" {
    default         = "10.0.4.0/24"
    description     = "private subnet 3 cidr block"
    type            = String
}

variable "PrivateSubnet4-cidr" {
    default         = "10.0.5.0/24"
    description     = "private subnet 4 cidr block"
    type            = String
}