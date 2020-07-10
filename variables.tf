# variables.tf
# Variavis de Ambiente!
variable "aws_region" {
  description = "Regiao para criacao de infraestrutura, eu escolhi Paris..."
  default     = "eu-west-3"
}

variable "ecs_task_execution_role_name" {
  description = "Nome dado a task-role ECS"
  default = "ECSTaskExecutionRole"
}

variable "az_count" {
  description = "Numero de AZs por regiao!"
  default     = "2"
}

# Configuracao de container ECS Fargate com imagem gerada! 
variable "app_image" {
  description = "imagem docker utilizada pata execucao do container ECS"
  default     = "417311404467.dkr.ecr.eu-west-3.amazonaws.com/guilhermerenew/python-app:latest"
}
# Espose da porta 8000 do container para conexao
variable "app_port" {
  description = "Porta exposta pela imagem do docker para redirecionamento de trafego"
  default     = 8000
}
# Numero de containers rodando para execucao
variable "app_count" {
  description = "Numero de container rodando...."
  default     = 1
}
# HC em /
variable "health_check_path" {
  default = "/"
}
# Definicoes de recursos do container ECS :) 
variable "fargate_cpu" {
  description = "Unidades de CPU da instância Fargate a provisionar (1 vCPU = 1024 unidades de CPU)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Memória da instância do Fargate para provisionar (no MiB)"
  default     = "2048"
}

