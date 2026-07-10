#frontend security group

# SG for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
        Name = "alb-sg"
    }
}

# Security group for Bastion (public)
resource "aws_security_group" "bastion" {
  vpc_id = aws_vpc.main.id
  name   = "bastion-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
        Name = "bastion-sg"
    }   
}

# application security group

# Security group for App tier (private)
resource "aws_security_group" "app_sg" {
    vpc_id = aws_vpc.main.id
    name   = "app-sg"

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }   

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = [aws_security_group.bastion.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }   

    tags = {
        Name = "app-sg"
    }
}   

# database security group

# Security group for DB tier (private)
resource "aws_security_group" "db_sg" {
    vpc_id = aws_vpc.main.id
    name   = "db-sg"

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.app_sg.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "db-sg"
    }
}       