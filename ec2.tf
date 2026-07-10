# create bastion host in public subnet AZ1
resource "aws_instance" "bastion" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.public1.id
    security_groups = [aws_security_group.bastion.id]

    tags = {
        Name = "bastion-host"
    }
}

resource "aws_eip" "bastion_eip" {
    instance = aws_instance.bastion.id
    domain = "vpc"

    tags = {
        Name = "bastion-eip"
    }
}

# create app instance in one AZ
resource "aws_instance" "app1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.app1.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.key_name

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "App Server 1 in AZ-1" > index.html
              python3 -m http.server 8080 &
              EOF
  )

  tags = {
    Name = "app-server-az1"
  }
}

# create app instance in second AZ
resource "aws_instance" "app2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.app2.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.key_name

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "App Server 2 in AZ-2" > index.html
              python3 -m http.server 8080 &
              EOF
  )

  tags = {
    Name = "app-server-az2"
  }
}


  # Register app servers with ALB target group
resource "aws_lb_target_group_attachment" "app1" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "app2" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app2.id
  port             = 8080
}

# DB subnet group 
resource "aws_db_subnet_group" "main" {
  name       = "db-subnet-group-3tier"
  subnet_ids = [aws_subnet.db1.id, aws_subnet.db2.id]

  tags = {
    Name = "3-tier-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier     = "appdb3tier"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "appdb"
  username = "admin"
  password = "DevOpsPass123!"

  db_subnet_group_name            = aws_db_subnet_group.main.name
  vpc_security_group_ids          = [aws_security_group.db_sg.id]
  multi_az                        = false
  backup_retention_period         = 0
  publicly_accessible             = false
  skip_final_snapshot             = true

  tags = {
    Name = "3-tier-app-db"
  }
}