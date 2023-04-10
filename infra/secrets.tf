resource "aws_secretsmanager_secret" "release_key_password" {
  name                    = "release_key_password"
  description             = "secrets for the app"
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "release_key_password" {
  secret_id     = aws_secretsmanager_secret.release_key_password.id
  secret_string = "123456"
}
resource "aws_secretsmanager_secret" "release_store_password" {
  name                    = "release_store_password"
  description             = "secrets for the app"
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "release_store_password" {
  secret_id     = aws_secretsmanager_secret.release_store_password.id
  secret_string = "123456"
}

locals {
  release_key_password   = aws_secretsmanager_secret_version.release_key_password.secret_string
  release_store_password = aws_secretsmanager_secret_version.release_store_password.secret_string
}
