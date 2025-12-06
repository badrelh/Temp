variable "mysql_root_password" {
  description = "MySQL root password"
  type        = string
  sensitive   = true
}

variable "mysql_password" {
  description = "MySQL movies_user password"
  type        = string
  sensitive   = true
}

variable "flask_secret_key" {
  description = "Flask SECRET_KEY for session management"
  type        = string
  sensitive   = true
}
