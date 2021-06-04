# plan - execute 
resource "aws_s3_bucket" "devops_bucket_002_local_tf" {
    bucket = "devops-bucket-002"
    versioning {
        enabled = true
    }
}

resource "aws_iam_user" "my_iam_user" {
    name = "my_devops_user1"
}