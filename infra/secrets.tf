resource "aws_secretsmanager_secret" "release_key_password" {
  name                    = "release_key_password"
  description             = "secrets for the app"
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "release_key_password" {
  secret_id     = aws_secretsmanager_secret.release_key_password.id
  secret_string = random_password.release_key_password.result
}
resource "aws_secretsmanager_secret" "release_store_password" {
  name                    = "release_store_password"
  description             = "secrets for the app"
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "release_store_password" {
  secret_id     = aws_secretsmanager_secret.release_store_password.id
  secret_string = random_password.release_store_password.result
}
resource "random_password" "release_store_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
resource "random_password" "release_key_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
locals {
  release_key_password   = random_password.release_key_password.result 
  release_store_password = random_password.release_store_password.result 
}
