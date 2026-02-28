module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  

  for_each = {
    for idx, name in tolist(["Host", "webserver2", "WebServer3"]) : name => idx
  }

  depends_on = [ module.vpc ]

  name = "instance-${each.key}"
  ami = "ami-0b09ffb6d8b58ca91"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  associate_public_ip_address = true
  monitoring    = false
  subnet_id     = module.vpc.public_subnets[each.value]
  vpc_security_group_ids = [module.web_sg.security_group_id]

  tags = {
    Name = "instance-${each.key}"
    Stage = "Test"
   
  }
  
}

module "vpc" {
  source =  "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=26c38a66f12e7c6c93"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}


module "web_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "web-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = [var.my_ip]  

  egress_rules = ["all-all"]
}

variable "my_ip" {
  description = "Your IP address in CIDR notation "
  type        = string
  sensitive = true
 
}


output "ec2_instance_id" {
  description = "IDs of the EC2 instances"
  value       = [for instance in module.ec2_instance : instance.id]
}

resource "aws_iam_role" "ssm_role" {
  name = "ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ssm_role_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "ssm_s3_access" {
  role = aws_iam_role.ssm_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:GetObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.ansible.bucket}/*"
      }
    ]
  })
}



resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
  
}