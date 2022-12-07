resource "aws_security_group" "mysql_database_security_group" {
  name        = "database-security-group-${var.component}-${var.deployment_identifier}"
  description = "Default security group for ${var.component} MySQL database instance with deployment identifier ${var.deployment_identifier} allowing access from private network."
  vpc_id      = var.vpc_id

  tags = {
    Name                 = "sg-database-${var.component}-${var.deployment_identifier}"
    Component            = var.component
    DeploymentIdentifier = var.deployment_identifier
  }

  ingress {
    from_port = local.database_port
    to_port   = local.database_port
    protocol  = "tcp"
    cidr_blocks = [
      var.private_network_cidr
    ]
  }
}
