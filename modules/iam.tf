# EC2 인스턴스에서 실행되는 ECS 컨테이너를 위한 IAM 역할을 생성
resource "aws_iam_role" "frog-task-execution-role" {
  name               = "frog-task-execution-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

# ECS EC2 역할에 대한 IAM 인스턴스 프로필을 정의
resource "aws_iam_instance_profile" "frog-task-execution-role" {
  name = "frog-task-execution-role"
  role = aws_iam_role.frog-task-execution-role.name
}


# ECS EC2 역할에 부여되는 정책을 정의
resource "aws_iam_role_policy" "frog-task-execution-role-policy" {
name   = "frog-task-execution-role-policy"
role   = aws_iam_role.frog-task-execution-role.id
policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF

}

# ECS 서비스 역할을 정의
resource "aws_iam_role" "frog-ecs-service-role" {
name = "frog-ecs-service-role"
assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

# ECS 서비스 역할에 미리 정의된 AmazonEC2ContainerServiceRole 정책을 첨부
resource "aws_iam_policy_attachment" "frog-ecs-service-attach1" {
  name       = "frog-ecs-service-attach1"
  roles      = [aws_iam_role.frog-ecs-service-role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}


# ec2 서버 역할 생성
resource "aws_iam_role" "frog-ecs-consul-server-role" {
  name = "frog-ecs-consul-server-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}