#create s3 bucket

resource "aws_s3_bucket" "FD_bucket" {
  bucket = var.bucketname
}


resource "aws_s3_bucket_ownership_controls" "FD_bucket" {
  bucket = aws_s3_bucket.FD_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "FD_bucket" {
  bucket = aws_s3_bucket.FD_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.FD_bucket.id
  key    = "anagram.csv"
  source = "anagram.csv"
  content_type = "text"
}

#create role for lambda
resource "aws_iam_role" "lambda_role" {
  name =var.lambdaname
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

#IAM policy for logging from lambda

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
    ]
  })
}

#Policy Attachment on the role.
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role   = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

#Generate an archive from content

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/anagram.js"
  output_path = "${path.module}/lambda/anagram.zip"
} 

#Create a lambda function
#In terraform ${path.module} is the current directory.
resource "aws_lambda_function" "terraform_lambda_function" {
  filename         = "${path.module}/lambda/anagram.zip"
  function_name    = "anagram_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "anagram.handler"
  runtime          = "nodejs18.x"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

#s3 permission to invoke lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.FD_bucket.arn
}

#s3 notification to trigger lambda
resource "aws_s3_bucket_notification" "s3_trigger" {
  bucket = aws_s3_bucket.FD_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.terraform_lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}



