provider "aws" {
  allowed_account_ids = [local.account_id]
  region              = "eu-west-1"
  default_tags {
    tags = {
      RepoName = local.repository
      FolderPath = "${local.root_folder}/${local.environment}/${local.execution_context}"
      Environment = local.environment
    }
  }
}
