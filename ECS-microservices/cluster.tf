#creating ECS cluster
resource "aws_ecs_cluster" "test-cluster" {
  name = "test-cluster"
  
}

