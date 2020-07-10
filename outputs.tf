# outputs.tf
# No fim da excucao realize o output do dns do load balancer para acesso ao container ECS
output "alb_hostname" {
  value = aws_alb.main.dns_name
}

