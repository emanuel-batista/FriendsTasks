# API Escola Conectada

API REST em Java Spring Boot para comunicação entre professores e pais de alunos do 1º ao 4º ano.

## Como executar

```bash
mvn spring-boot:run
```

## Acessos

- API: http://localhost:8080
- Swagger: http://localhost:8080/swagger-ui.html
- H2 Console: http://localhost:8080/h2-console

Configuração do H2:

- JDBC URL: `jdbc:h2:mem:escoladb`
- Usuário: `sa`
- Senha: deixar em branco

## Endpoints principais

- `POST /responsaveis`
- `GET /responsaveis`
- `POST /alunos`
- `GET /alunos`
- `POST /professores`
- `GET /professores`
- `POST /comunicados`
- `GET /comunicados`
- `GET /comunicados/aluno/{idAluno}`
- `POST /respostas`
- `GET /respostas/comunicado/{idComunicado}`
