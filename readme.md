# Apresentação
[![Build Status](https://travis-ci.com/guilherme-devops/app-devops.svg?token=WzRcxWWG8F7oHiAqJY3b&branch=master)](https://travis-ci.com/guilherme-devops/app-devops)
> Sinta-se à vontade para criar em cima do problema abaixo. Caso algo não esteja claro, pode assumir o que seja mais claro para você e indique suas suposições em documentação. A especificação é bem básica e, portanto, caso deseje evoluir a ideia seguindo essa base, fique à vontade: por exemplo, utilizar composição de containers, usar ferramentas para facilitar a geração da imagem do container, etc.

## Sobre
Este Projeto se baseia em uma execução simples de API REST em python para realização de chamadas e valores mantidos podem ser consultados por consultas HTTP. Vimos essa aplicação de um modo não só interativo mais que pode ser utilizado em diversas frentes com relação a comunicação e status page. Por se basear em chamadas REST e a uma liguagem de facil execução e interpretação o mapeammento da evolução de plataforma foi divido entre as etapas:

![picture](./imagens/stack-steps.jpg)

Com essas etapas simples, foi construída uma stack de entrega de infraestrutura baseada em diversos pontos com relação a qualidade de software, disponibilidade e resproveitamento de código. Vamos passar por cada uma delas.

## Execucao Manual de app! 
Os comandos de interação com a API são os seguintes:

* Start da app

```
cd app
gunicorn --log-level debug api:app
```

* Criando e listando comentários por matéria

```
# matéria 1
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"first post!","content_id":1}'
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"ok, now I am gonna say something more useful","content_id":1}'
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I agree","content_id":1}'

# matéria 2
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I guess this is a good thing","content_id":2}'
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"charlie@example.com","comment":"Indeed, dear Bob, I believe so as well","content_id":2}'
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"eve@example.com","comment":"Nah, you both are wrong","content_id":2}'

# listagem matéria 1
curl -sv localhost:8000/api/comment/list/1

# listagem matéria 2
curl -sv localhost:8000/api/comment/list/2
```


## App.
Como descrito abaixo o método de consulta com relação a aplicação é basicamente o POST de um novo comentário e a consulta do mesmo. Porém isso não inibe a forma como código estará disponibilizado e para nós voltados a Infra, termos escalabilidade e precisão a cada passo que a aplicação realiza.

## Build Image.
Pensando em emcapsular uma aplicação de forma integra e mantendo os componentes intactos o docker foi a solução mais rápida e simples de disponibilizarmos a aplicação aonde quer que ela esteja. Isso quer dizer que em qualquer com disponibilidade de execução de containers esta imagem será executada da mesma forma.

## Dockerfile.
```dockerfile 
#Base Image from Python Alpine ~95.1MB
FROM python:3.6.4-alpine3.7

#Environment Mapping
WORKDIR /app
ADD     ./app /app
COPY    ./app/requirements.txt /etc

#Deployment App!
RUN     pip install -r /etc/requirements.txt
EXPOSE  8000:8000
CMD     ["gunicorn" , "-b", "0.0.0.0:8000", "--log-level", "debug", "api:app"]
```
Dockerfile é a base inicial para criação e postagem de imagem com aplicação, parametros de inicialização "CMD" são passados diretamente em imagem, automatizando sua inicialização :) 

## Playground Development.
Tal etapa é onde desenvolvemos **e testamos** toda entrega da infraestrutura e como ela será disponibilizada posteriormente. Tal etapa envolve a entrega da infra como código e pipeline de teste automatico do mesmo.

## Push image.
A definição de como e onde seria feito o armazenamento de imagem criada foi pensada em menos etapas de postagens e ferramentas se integrem facil e se possivel centraliza-las. Pensando nisso, o processo de push é feito para Cloud Privada na AWS, sendo que em etapa seguinte a consulta entre repositório e aplicação é mais rapida por estarem em mesma provider.

Funções dentro de .travis.yml realizam a criação de repositório privado, a tag de imagem e o push para Registry:

```yaml
---
- aws ecr create-repository --repository-name guilhermerenew/python-app --image-tag-mutability IMMUTABLE --region us-west-2
- aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 417311404467.dkr.ecr.us-west-2.amazonaws.com
- docker build -t guilhermerenew/python-app .
- docker tag guilhermerenew/python-app:latest 417311404467.dkr.ecr.us-west-2.amazonaws.com/guilhermerenew/python-app:latest
- docker push 417311404467.dkr.ecr.us-west-2.amazonaws.com/guilhermerenew/python-app:latest
```