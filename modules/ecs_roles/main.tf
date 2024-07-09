// ecs task role create
resource "aws_iam_role" "ecs_default_task_role" {
  name = "${var.environment}_${var.cluster}_default_task_role"

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


resource "aws_iam_policy" "ecs_default_task_policy" {
  name        = "${var.environment}_${var.cluster}_ecs_default_task_policy"
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
      }
    ]
})
}

resource "aws_iam_policy_attachment" "ecs_task_role" {
  name       = "${var.environment}_${var.cluster}_ecs_task_role"
  roles      = ["${aws_iam_role.ecs_default_task_role.name}"]
  policy_arn = aws_iam_policy.ecs_default_task_policy.arn
}


// ecs task execution role create
resource "aws_iam_role" "ecs_default_task_execution_role" {
  name = "${var.environment}_${var.cluster}_default_task_execution_role"

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

resource "aws_iam_policy" "ecs_default_task_execution_policy" {
  name        = "${var.environment}_${var.cluster}_ecs_default_task_execution_policy"
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
          "logs:PutLogEvents"
        ],
        Resource: "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution_role" {
  name       = "${var.environment}_${var.cluster}_ecs_task_execution_role"
  roles      = ["${aws_iam_role.ecs_default_task_execution_role.name}"]
  policy_arn = aws_iam_policy.ecs_default_task_execution_policy.arn
}