provider "aws" {
  region = "eu-west-3"
}
data "aws_caller_identity" "current" {}
