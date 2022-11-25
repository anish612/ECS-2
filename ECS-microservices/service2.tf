# resource "aws_ecrpublic_repository" "repo-2" {
#     repository_name = "repo-2"
# }



# #creating task definition
# resource "aws_ecs_task_definition" "td-2" {
#   family = "HTTPserver"
#   requires_compatibilities = ["FARGATE"]
#   network_mode =   "awsvpc"
#   cpu                      = 256
#   memory                   = 512
#   execution_role_arn = data.aws_iam_role.ecs-task.arn

#   container_definitions = jsonencode([
#     {
#       name = "test-container"
#       image  = aws_ecrpublic_repository.repo-2.repository_uri 
#       cpu = 256
#       memory = 512
#       portMappings = [
#           {
#             containerPort = 80
#           }
#         ]
#   }
#   ])
# }



# #creating ECS service]

# resource "aws_ecs_service" "service-2" {
#   name = "service-2"
#   cluster = aws_ecs_cluster.test-cluster.id
#   task_definition = aws_ecs_task_definition.td-2.id
#   desired_count = 2
#   launch_type = "FARGATE"


#   network_configuration {
#     subnets  = [aws_subnet.testsubnet-1.id,aws_subnet.testsubnet-2.id]
#     security_groups = [aws_security_group.test-sg.id]
#     assign_public_ip = true
#   }

  
# }
