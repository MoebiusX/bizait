output "elb_dns_name" {
	value = "${aws_elb.bizaitELB.dns_name}"
}