resource "aws_iam_role" "s3_access_role" {
  name = "s3_access_role_prueba"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

}

resource "aws_iam_role_policy" "s3_access_policy" {
  name = "s3_access_policy"
  role = aws_iam_role.s3_access_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:*"
        ],
        Effect   = "Allow",
        Resource = [
          "${aws_s3_bucket.my_bucket.arn}",
          "${aws_s3_bucket.my_bucket.arn}/*"
        ]
      }
    ]
  })
  
}

resource "aws_iam_role_policy_attachment" "vault_kms_attach" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.kms_access.arn
}

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
    }
  ]
})
  
}

resource "aws_iam_instance_profile" "iam-for-ec2-create-s33" {
  name = "iam-for-ec2-create-s33"
  role = aws_iam_role.s3_access_role.name
}