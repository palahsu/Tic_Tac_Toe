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