resource "aws_ssm_association" "ansible_association" {
  name = "AWS-ApplyAnsiblePlaybooks"
 
  targets {
    key = "InstanceIds"
    values = [
      module.ec2_instance["Host"].id,
      module.ec2_instance["webserver2"].id,
      module.ec2_instance["WebServer3"].id
    ]
  }


  parameters = {
    SourceType = "S3"

    SourceInfo = jsonencode({
      path = "https://${aws_s3_bucket.ansible.bucket}.s3.us-east-1.amazonaws.com/playbook.zip"
    })

    PlaybookFile        = "inventory.yml"
    InstallDependencies = "True"
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