[
  {
    "essential": true,
    "memory": 256,
    "name": "frog",
    "cpu": 256,
    "image": "${REPOSITORY_URL}:${APP_VERSION}",
    "workingDirectory": "/app",
    "command": ["npm", "start"],
    "portMappings": [
        {
            "containerPort": 3000,
            "hostPort": 3000
        }
    ]
  }
]

