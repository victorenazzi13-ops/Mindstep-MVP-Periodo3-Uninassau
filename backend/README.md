# MindStep Backend

Backend do aplicativo MindStep, desenvolvido para auxiliar pessoas neurodivergentes, especialmente com TDAH, na organização de tarefas em microetapas.

## Tecnologias utilizadas

- Node.js
- Express
- MySQL
- JWT (JSON Web Token)
- bcryptjs
- dotenv
- cors

---

## Como rodar o projeto

### 1. Clonar o repositório

```bash
git clone https://github.com/victorenazzi13-ops/mindstep.git
```

### 2. Entrar na pasta backend

```bash
cd backend
```

### 3. Instalar dependências

```bash
npm install
```

### 4. Configurar arquivo .env

Criar arquivo:

```env
.env
```

Com:

```env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=mindstep
JWT_SECRET=mindstep_secret
```

---

## Banco de dados

Criar banco MySQL:

```sql
CREATE DATABASE mindstep;
```

Criar tabelas:

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE routines (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE steps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    routine_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    done BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (routine_id) REFERENCES routines(id) ON DELETE CASCADE
);
```

---

## Rodar servidor

```bash
npm run dev
```

Servidor:

```bash
http://localhost:3000
```

---

# Endpoints

## Autenticação

### Cadastro

```http
POST /api/auth/register
```

Body:

```json
{
  "name": "Victor",
  "email": "victor@email.com",
  "password": "123456"
}
```

---

### Login

```http
POST /api/auth/login
```

Body:

```json
{
  "email": "victor@email.com",
  "password": "123456"
}
```

---

## Rotinas

### Criar rotina

```http
POST /api/routines
```

### Listar rotinas

```http
GET /api/routines
```

### Atualizar rotina

```http
PUT /api/routines/:id
```

### Excluir rotina

```http
DELETE /api/routines/:id
```

---

## Microetapas

### Criar microetapa

```http
POST /api/steps
```

### Listar microetapas

```http
GET /api/steps/:routine_id
```

### Atualizar microetapa

```http
PUT /api/steps/:id
```

### Excluir microetapa

```http
DELETE /api/steps/:id
```

---

## Segurança

Rotas protegidas utilizam:

```http
Authorization: Bearer TOKEN
```

---

## Autor

Projeto acadêmico desenvolvido para as disciplinas de:

- Desenvolvimento para Dispositivos Móveis
- Back-End