resource "aws_db_instance" "mysql_database" {
  identifier           = "db-instance-${var.component}-${var.deployment_identifier}"
  allocated_storage    = var.allocated_storage
  storage_type         = "standard"
  engine               = "mysql"
  engine_version       = var.database_version
  instance_class       = var.database_instance_class
  name                 = var.database_name
  username             = var.database_master_user
  password             = var.database_master_user_password
  snapshot_identifier  = var.snapshot_identifier
  publicly_accessible  = false
  multi_az             = var.use_multiple_availability_zones == "yes" ? true : false
  storage_encrypted    = var.use_encrypted_storage == "yes" ? true : false
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.mysql_database_security_group.id
  ]

  parameter_group_name = aws_db_parameter_group.mysql_database_parameter_group.name

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  tags = {
    Name                 = "db-instance-${var.component}-${var.deployment_identifier}"
    Component            = var.component
    DeploymentIdentifier = var.deployment_identifier
  }
}
