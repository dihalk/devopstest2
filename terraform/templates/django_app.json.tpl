[  
  {
    "name": "django-app",
    "image": "${DOCKER_IMAGE_URL}",
    "essential": true,
    "cpu": 10,
    "memory": 512,
    "links": [],
    "portMappings": [
      {
        "containerPort": 8000,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "DATABASE_NAME",
        "value": "devopstest"
      },
      {
        "name": "DATABASE_USERNAME",
        "value": "devopstest"
      },
      {
        "name": "DATABASE_PASSWORD",
        "value": "devopstest"
      },
      {
        "name": "DATABASE_HOST",
        "value": "${app1_hostname}"
      },
      {
        "name": "DATABASE_PORT",
        "value": "3306"
      }
    ],
  }
]
