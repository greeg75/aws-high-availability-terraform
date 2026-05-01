#Security Group instance
resource "aws_security_group" "ec2_sg" {
  name   = "${var.project_name}-ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Templace configuration
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-tpl"
  image_id      = "ami-0e96f8459c59b3ff6"
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups            = [aws_security_group.ec2_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World! - Hostname: $(hostname)</h1>" > /var/www/html/index.html
              EOF
  )
}

#ASG (Auto Scaling Group)
resource "aws_autoscaling_group" "app" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  target_group_arns   = [var.target_group_arn]
  vpc_zone_identifier = var.public_subnet

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}