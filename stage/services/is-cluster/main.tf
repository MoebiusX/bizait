provider "aws" {
  region = "ap-southeast-1"
}
module "is_cluster" {
  source = "../../../modules/services/is-cluster"

  cluster_name = "is-stage"
}
