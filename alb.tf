# module "alb" {
#   source = "terraform-aws-modules/alb/aws"

#   name    = "my-alb234432"
#   vpc_id  = module.vpc.vpc_id
#   subnets = module.vpc.public_subnets

#   # Security Group Rules
#   security_group_ingress_rules = {
#     http = {
#       description = "Allow HTTP from your IP"
#       from_port   = 80
#       to_port     = 80
#       ip_protocol = "tcp"
#       cidr_ipv4   = var.my_ip
#     }
#     https = {
#       description = "Allow HTTPS from your IP"
#       from_port   = 443
#       to_port     = 443
#       ip_protocol = "tcp"
#       cidr_ipv4   = var.my_ip
#     }
#     ssh = {
#       description = "Allow SSH from your IP only (best practice)"
#       from_port   = 22
#       to_port     = 22
#       ip_protocol = "tcp"
#       cidr_ipv4   = var.my_ip
#     }
#   }

#   security_group_egress_rules = {
#     all = {
#       description = "Allow all outbound traffic"
#       ip_protocol = "-1"
#       cidr_ipv4   = "0.0.0.0/0"
#     }
#   }

#   # Access Logs (ensure this S3 bucket exists)
#   access_logs = {
#     bucket = "my-alb-logs"
#     enabled = true
#   }

#   # HTTPS + Redirect from HTTP
#   listeners = {
#     http-to-https = {
#       port     = 80
#       protocol = "HTTP"
#       redirect = {
#         port        = "443"
#         protocol    = "HTTPS"
#         status_code = "HTTP_301"
#       }
#     }
#     https = {
#       port            = 443
#       protocol        = "HTTPS"
#       certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/your-acm-cert-id"
#       forward = {
#         target_group_key = "instances"
#       }
#     }
#   }

#   # Target Group Configuration
#   target_groups = {
#     instances = {
#       name_prefix = "tg"
#       protocol    = "HTTP"
#       port        = 80
#       target_type = "instance"
#       health_check = {
#         path                = "/"
#         interval            = 30
#         timeout             = 5
#         healthy_threshold   = 5
#         unhealthy_threshold = 2
#       }
#       targets = [
#         for instance in module.ec2_instance : {
#           target_id = instance.id
#           port      = 80
#         }
#       ]
#     }
#   }
# }

# variable "my_ip" {
#   description = "Your IP address in CIDR notation "
#   type        = string
# }
