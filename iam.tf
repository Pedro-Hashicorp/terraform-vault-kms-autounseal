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
