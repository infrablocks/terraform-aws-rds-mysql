resource "aws_db_parameter_group" "mysql_database_parameter_group" {
  name        = "database-parameter-group-${var.component}-${var.deployment_identifier}"
  description = "Parameter group containing custom parameters for the ${var.component} MySQL database with deployment identifier ${var.deployment_identifier}."
  family      = var.database_family

  dynamic "parameter" {
    for_each = local.database_parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = {
    Name                 = "database-parameter-group-${var.component}-${var.deployment_identifier}"
    Component            = var.component
    DeploymentIdentifier = var.deployment_identifier
  }
}