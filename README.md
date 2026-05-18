# MindStep

MindStep é um aplicativo desenvolvido para auxiliar pessoas neurodivergentes, especialmente pessoas com TDAH, na organização da rotina por meio da divisão de tarefas em microetapas.

Projeto acadêmico desenvolvido para as disciplinas de:

- Desenvolvimento para Dispositivos Móveis
- Back-End

## Objetivo

A proposta do aplicativo é reduzir a sobrecarga causada por tarefas complexas, transformando atividades maiores em pequenas ações mais simples e executáveis.

Exemplo:

Ao invés de:

```txt
Estudar Backend
```

o usuário pode dividir em:

```txt
- Abrir notebook
- Abrir VS Code
- Revisar Node.js
- Testar endpoints
```

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
- CRUD de rotinas
- CRUD de microetapas
- Proteção de rotas
- Persistência com MySQL

---

## Como executar

### Frontend

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

### Backend

```bash
cd backend
npm install
npm run dev
```

---

## Autores

Projeto acadêmico desenvolvido por grupo da disciplina.