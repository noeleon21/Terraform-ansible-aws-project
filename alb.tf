module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  name    = "my-alb234432"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  security_group_ingress_rules = {
    http_from_cloudfront = {
      description    = "Allow HTTP from CloudFront only"
      from_port      = 80
      to_port        = 80
      ip_protocol    = "tcp"
      prefix_list_id = "pl-3b927c52"
    }
  }

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"        
      forward = {
        target_group_key = "instances"
      }
    }
  }

  target_groups = {
    instances = {
      name_prefix = "tg"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"
      health_check = {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
      }
      targets = [
        for instance in module.ec2_instance : {
          target_id = instance.id
          port      = 80
        }
      ]
    }
  }
}