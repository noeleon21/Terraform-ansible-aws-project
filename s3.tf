resource "aws_s3_bucket" "ansible" {
    bucket = "my-ansible-bucket-12345637890"
}

resource "aws_s3_object" "playbook" {
    bucket = aws_s3_bucket.ansible.id
    key    = "playbook.yaml"
    source = "playbook.yaml"

}

resource "aws_s3_bucket_public_access_block" "ansible_block" {
    bucket = aws_s3_bucket.ansible.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

# resource "aws_iam_instance_profile" "ssm_instance_profile" {
#   name = "ssm-instance-profile"
#   role = aws_iam_role.ssm_role.name
# }