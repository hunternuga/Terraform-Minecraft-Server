terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.49.0"
    }
  }
}

data "aws_ami" "ubuntu" {
    most_recent = true
}

resource "aws_instance" "minecraft_server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    tags = {
      Name = "Test"
    }
}

resource "aws_iam_policy" "minecraft_policy" {
  name = "minecraft-policy"
  description = "My Minecraft Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = [
                "ec2:DescribeInstances",
                "ec2:StartInstances",
                "ec2:DescribeTags",
                "logs:*",
                "ec2:DescribeInstanceTypes",
                "ec2:StopInstances",
                "ec2:DescribeInstanceStatus"
            ]
            Effect: "Allow"
            Resource: "*"
        },
     ]
  })
}

resource "aws_iam_role" "minecraft-role" {
  name = "my_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect: "Allow"
        Sid = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_lambda_function" "test_lambda" {
  filename = "deployment_package.zip"
  function_name = "test_lambda"
  role = aws_iam_role.minecraft-role.arn
  runtime = "python3.9"
  handler = "index.test"
}

resource "aws_cloudwatch_event_rule" "console" {
  name = "start-stop-event"
  description = "Event Rule created to ensure that instance is stopped and started with Python script."

  event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["stopped"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "Check_Instance_State" {
  rule = aws_cloudwatch_event_rule.console.name
  target_id = aws_lambda_function.test_lambda.function_name
  arn = aws_lambda_function.test_lambda.arn
}
