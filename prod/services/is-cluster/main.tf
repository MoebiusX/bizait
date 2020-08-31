provider "aws" {
  region = "ap-southeast-1"
}
module "is_cluster" {
  source = "../../../modules/services/is-cluster"

  cluster_name = "is-prod"
  min_size     = 2
  max_size     = 4
}
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = 1
  max_size               = 2
  desired_capacity       = 2
  recurrence             = "0 9 * * *"
  autoscaling_group_name = module.is_cluster.asg_name
}
resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name  = "scale-in-at-night"
  min_size               = 1
  max_size               = 2
  desired_capacity       = 1
  recurrence             = "0 17 * * *"
  autoscaling_group_name = module.is_cluster.asg_name
}
