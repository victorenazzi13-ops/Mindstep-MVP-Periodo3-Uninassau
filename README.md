# MindStep

MindStep é um aplicativo desenvolvido para auxiliar pessoas que enfrentam dificuldades com organização, foco e sobrecarga diante de tarefas complexas, utilizando a divisão de atividades em microetapas.

Projeto acadêmico desenvolvido para as disciplinas de:

* Desenvolvimento para Dispositivos Móveis
* Back-End Frameworks

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

## Telas do Sistema

### Login

Tela responsável pela autenticação dos usuários.

### Dashboard

Visualização do progresso geral do usuário.

### Rotinas

Gerenciamento das rotinas cadastradas.

### Microetapas

Divisão das tarefas em pequenas ações executáveis.

> As imagens das telas podem ser adicionadas futuramente na pasta `docs/`.

---

## Tecnologias Utilizadas

### Frontend

* Flutter
* Dart

### Backend

* Node.js
* Express
* MySQL
* JWT (JSON Web Token)
* bcryptjs

---

## Arquitetura

O projeto segue uma arquitetura cliente-servidor:

```txt
Flutter (Frontend)
        ↓
API REST (Node.js + Express)
        ↓
      MySQL
```

A comunicação é realizada através de requisições HTTP para uma API REST.

A autenticação utiliza JWT para garantir que cada usuário tenha acesso apenas aos seus próprios dados.

---

## Estrutura do Projeto

```txt
mindstep/
┣ frontend/
┃ ┣ lib/
┃ ┣ assets/
┃ ┗ pubspec.yaml
┃
┣ backend/
┃ ┣ src/
┃ ┃ ┣ config/
┃ ┃ ┣ controllers/
┃ ┃ ┣ middlewares/
┃ ┃ ┣ routes/
┃ ┃ ┗ server.js
┃ ┗ package.json
┃
┗ README.md
```

---

## Funcionalidades

### Autenticação

* Cadastro de usuário
* Login com autenticação JWT
* Persistência de sessão
* Logout
* Proteção de rotas autenticadas

### Rotinas

* Criar rotina
* Listar rotinas
* Atualizar rotina
* Excluir rotina

### Microetapas

* Criar microetapas
* Editar microetapas
* Excluir microetapas
* Marcar etapas como concluídas

### Dashboard

* Acompanhamento de progresso
* Barra de progresso por rotina
* Indicadores visuais de conclusão

### Experiência do Usuário

* Modo foco
* Frases motivacionais aleatórias
* Confete ao concluir uma rotina
* Interface intuitiva
* Feedback visual para ações importantes

### Persistência

* Banco de dados MySQL
* Separação de dados por usuário autenticado

---

## Diferenciais

O MindStep busca oferecer uma experiência mais acessível para usuários que possuem dificuldades com organização e gerenciamento de tarefas.

Entre os diferenciais estão:

* Divisão de tarefas em microetapas
* Dashboard de progresso
* Modo foco
* Frases motivacionais
* Feedback visual com confete
* Organização personalizada de rotinas
* Persistência por usuário
* Autenticação JWT
* Interface simples e objetiva

---

## Como Executar

### Backend

Instale as dependências:

```bash
cd backend
npm install
```

Execute o servidor:

```bash
npm run dev
```

---

### Frontend

Instale as dependências:

```bash
cd frontend
flutter pub get
```

Execute o projeto:

```bash
flutter run -d chrome
```

---

## Endpoints da API

### Autenticação

#### Cadastro de Usuário

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

---

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

Retorna um token JWT para autenticação.

---

### Rotinas

Todas as rotas abaixo exigem autenticação via JWT.

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

### Microetapas

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

## Equipe de Desenvolvimento

| Nome                                    | Matrícula | Curso |
| --------------------------------------- | --------- | ----- |
| Anthony Vasconcelos Menezes de Oliveira | 16037641  | ADS   |
| Denisson Victor Santos Santana          | 16037458  | ADS   |
| João Victor de Oliveira Alves           | 16037240  | ADS   |
| Kauan Matheus Trindade Nascimento       | 16037603  | ADS   |
| Natanael Rosa Santos                    | 16037192  | ADS   |
| Pedro Ivo Araújo Tavares                | 16037531  | ADS   |

---

## Melhorias Futuras

* Notificações de lembretes
* Sincronização em nuvem
* Estatísticas avançadas
* Compartilhamento de rotinas
* Gamificação com conquistas
* Aplicativo para Android e iOS

---

## Observação

Projeto acadêmico desenvolvido com foco na integração entre desenvolvimento mobile e backend, aplicando conceitos de autenticação, persistência de dados, APIs REST e experiência do usuário.

O MindStep foi criado com o objetivo de tornar tarefas complexas mais simples, acessíveis e menos estressantes para seus usuários.
