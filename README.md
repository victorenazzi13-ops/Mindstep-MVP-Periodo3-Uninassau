# MindStep

MindStep é um aplicativo desenvolvido para auxiliar pessoas que enfrentam dificuldades com organização, foco e sobrecarga diante de tarefas complexas, utilizando a divisão de atividades em microetapas.

Projeto acadêmico desenvolvido para as disciplinas de:

- Desenvolvimento para Dispositivos Móveis
- Back-End Frameworks

---

## Objetivo

A proposta do aplicativo é reduzir a ansiedade e a sobrecarga causadas por tarefas complexas, transformando atividades maiores em pequenas ações mais simples e executáveis.

### Exemplo

Ao invés de:

```txt
Estudar Backend
```

o usuário pode dividir em:

```txt
Abrir notebook
Abrir VS Code
Revisar Node.js
Testar endpoints
```

A ideia central do MindStep é tornar tarefas grandes mais acessíveis por meio de pequenos passos, incentivando foco, consistência e produtividade.

---

## Tecnologias utilizadas

### Frontend
- Flutter
- Dart

### Backend
- Node.js
- Express
- MySQL
- JWT
- bcryptjs

---

## Estrutura do projeto

```txt
mindstep/
┣ frontend/
┗ backend/
```

---

## Funcionalidades

- Cadastro de usuário
- Login com autenticação JWT
- Persistência de sessão
- Logout
- CRUD de rotinas
- CRUD de microetapas
- Dashboard de progresso
- Barra de progresso por rotina
- Modo foco para execução passo a passo
- Frases motivacionais aleatórias durante o foco
- Confete ao concluir uma rotina
- Proteção de rotas autenticadas
- Separação de dados por usuário
- Persistência com banco de dados MySQL

---

## Como executar

### Backend

```bash
cd backend
npm install
npm run dev
```

### Frontend

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

---

## Endpoints da API

### Autenticação

#### Cadastro de usuário
```http
POST /register
```

Body:
```json
{
  "name": "Nome do usuário",
  "email": "usuario@email.com",
  "password": "123456"
}
```

#### Login
```http
POST /login
```

Body:
```json
{
  "email": "usuario@email.com",
  "password": "123456"
}
```

Retorna token JWT para autenticação.

---

### Rotinas (rotas protegidas com JWT)

#### Criar rotina
```http
POST /routines
```

#### Listar rotinas
```http
GET /routines
```

#### Atualizar rotina
```http
PUT /routines/:id
```

#### Excluir rotina
```http
DELETE /routines/:id
```

---

### Microetapas (rotas protegidas com JWT)

#### Criar microetapa
```http
POST /steps
```

#### Listar microetapas de uma rotina
```http
GET /steps/:routine_id
```

#### Atualizar microetapa
```http
PUT /steps/:id
```

#### Excluir microetapa
```http
DELETE /steps/:id
```

---

## Equipe de desenvolvimento

| Nome | Matrícula | Curso |
|------|----------|-------|
| Anthony Vasconcelos Menezes de Oliveira | 16037641 | ADS |
| Denisson Victor Santos Santana | 16037458 | ADS |
| João Victor de Oliveira Alves | 16037240 | ADS |
| Kauan Matheus Trindade Nascimento | 16037603 | ADS |
| Natanael Rosa Santos | 16037192 | ADS |
| Pedro Ivo Araújo Tavares | 16037531 | ADS |

---

## Observação

Projeto acadêmico desenvolvido como atividade prática integrando desenvolvimento mobile e backend, com foco em autenticação, persistência de dados e experiência do usuário.