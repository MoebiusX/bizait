#!/bin/bash
echo "Hello, World @ Staging" >> index.html
nohup busybox httpd -f -p "${var.server_port}" &
EOF
