# simple color palette Generator with lambda and s3
# main configuration for the serverless color palette

resource "random_string" "suffix"{
    length = var.random_suffix_length
    special = false
    upper = false
}



locals { 
    resource_suffix = random_string.suffix.result
    bucket_name = "${var.environment}-color-palette-${local.resource_suffix}"
    function_name = "${var.environment}-color-palette-${local.resource_suffix}"
    role_name = "${var.environment}-color-palette-role-${local.resource_suffix}"
}

# S3 bucket for storing generated palettes

resource "aws_s3_bucket" "pal_storage"{
    bucket = local.bucket_name
    force_destroy = var.s3_force_destroy


    tags = {
      Name = "Color palette storage"
      Description = "Storage for JSON files"
    }
}


resource "aws_s3_bucket_versioning" "pal_storage_version" {
  count = var.enable_s3_versioning ? 1 : 0
  bucket = aws_s3_bucket.pal_storage.id

  versioning_configuration {
    status = "Enabled"
  }

}


resource "aws_s3_bucket_server_side_encryption_configuration" "pal_storage_encrypt" {
    bucket = aws_s3_bucket.pal_storage.id

    rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
        bucket_key_enabled = true
    }
} 

# bucket config to block public access
resource "aws_s3_bucket_public_access_block" "pal_storage_pab" {
  bucket =  aws_s3_bucket.pal_storage.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# IAM role for function follows LP
resource "aws_iam_role" "lambda_exec_role" {
  name = local.role_name

  assume_role_policy = jsonencode({
    version = "2012-10-17"
    statement = [{
      action = "sts:AssumeRole"
      effect = "Allow"
      principal = {
        service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "Lambda execution Role"
    Description = "Least Privilege role for the color palette generator function"
  }
}

# attach basic lambda role for cloudwatch logs
resource "aws_iam_role_policy_attachment" "lambda_exec_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda_exec_role.name
}


# custom IAM for s3 accesss
resource "aws_iam_policy" "lambda_s3_access" {
  name = "${local.role_name}-s3-access"
  description = "Policy to allow Lambda function to read/write to the S3 bucket for palette storage"

  policy = jsonencode({
    version = "2012-10-17"
    Statement = [{
     Effect = "Allow"
     Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
     ]
     Resource = "${aws_s3_bucket.pal_storage.arn}/*"
    },
    {
      Effect = "Allow"
      Action = "s3:ListBucket"
      Resource = aws_s3_bucket.pal_storage.arn
    }
    ]
  })
  tags = {
    Name = "Lamdba S3 access policy"
    Description = "Custom policy for S3 bucket access"
  }
}


# attach s3 policy to lambda role
resource "aws_iam_role_policy_attachment" "lambda_s3_access_role" {
 policy_arn = aws_iam_policy.lambda_s3_access.arn
 role = aws_iam_role.lambda_exec_role.name  
}


# cloudwatch log group for lambda function
resource "aws_cloudwatch_log_group" "lambda_logs" {
  count  = var.enable_cloudwatch_logs ? 1 : 0
  name = "/aws/lambda/${local.function_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "Lambda log group"
    Description = "cloudwatch logs for color palette"
  }
}


data "archive_file" "lambda_zip" {
    type        = "zip"
    output_path = "${path.module}/Lambda_function.zip"
    source_file = "${path.module}/main.py"
}



# now to lambda function 
resource "aws_lambda_function" "pal_generator"{
    filename = data.archive_file.lambda_zip.output_path
    function_name = local.function_name
    role = aws_iam_role.lambda_exec_role.arn
    handler = "main.lambda_handler"
    runtime = "python3.12"
    timeout = var.lambda_timeout
    memory_size = var.lambda_memory_allocation

    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    environment {
      variables = {
        BUCKET_NAME = aws_s3_bucket.pal_storage.bucket
      }
    }

    depends_on = [ 
    aws_cloudwatch_log_group.lambda_logs, 
    aws_iam_role_policy_attachment.lambda_s3_access_role, 
    aws_iam_role_policy_attachment.lambda_exec_basic 
    ]

    tags = {
      Name = "Lambda function"
      Description = "Lambda function for color palette generator"
    }
}

resource "aws_lambda_function_url" "pal_generator_url" {
    function_name = aws_lambda_function.pal_generator.function_name
    authorization_type = "NONE"

    cors {
        allow_credentials = false
        allow_origins = ["*"]
        allow_methods = var.cors_allowed_methods
        allow_headers = var.cors_allowed_headers
        expose_headers = ["date", "keep_alive"]
        max_age = 86400
    }
}


resource "aws_lambda_permission" "allow_function_url" {
  statement_id = "AllowPublicAccess"
  action = "lambda:InvokeFunctionUrl"
  function_name = aws_lambda_function.pal_generator.function_name
  principal = "*"
  function_url_auth_type = "NONE"
}