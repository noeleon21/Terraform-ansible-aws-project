resource "aws_ssm_association" "ansible_association" {
  name = "AWS-ApplyAnsiblePlaybooks"

  parameters = {
    sourceType = "S3"

    sourceInfo = jsonencode({
      path = "https://s3.amazonaws.com/${aws_s3_bucket.ansible.bucket}/playbook.zip"
    })

    playbookFile       = "inventory.yml"
    installDependencies = "True"
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