resource "aws_security_group" "private_sg" {
  name   = "${var.project}-ec2-sg"
  vpc_id = var.vpc_id

  # No inbound → access only via SSM
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ssm" {
  name = "${var.project}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.project}-ssm-profile"
  role = aws_iam_role.ssm.name
}

resource "aws_instance" "ssm_ec2" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "${var.project}-ssm-ec2"
  }
}
