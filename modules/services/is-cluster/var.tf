variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  default     = "t2.micro"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  default     = 1
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  default     = 2
}
