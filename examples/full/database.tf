module "rds_mysql" {
  source = "./../../"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  vpc_id             = module.base_network.vpc_id
  private_subnet_ids = module.base_network.private_subnet_ids

  private_network_cidr = module.base_network.vpc_cidr

  database_family  = "mysql5.7"
  database_version = "5.7.40"

  database_name                 = var.database_name
  database_master_user          = var.database_master_user
  database_master_user_password = var.database_master_user_password
}
