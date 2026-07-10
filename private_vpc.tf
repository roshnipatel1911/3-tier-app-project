# App tier route table (no internet route)

resource "aws_route_table" "app" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "app-rt"
    }
}

# associate app route table with app subnets
resource "aws_route_table_association" "app1" {
    subnet_id      = aws_subnet.app1.id
    route_table_id = aws_route_table.app.id
}

# associate app route table with app subnets
resource "aws_route_table_association" "app2" {
    subnet_id      = aws_subnet.app2.id
    route_table_id = aws_route_table.app.id
}

# Database tier route table (no internet route)
resource "aws_route_table" "db" {
    vpc_id = aws_vpc.main.id
    
    tags = {
        Name = "db-rt"
    }
}   

# associate db route table with db subnets
resource "aws_route_table_association" "db1" {
    subnet_id      = aws_subnet.db1.id
    route_table_id = aws_route_table.db.id
}

# associate db route table with db subnets
resource "aws_route_table_association" "db2" {
    subnet_id      = aws_subnet.db2.id
    route_table_id = aws_route_table.db.id
}

