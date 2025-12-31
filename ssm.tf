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
      path = "https://s3.amazonaws.com/${aws_s3_bucket.ansible.bucket}/${aws_s3_object.playbook.key}"
    })

    PlaybookFile        = "playbook.yaml"
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