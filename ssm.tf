resource "aws_ssm_association" "ansible_association" {
  name = "AWS-ApplyAnsiblePlaybooks"

  parameters = {
    SourceType = "S3"

    SourceInfo = jsonencode({
      path = "https://s3.amazonaws.com/my-ansible-bucket-12345637890/playbook.zip"
    })

    PlaybookFile        = "inventory.yml"
    InstallDependencies = "true"
  }
}



# resource "aws_resourcegroups_group" "ansiblegroup" {
#   name = "ansible-group"

#   resource_query {
#     query = <<JSON
# {
#   "ResourceTypeFilters": [
#     "AWS::EC2::Instance"
#   ],
#   "TagFilters": [
#     {
#       "Key": "Stage",
#       "Values": ["Test"]
#     }
#   ]
# }
# JSON
#   }
# }