# create VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "terraform-project-vpc"
  }
}

# create public subnet_1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_1
  availability_zone       = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-project-public-subnet-1"
  }
}

# create private subnet_1
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidr_1
  availability_zone       = var.az_1
  map_public_ip_on_launch = false

  tags = {
    Name = "terraform-project-private-subnet-1"
  }
}

# create public subnet_2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_2
  availability_zone       = var.az_2
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-project-public-subnet-2"
  }
}

# create private subnet_2
resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidr_2
  availability_zone       = var.az_2
  map_public_ip_on_launch = false

  tags = {
    Name = "terraform-project-private-subnet-2"
  }
}

# create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "terraform-project-igw"
  }
}

# create route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.anywhere_ip_range
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "terraform_project-public-route-table"
  }
}

# create route table association for public subnets
resource "aws_route_table_association" "public_rta_1" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "public_rta_2" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_2.id
}

# allocate elastic IP
resource "aws_eip" "nat_eip_1" {
  domain = "vpc"

  tags = {
    Name = "terraform-project-nat-eip-1"
  }
}

resource "aws_eip" "nat_eip_2" {
  domain = "vpc"

  tags = {
    Name = "terraform-project-nat-eip-2"
  }
}

# create NAT gateway
resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "terraform-project-nat-gw-1"
  }
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = "terraform-project-nat-gw-2"
  }
}

# create route tables for private subnets
resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = var.anywhere_ip_range
    nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  }

  tags = {
    Name = "terraform-project-private-table-1"
  }
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = var.anywhere_ip_range
    nat_gateway_id = aws_nat_gateway.nat_gw_2.id
  }

  tags = {
    Name = "terraform-project-private-table-2"
  }
}

# create route table associations for private subnets
resource "aws_route_table_association" "private_rta_1" {
  route_table_id = aws_route_table.private_route_table_1.id
  subnet_id      = aws_subnet.private_subnet_1.id
}

resource "aws_route_table_association" "private_rta_2" {
  route_table_id = aws_route_table.private_route_table_2.id
  subnet_id      = aws_subnet.private_subnet_2.id
}

# create security group for EC2
resource "aws_security_group" "ec2_sg" {
  name   = "terraform-project-ec2-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "terraform-project-ec2-sg"
  }
}

# set inbound and outbound rules for EC2
resource "aws_vpc_security_group_ingress_rule" "ec2_allow_ssh" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.anywhere_ip_range
  from_port         = 22
  ip_protocol       = "TCP"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "ec2_allow_http" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.anywhere_ip_range
  from_port         = 80
  ip_protocol       = "TCP"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ec2_allow_app1" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.anywhere_ip_range
  from_port         = 8000
  ip_protocol       = "TCP"
  to_port           = 8000
}

resource "aws_vpc_security_group_ingress_rule" "ec2_allow_app2" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.anywhere_ip_range
  from_port         = 8001
  ip_protocol       = "TCP"
  to_port           = 8001
}

resource "aws_vpc_security_group_egress_rule" "ec2_egress" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.anywhere_ip_range
  ip_protocol       = "-1"
}

# create security group for LB
resource "aws_security_group" "lb_sg" {
  name   = "terraform-project0-lb-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "terraform-project-lb-sg"
  }
}

# set inbound and outbound rules for LB
resource "aws_vpc_security_group_ingress_rule" "lb_allow_http" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = var.anywhere_ip_range
  from_port         = 80
  ip_protocol       = "TCP"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "lb_egress" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = var.anywhere_ip_range
  ip_protocol       = "-1"
}

resource "aws_security_group" "bastion-sg" {
  name   = "terraform-project-bastion-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "terraform-project-bastion-sg"
  }
}

# set inbound and outbound rules for bastion host
resource "aws_vpc_security_group_ingress_rule" "bastion_allow_ssh" {
  security_group_id = aws_security_group.bastion-sg.id
  cidr_ipv4         = var.anywhere_ip_range
  from_port         = 22
  ip_protocol       = "TCP"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "bastion_egress" {
  security_group_id = aws_security_group.bastion-sg.id
  cidr_ipv4         = var.anywhere_ip_range
  ip_protocol       = "-1"
}

# create acces key pair
resource "aws_key_pair" "key_pair" {
  key_name   = "terraform-project-key"
  public_key = file("C:\\Users\\Lenovo\\terraform-project-key.pem.pub")
}

resource "aws_instance" "bastion_host" {
  ami                         = var.ubuntu_ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_1.id
  key_name                    = aws_key_pair.key_pair.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]

  tags = {
    Name = "terraform-project-bastion-host"
  }

  provisioner "file" {
    source      = "C:\\Users\\Lenovo\\terraform-project-key.pem"
    destination = "/home/ubuntu/terraform-project-key.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:\\Users\\Lenovo\\terraform-project-key.pem")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ubuntu/terraform-project-key.pem"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:\\Users\\Lenovo\\terraform-project-key.pem")
      host        = self.public_ip
    }
  }
}

# create launch templates for EC2
resource "aws_launch_template" "lt_1" {
  name                   = "terraform-project-lt-1"
  image_id               = var.ubuntu_ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = base64encode(file("../user-scripts/app1.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "terraform-project-lt-1"
    }
  }
}

resource "aws_launch_template" "lt_2" {
  name                   = "terraform-project-lt-2"
  image_id               = var.ubuntu_ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = base64encode(file("../user-scripts/app2.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "terraform-project-lt-2"
    }
  }
}

# create target groups
resource "aws_lb_target_group" "tg_1" {
  name     = "terraform-project-tg-1"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_target_group" "tg_2" {
  name     = "terraform-project-tg-2"
  port     = 8001
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

# create autoscaling groups
resource "aws_autoscaling_group" "asg_1" {
  desired_capacity    = 2
  min_size            = 1
  max_size            = 4
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  target_group_arns   = [aws_lb_target_group.tg_1.arn]

  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.lt_1.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
}

resource "aws_autoscaling_group" "asg_2" {
  desired_capacity    = 2
  min_size            = 1
  max_size            = 4
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  target_group_arns   = [aws_lb_target_group.tg_2.arn]

  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.lt_2.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
}

# create load balancer 
resource "aws_lb" "lb" {
  name               = "terraform-project-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

# create listener for LB
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 - Not Found"
      status_code  = "404"
    }
  }
}

# create listener rules for path_based routing
resource "aws_lb_listener_rule" "app1_rule" {
  listener_arn = aws_lb_listener.lb_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_1.arn
  }

  condition {
    path_pattern {
      values = ["/app1/*"]
    }
  }
}

resource "aws_lb_listener_rule" "app2_rule" {
  listener_arn = aws_lb_listener.lb_listener.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_2.arn
  }

  condition {
    path_pattern {
      values = ["/app2/*"]
    }
  }
}