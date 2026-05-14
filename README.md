# Friends Tasks

Gerenciamento de tarefas compartilhadas entre amigos — API REST em Java/Spring Boot consumida por um app mobile em Flutter.

## Estrutura

```
FriendsTasks/
├── api-escola-conectada/   # API REST (Java + Spring Boot)
├── friends_tasks/          # App mobile (Flutter)
└── iniciar.bat             # Script para rodar tudo de uma vez
```

## Tecnologias

| Camada | Tecnologia |
|--------|-----------|
| API | Java 17, Spring Boot, Spring Data JPA |
| Banco | H2 (in-memory) |
| App | Flutter (web / Android / iOS) |
| HTTP | `package:http` |

## Pré-requisitos

- Java 17+
- Maven (para recompilar a API após alterações)
- Flutter 3.x

## Como rodar

### 1. Compilar a API (necessário após qualquer alteração)

```bash
mvn clean package -f api-escola-conectada/pom.xml -DskipTests
```

### 2. Iniciar tudo

```bat
iniciar.bat
```

O script sobe a API na porta `8080` e abre o app no Chrome.

### Rodar separadamente

```bash
# API
java -jar api-escola-conectada/target/api-escola-conectada-0.0.1-SNAPSHOT.jar

# App (web)
cd friends_tasks
flutter run -d chrome
```

## Endpoints da API

Base URL: `http://localhost:8080/api`

| Método | Rota | Descrição |
|--------|------|-----------|
| `POST` | `/usuarios` | Cadastrar usuário |
| `GET` | `/usuarios` | Listar usuários |
| `POST` | `/tarefas` | Cadastrar tarefa |
| `GET` | `/tarefas/usuario/{id}` | Tarefas de um usuário (próprias + compartilhadas) |
| `POST` | `/tarefas/{id}/compartilhar/{amigoId}` | Compartilhar tarefa |
| `PATCH` | `/tarefas/{id}/status` | Atualizar status (`PENDENTE`, `EM_ANDAMENTO`, `CONCLUIDA`) |

**Swagger UI:** `http://localhost:8080/swagger-ui.html`  
**H2 Console:** `http://localhost:8080/h2-console`

## Funcionalidades do App

- Listar e cadastrar usuários
- Visualizar tarefas próprias e compartilhadas
- Criar tarefas
- Compartilhar tarefa com outro usuário (toque longo no card)
- Atualizar status da tarefa (toque no card)

## Autores

- **Manu Batista** — App Flutter
- **Otávio Chile** — API REST
