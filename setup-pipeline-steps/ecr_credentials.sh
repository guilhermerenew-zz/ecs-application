#!/usr/bin/env bash
# Script basico realiza a cricao de um diretorio aws para o agent do pipeline carregue corretamente as credenciais fornecidas em TravisCI. 
mkdir -p ~/.aws
cat > ~/.aws/credentials << EOL
[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
EOL

cat > ~/.aws/config << EOL
[default]
region = us-west-2
output = text
EOL