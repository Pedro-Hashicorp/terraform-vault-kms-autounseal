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

resource "aws_iam_role_policy" "kms_access" {
  name = "s3_access_policy"
  role = aws_iam_role.s3_access_role.id

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
      "Resource": "arn:aws:kms:eu-west-1:975050084720:key/ec11d974-ffe5-4823-b285-5c0e0907eb98"
    }
  ]
})
  
}

resource "aws_iam_instance_profile" "iam-for-ec2-create-s33" {
  name = "iam-for-ec2-create-s33"
  role = aws_iam_role.s3_access_role.name
}
resource "aws_iam_instance_profile" "iam-for-ec2-create-s33" {
  name = "kms-for-ec2"
  role = aws_iam_role.kms_access
}