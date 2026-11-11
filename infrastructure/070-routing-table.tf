# Create ande associate route

# Routing table configuration
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform.id

  tags = {
    Name = "${terraform.workspace}-public"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Associate http route
resource "aws_route_table_association" "http" {
  subnet_id      = aws_subnet.http.id
  route_table_id = aws_route_table.public.id
}

# Private route table for DB subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.terraform.id

  tags = {
    Name = "${terraform.workspace}-private-db"
  }
}

# Associate DB subnet with private route table
resource "aws_route_table_association" "db_private" {
  subnet_id      = aws_subnet.db.id
  route_table_id = aws_route_table.private.id
}
