output "elb_dns_name" {
  value = "${aws_elb.bizaitELB.dns_name}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.bizaitASG.name}"
}
