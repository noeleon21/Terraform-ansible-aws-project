# resource "aws_iam_openid_connect_provider" "this" {
#   url = "https://token.actions.githubusercontent.com"

#   client_id_list = [
#     "sts.amazonaws.com",
#   ]

#   thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
# }

# data "aws_iam_policy_document" "oidc" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.this.arn]
#     }

#     condition {
#       test     = "StringEquals"
#       values   = ["sts.amazonaws.com"]
#       variable = "token.actions.githubusercontent.com:aud"
#     }

#     condition {
#       test     = "StringLike"
#       values   = ["repo:YourOrg/*"]
#       variable = "token.actions.githubusercontent.com:sub"
#     }
#   }
# }
# resource "aws_iam_role" "github_actions_role" {
#   name               = "github-actions-role"
#   assume_role_policy = data.aws_iam_policy_document.oidc.json
# }

# resource "aws_iam_role_policy" "github_actions_policy" {
#   role = aws_iam_role.github_actions_role.name

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:PutObject",
#           "s3:GetObject",
#           "s3:ListBucket"

#         ]
#         Resource = [
#           "arn:aws:s3:::noel-terraform-state-bucket123456/*",
#           "arn:aws:s3:::${aws_s3_bucket.ansible.name}/*"
#         ]
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "sts:AssumeRole"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "ec2:DescribeInstances",
#           "ec2:StartInstances",
#           "ec2:StopInstances"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "ssm:StartSession",
#           "ssm:SendCommand",    
#           "ssm:DescribeInstanceInformation",
#           "ssm:GetCommandInvocation",
#           "ssm:ListCommandInvocations" 
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }
# data "aws_iam_policy_document" "deploy" {
#   statement {
#     effect  = "Allow"
#     actions = [
#       "ecr:*",
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "deploy" {
#   name        = "ci-deploy-policy"
#   description = "Policy used for deployments on CI"
#   policy      = data.aws_iam_policy_document.deploy.json
# }

# resource "aws_iam_role_policy_attachment" "attach-deploy" {
#   role       = aws_iam_role.github_actions_role.name
#   policy_arn = aws_iam_policy.deploy.arn
# }

