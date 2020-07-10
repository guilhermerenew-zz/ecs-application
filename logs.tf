# logs.tf
# Configuracao de Metricas no cloud CLoudWatch, onde é definido um nome para o grupo de monitoracao: app-log-group, e é atribuido uma regra de retencao dos logs para 30 dias!  
resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/py-app"
  retention_in_days = 30

  tags = {
    Name = "app-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  name           = "app-log-stream"
  log_group_name = aws_cloudwatch_log_group.app_log_group.name
}

