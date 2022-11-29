resource "aws_ecrpublic_repository" "repo-1" {
    repository_name = "repo-1"
}



#creating task definition
resource "aws_ecs_task_definition" "td-1" {
  family = "HTTPserver"
  requires_compatibilities = ["FARGATE"]
  network_mode =   "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn = data.aws_iam_role.ecs-task.arn

  container_definitions = jsonencode([
    {
      name = "test-container"
      image  = aws_ecrpublic_repository.repo-1.repository_uri 
      cpu = 256
      memory = 512
      portMappings = [
          {
            containerPort = 80
          }
        ]
  }
  ])
}



#creating ECS service]

resource "aws_ecs_service" "service-1" {
  name = "service-1"
  cluster = aws_ecs_cluster.test-cluster.id
  task_definition = aws_ecs_task_definition.td-1.id
  desired_count = 2
  launch_type = "FARGATE"


  network_configuration {
    subnets  = [aws_subnet.testsubnet-1.id,aws_subnet.testsubnet-2.id]
    security_groups = [aws_security_group.test-sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.test-tg.arn
    container_name = "test-container"
    container_port = "80"
  }

  
}


#codebuild
resource "aws_codebuild_project" "build-1" {
  name           = "build-1"
  description    = "test_codebuild_project_cache"
  build_timeout  = "50"
  queued_timeout = "350"

  service_role = aws_iam_role.build-role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/anish612/ECS-Buildspec-Dockerfile.git"
    git_clone_depth = 1
  }

   tags = {
    Environment = "Test"
  }
}


#Pipeline

resource "aws_codepipeline" "Pipeline-1" {
  name = "Pipeline-1"
  role_arn = data.aws_iam_role.pipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.mybucket-ecs1087.bucket
    type = "S3"
  }

  #Source
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      input_artifacts  = []
      output_artifacts = ["source_output"]

      configuration = {
        Owner = "anish612"
        Repo = "ECS-Buildspec-Dockerfile"
        Branch = "main"
        OAuthToken = "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"
      }
    }
  }


  #Build
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = "build-1"
      }  
    }
  }

  #Deploy
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ClusterName = "test-cluster"
        ServiceName = "service-1"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}
