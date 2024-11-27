# # Fetch the password from Secrets Manager
# data "aws_secretsmanager_secret_version" "db_password" {
#   secret_id = aws_secretsmanager_secret.db_secret.id
# }

# resource "aws_db_subnet_group" "prod_subnet_group" {
#   name       = "{var.env}-rds-subnet-group"
#   subnet_ids = [aws_subnet.private-subnet-terraform[count.index].id] # Replace with your actual subnet IDs

#   tags = {
#     Name = "prod-rds-subnet-group"
#   }
# }
# resource "aws_db_instance" "prod_db_instance" {
#   allocated_storage         = 20            # Storage in GB
#   engine                    = "mysql"       # Database engine (e.g., MySQL, PostgreSQL)
#   engine_version            = "8.0.39"      # Database engine version
#   instance_class            = "db.t3.micro" # Instance type
#   db_name                   = "prod_db"     # Database name
#   username                  = "admin"       # Database username
#   password                  = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string).password
#   parameter_group_name      = "default.mysql8.0"                         # Parameter group for MySQL 8.0
#   publicly_accessible       = false                                      # Whether the instance is publicly accessible
#   db_subnet_group_name      = aws_db_subnet_group.prod_subnet_group.name # Subnet group
#   skip_final_snapshot       = false
#   final_snapshot_identifier = "prod-db-final-snapshot"
#   tags = {
#     Name        = "prod-rds-instance"
#     Environment = "Production"
#   }
# }
