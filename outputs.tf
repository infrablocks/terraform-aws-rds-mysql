output "mysql_database_host" {
  description = "The database host."
  value       = aws_db_instance.mysql_database.address
}

output "mysql_database_name" {
  description = "The database name."
  value       = aws_db_instance.mysql_database.name
}

output "mysql_database_port" {
  description = "The database port."
  value       = var.database_port
}
