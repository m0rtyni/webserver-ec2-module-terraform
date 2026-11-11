# Security group configuration

# Default administration port
resource "aws_security_group" "administration" {
  name        = "${terraform.workspace}-administration"
  description = "Allow default administration service"
  vpc_id      = aws_vpc.terraform.id
  tags = {
    Name = "${terraform.workspace}-administration"
  }

  # Open ssh port
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip]
  }

  # Allow icmp
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [var.admin_ip]
  }
}

# Open web port
#trivy:ignore:AVD-AWS-0104:exp:2027-02-07
resource "aws_security_group" "web" {
  name        = "${terraform.workspace}-web"
  description = "Allow web incgress trafic"
  vpc_id      = aws_vpc.terraform.id
  tags = {
    Name = "${terraform.workspace}-web"
  }

  # http port
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # https port
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP outbound traffic
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS outbound traffic
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Open database port
#trivy:ignore:AVD-AWS-0104:exp:2027-02-07
resource "aws_security_group" "db" {
  name        = "${terraform.workspace}-db"
  description = "Allow db incgress trafic"
  vpc_id      = aws_vpc.terraform.id
  tags = {
    Name = "${terraform.workspace}-db"
  }

  # db port
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.network_http["cidr"]]
  }

  # Allow HTTP outbound traffic
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS outbound traffic
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

