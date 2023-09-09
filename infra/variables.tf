variable "region" {
  description = "The AWS region to use."
}
variable "github_repo_url" {
  description = "The URL of the GitHub repository for the Android app."
}
variable "account_id" {
  description = "The AWS account ID."
}
variable "github_token" {
  description = "the github token used to allow aws notice the changes on the repo and trigger the pipeline"
}
variable "github_owner" {
  description = "The github account username"
}

variable "APP_CENTER_TOKEN" {
  description = "Appcenter Token"
}
variable "APP_ID" {
  description = "App ID (owner/appname)"
}
variable "APPCENTER_GROUP" {
  description = "Your appcenter group name"
}
variable "BUCKET_NAME" {
  description = "Your s3 bucket name"
}
variable "APP_NAME" {
  description = "the prefix to add to your application name"
}