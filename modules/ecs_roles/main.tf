/*
   네이밍 규칙
  {환경}_{프로젝트명}_*
*/


// frog 프로젝트 role 
resource "aws_iam_role" "dev_frog_ecs_task_role" {
  name = "dev_frog_ecs_task_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Service: ["ecs-tasks.amazonaws.com"]
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_policy" "dev_frog_ecs_task_policy" {
  name        = "dev_frog_ecs_task_policy"
  path        = "/"

  # Terraform's "jsonencode" function converts a
  policy = jsonencode({
      Version : "2012-10-17",
      Statement: [
      {
        Action: ["ssm:DescribeParameters"],
        Effect: "Allow",
        Resource: "*"
      },
      {
        Action: ["ssm:*"],
        Effect: "Allow",
        Resource: "*"
      },
      {
        Action: ["s3:*"],
        Effect: "Allow",
        Resource: "arn:aws:s3:::dev-frog/*"
      },
      {
        Action: ["ses:*"],
        Effect: "Allow",
        Resource: "*"
      }
    ]
})
}

resource "aws_iam_policy_attachment" "dev_frog_ecs_task_role_attachment" {
  name       = "dev_frog_ecs_task_role"
  roles      = ["${aws_iam_role.dev_frog_ecs_task_role.name}"]
  policy_arn = aws_iam_policy.dev_frog_ecs_task_policy.arn
}


// ecs task execution role create
resource "aws_iam_role" "dev_frog_ecs_task_execution_role" {
  name = "dev_frog_ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Service: ["ecs-tasks.amazonaws.com"]
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "dev_frog_ecs_task_execution_policy" {
  name        = "dev_frog_ecs_task_execution_policy"
  path        = "/"

  // ecr, cloudwatch full access
  policy = jsonencode({
    Version : "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: [
          "ecr:*",
          "cloudwatch:*",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ssm:*"
        ],
        Resource: "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "dev_frog_ecs_task_execution_role_attachment" {
  name       = "dev_frog_ecs_task_execution_role"
  roles      = ["${aws_iam_role.dev_frog_ecs_task_execution_role.name}"]
  policy_arn = aws_iam_policy.dev_frog_ecs_task_execution_policy.arn
}



// food 프로젝트 role

resource "aws_iam_role" "dev_food_ecs_task_role" {
  name = "dev_food_ecs_task_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Service: ["ecs-tasks.amazonaws.com"]
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_policy" "dev_food_ecs_task_policy" {
  name        = "dev_food_ecs_task_policy"
  path        = "/"

  # Terraform's "jsonencode" function converts a
  policy = jsonencode({
      Version : "2012-10-17",
      Statement: [
      {
        Action: ["ssm:DescribeParameters"],
        Effect: "Allow",
        Resource: "*"
      },
      {
        Action: ["ssm:*"],
        Effect: "Allow",
        Resource: "*"
      },
      {
        Action: ["s3:*"],
        Effect: "Allow",
        Resource: "arn:aws:s3:::dev-food-recommendation/*"
      },
      {
        Action: ["ses:*"],
        Effect: "Allow",
        Resource: "*"
      }
    ]
})
}

resource "aws_iam_policy_attachment" "dev_food_ecs_task_role_attachment" {
  name       = "dev_food_ecs_task_role"
  roles      = ["${aws_iam_role.dev_food_ecs_task_role.name}"]
  policy_arn = aws_iam_policy.dev_food_ecs_task_policy.arn
}


// ecs task execution role create
resource "aws_iam_role" "dev_food_ecs_task_execution_role" {
  name = "dev_food_ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Service: ["ecs-tasks.amazonaws.com"]
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "dev_food_ecs_task_execution_policy" {
  name        = "dev_food_ecs_task_execution_policy"
  path        = "/"

  // ecr, cloudwatch full access
  policy = jsonencode({
    Version : "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: [
          "ecr:*",
          "cloudwatch:*",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ssm:*"
        ],
        Resource: "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "dev_food_ecs_task_execution_role_attachment" {
  name       = "dev_food_ecs_task_execution_role"
  roles      = ["${aws_iam_role.dev_food_ecs_task_execution_role.name}"]
  policy_arn = aws_iam_policy.dev_food_ecs_task_execution_policy.arn
}