resource "aws_lb" "vault_lb" {
  name = "vault_lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.my_sg]
  subnets = aws_subnet.privateSubnets[*].id

    enable_deletion_protection = false
    enable_http2               = true
    idle_timeout               = 60
}

# Create a Target Group
resource "aws_lb_target_group" "vault_group" {
  name     = "vault_group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id  # Replace with your VPC ID

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold    = 2
    unhealthy_threshold  = 2
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.vault_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault_group.arn
  }
}

resource "aws_lb_target_group_attachment" "web_instance_attachment" {
  target_group_arn = aws_lb_target_group.vault_group.arn
  target_id        = aws_instance.ec2_node[*].id
  port             = 80
}