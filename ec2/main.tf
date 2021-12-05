resource "aws_security_group" "alb_sg" {
  name   = "${var.team_name}-alb-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.team_name}-alb-sg"
  }
}

resource "aws_lb" "name" {
  name               = "${var.team_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.alb_subnet_ids

  tags = {
    Name = "${var.team_name}-alb"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "${var.team_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.name.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_instance" "bastion" {
  ami                                = data.aws_ami.amazon-linux-2.id
  instance_type                      = "t21.micro"
  change_my_name_to_subnet_id_to_run = var.alb_subnet_ids[0]
  vpc_security_group_ids             = [aws_security_group.bastion_sg.id]
  key_name                           = var.region

  tags = {
    Name = "Bastion-Instance"
  }
}

resource "aws_instance" "nginx" {

  depends_on = [
    var.nat_gw_id
  ]
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.region

  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx
EOF

  tags = {
    Name = "Nginx-Instance"
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.nginx.id
  port             = 80
}
resource "aws_security_group" "app_sg" {
  name   = "${var.team_name}-app-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.team_name}-app-sg"
  }
}


resource "aws_security_group" "bastion_sg" {
  name   = "${var.team_name}-bastion-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.team_name}-bastion-sg"
  }
}

