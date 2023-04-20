data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "rds_mysql" {
  source = "./../../../../"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  vpc_id             = data.terraform_remote_state.prerequisites.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.prerequisites.outputs.private_subnet_ids

  allowed_cidrs = var.allowed_cidrs

  database_instance_class = var.database_instance_class
  database_version        = var.database_version
  database_family         = var.database_family
  database_port           = var.database_port

  storage_type          = var.storage_type
  storage_iops          = var.storage_iops
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  database_name                 = var.database_name
  database_master_user          = var.database_master_user
  database_master_user_password = var.database_master_user_password

  database_parameters = var.database_parameters

  snapshot_identifier = var.snapshot_identifier

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  use_multiple_availability_zones        = var.use_multiple_availability_zones
  use_encrypted_storage                  = var.use_encrypted_storage
  allow_public_access                    = var.allow_public_access
  allow_major_version_upgrade            = var.allow_major_version_upgrade
  enable_automatic_minor_version_upgrade = var.enable_automatic_minor_version_upgrade
  enable_performance_insights            = var.enable_performance_insights
}
