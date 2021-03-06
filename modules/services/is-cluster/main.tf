data "aws_availability_zones" "all" {}

resource "aws_elb" "bizaitELB" {
  name               = "${var.cluster_name}-bizaitELB"
  availability_zones = data.aws_availability_zones.all.names
  security_groups    = ["${aws_security_group.elb.id}"]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }
}

resource "aws_launch_configuration" "bizait" {
  image_id        = "ami-0007cf37783ff7e10"
  instance_type   = var.instance_type
  security_groups = ["${aws_security_group.instance.id}"]
  user_data       = <<-EOF
    #!/bin/bash
    echo "Hello, World" > index.html
    nohup busybox httpd -f -p "${var.server_port}" &
    EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bizaitASG" {
  launch_configuration = aws_launch_configuration.bizait.id
  availability_zones   = data.aws_availability_zones.all.names

  load_balancers    = ["${aws_elb.bizaitELB.name}"]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size
  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-bizaitASG"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance-security"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "elb" {
  name = "${var.cluster_name}-elb-security"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
