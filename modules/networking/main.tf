# resource "aws_vpc" "vpc" {
#   cidr_block = var.cidr_block

#   tags = {
#   "Name" = "${var.name}-vpc"
#   }     
# }

# resource "aws_subnet" "public_subnet" {
#   for_each = toset(var.public_cidrs)
    
#   vpc_id = aws_vpc.vpc.id 
#   cidr_block = each.key
    
#   tags = {
#     "Name" = "${var.name}-public_subnet-${each.key}"
#     }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc.id 
#   tags = {
#     "Name" = "${var.name}-igw"
#   }
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
# }

# resource "aws_route_table_association" "public" {
#   for_each = toset(var.public_cidrs)
#   route_table_id = aws_route_table_public.id
#   subnet_id = aws_subnet.public_subnet[each.key].id    
# }

# resource "aws_subnet" "private_subnet" {
#   for_each = toset(var.private_cidrs)
    
#   vpc_id = aws_vpc.vpc.id 
#   cidr_block = each.key
    
#   tags = {
#     "Name" = "${var.name}-private_subnet-${each.key}"
#   }
# }

# resource "aws_eip" "eip" {
#   tags = {
#     "Name" = "${var.name}-eip"
#   }
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.eip.id
#   subnet_id = aws_subnet.public_subnet[each.key].id
# }

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.vpc.id

#   route = {
#   cidr_block = "0.0.0.0/0"
#     nat_gateway.id = aws_nat_gateway.nat.id
#     }
# }

# resource "aws_route_table_association" "private" {
#   for_each = toset(var.private_cidrs)
#   route_table_id = aws_route_table_private.id
#   subnet_id = aws_subnet.private_subnet[each.key].id
# }

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    "Name" = "${var.name}-vpc"
  }     
}

resource "aws_subnet" "public_subnet" {
  for_each = toset(var.public_cidrs)
    
  vpc_id     = aws_vpc.vpc.id 
  cidr_block = each.key
    
  tags = {
    "Name" = "${var.name}-public_subnet-${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id 

  tags = {
    "Name" = "${var.name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  for_each       = toset(var.public_cidrs)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_subnet[each.key].id    
}

resource "aws_subnet" "private_subnet" {
  for_each   = toset(var.private_cidrs)
    
  vpc_id     = aws_vpc.vpc.id 
  cidr_block = each.key
    
  tags = {
    "Name" = "${var.name}-private_subnet-${each.key}"
  }
}

resource "aws_eip" "eip" {
  tags = {
    "Name" = "${var.name}-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each      = aws_subnet.public_subnet
  allocation_id = aws_eip.eip.id
  subnet_id     = each.value.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }
}

resource "aws_route_table_association" "private" {
  for_each       = toset(var.private_cidrs)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_subnet[each.key].id
}
