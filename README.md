## Banco de Dados 3
### Projeto de Data Warehouse (DW)


#### Trabalho de BD3 do Curso Técnologo em Análise e Desenvolvimento de Sistemas (TADS - UFPR)

#### Equipe do Trabalho:
* Albano Roberto Drescher von Maywitz
* Aruni
* Giovani
* Leonardo
* Lucas

## Andamento atual:

1. Criado Projeto e separado por diretórios.
2. Criado um docker-compose para estruturar o banco de dados.
3. Criado um init.sh para criar o banco de dados 'projetodw' e executar o arquivo projetodw-full.sql.
4. Criado o script SQL que monta o banco de dados e popula ele.



## EM FASE DE CONSTRUÇÃO
### Instruções para executar o projeto:

1. Ter o docker (full) instalado.

#### Copiar e executar num terminal linux as linhas abaixo:

##### Fazer clone do repositório e entrar no diretório
```bash
git clone https://github.com/allbano/bd3.git && cd bd3
```

##### No terminal executar o comando abaixo:
```bash
docker-compose up -d
```