resource "aws_iam_policy" "kms_access" {
  name = "kms"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey",
        "kms:DescribeKey"
      ],
      "Resource": aws_kms_key.vault_unseal.arn
    },{
        Action   = "ec2:DescribeInstances",
        Effect   = "Allow",
        Resource = "*"
      }
  ]
})
  
}

resource "aws_iam_instance_profile" "iam-for-ec2-create-s33" {
  name = "iam-for-ec2-create-s33"
  role = aws_iam_role.s3_access_role.name
}