# Creatting Elastic Container Service Cluster
resource "aws_ecs_cluster" "main" {
  name = "py-cluster"
}

data "template_file" "py_app" {
  template = file("./setup-pipeline-steps/templates/ecs/python_app.json.tpl")

  vars = {
    app_image      = "417311404467.dkr.ecr.us-west-2.amazonaws.com/guilhermerenew/python-app"
    app_port       = 8000
    fargate_cpu    = 1024
    fargate_memory = 2048
    aws_region     = "us-west-2"
  }
}

# Creating ECS Service 
resource "aws_ecs_service" "main" {
  name            = "cb-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "cb-app"
    container_port   = 8000
  }

  depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

# Creating ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "py-app-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = data.template_file.py_app.rendered
}