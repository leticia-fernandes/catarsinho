# Catarsinho

### Clonando o projeto

`git clone https://github.com/leticia-fernandes/catarsinho.git`

### Executando docker

Entrar na pasta do projeto

`cd catarsinho`

Executar os seguintes comandos

- `docker-compose build`
- `docker-compose up`

Em um outro terminal executar o comando:

- `docker-compose run web rails db:create db:migrate db:seed`

### Abrindo o sistema

Acessar no navegador

`http://localhost:3000`
