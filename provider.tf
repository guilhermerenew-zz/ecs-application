# Arquivo especifica o provider utilizado e atribui as
# variaveis de acesso as credenciais aws! 
provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
  region                  = var.aws_region
}