#resource "aws_ecr_repository" "django_ecr" {
#  provider             = aws.region-devopstest
#  name                 = "djano-app-repo"
#  image_tag_mutability = "MUTABLE"

#  image_scanning_configuration {
#    scan_on_push = true
#  }

#  tags = {
#    Name = "Djano-applciation-ECR-registry"
#  }
#}