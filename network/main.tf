resource "aws_vpc" "name" {
  cidr_block = var.vpc_cidr

  tags = "${merge({
    Name = "${var.region}-vpc"
  },var.tags)}"
}

# resource "aws_subnet" "public_subnet" {
#   count                   = length(data.aws_availability_zones.name.names)
#   vpc_id                  = aws_vpc.name.id
#   cidr_block              = cidrsubnet(var.vpc_cidr, ceil(log(length(data.aws_availability_zones.name.names) * 2, 2)), count.index)
#   availability_zone       = element(data.aws_availability_zones.name.names, count.index)
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "Public-Subnet-${element(data.aws_availability_zones.name.names, count.index)}"
#   }
# }

# resource "aws_subnet" "private_subnet" {
#   count             = length(data.aws_availability_zones.name.names)
#   vpc_id            = aws_vpc.name.id
#   cidr_block        = cidrsubnet(var.vpc_cidr, ceil(log(length(data.aws_availability_zones.name.names) * 2, 2)), count.index + length(data.aws_availability_zones.name.names))
#   availability_zone = element(data.aws_availability_zones.name.names, count.index)
#   tags = {
#     Name = "Private-Subnet-${element(data.aws_availability_zones.name.names, count.index)}"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.name.id
#   tags = {
#     Name = "${var.region}-igw"
#   }
# }
# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.name.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     "Name" = "Public-RT"
#   }
# }

# resource "aws_route_table_association" "public" {
#   count          = length(aws_subnet.public_subnet.*.id)
#   subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
#   route_table_id = aws_route_table.public_rt.id
# }

# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.name.id
#   tags = {
#     "Name" = "Private-RT"
#   }
# }

# resource "aws_route_table_association" "private" {
#   count          = length(aws_subnet.private_subnet.*.id)
#   subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
#   route_table_id = aws_route_table.private_rt.id
# }

# resource "aws_eip" "eip" {
#   vpc = true
# }

# resource "aws_nat_gateway" "ngw" {
#   subnet_id     = aws_subnet.public_subnet[0].id
#   allocation_id = aws_eip.eip.id
#   tags = {
#     Name = "${var.region}-nwgw"
#   }
# }

# resource "aws_route" "ngw" {
#   route_table_id         = aws_route_table.private_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.ngw.id
# }
