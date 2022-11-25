data "aws_iam_role" "pipeline_role" {
  name = "AWSCodePipelineServiceRole-us-east-1-my-sample-pipeline-django"
}

data "aws_iam_role" "ecs-task" {
  name = "test-ecs-role"
}