data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "rds_mysql" {
  source = "../../../../"

  component = var.component
  deployment_identifier = var.deployment_identifier

  vpc_id = data.terraform_remote_state.prerequisites.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.prerequisites.outputs.private_subnet_ids

  database_instance_class = var.database_instance_class
  database_version = "5.7.22"
  database_family = "mysql5.7"

  database_name = var.database_name
  database_master_user_password = var.database_master_user_password
  database_master_user = var.database_master_user
  private_network_cidr = var.private_network_cidr

  snapshot_identifier = var.snapshot_identifier
  backup_retention_period = var.backup_retention_period
  backup_window = var.backup_window
  maintenance_window = var.maintenance_window
}
