module "rds_mysql" {
  source = "./../../"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  vpc_id             = module.base_network.vpc_id
  private_subnet_ids = module.base_network.private_subnet_ids

  allowed_cidrs = [module.base_network.vpc_cidr]

  database_family         = "mysql8.4"
  database_version        = "8.4.13"
  database_instance_class = "db.t4g.micro"
  storage_type            = "gp3"
  allocated_storage       = 20

  database_name                 = var.database_name
  database_master_user          = var.database_master_user
  database_master_user_password = var.database_master_user_password
}
