resource "aws_db_parameter_group" "mysql_database_parameter_group" {
  description = "Allow passing of parameters to ${var.component} MySQL database."
  name        = "database-parameter-group-${var.component}-${var.deployment_identifier}"
  family      = "mysql${var.database_version}"

  dynamic "parameter" {
    for_each = var.parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}