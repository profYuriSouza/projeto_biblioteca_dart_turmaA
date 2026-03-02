# Sistema de Biblioteca Escolar — Controle de Empréstimos

## 📚 Descrição

Este é um sistema de linha de comando (console) para controle de empréstimos em uma biblioteca escolar. O projeto foi desenvolvido para ser simples, robusto e tolerante a entradas inválidas, focado na usabilidade por funcionários com pouca familiaridade técnica.

## 🎯 Funcionalidades

O sistema contempla as seguintes entidades principais:

- **Pessoas:** diferentes perfis (com diferentes limites e prazos de empréstimo).
- **Itens:** diferentes tipos (com regras distintas de multa por atraso e/ou tratamento especial).
- **Empréstimos:** conectam uma pessoa e um item, com registro de datas e situação.

### 📝 Cadastro e Consulta

- Cadastro de pessoas (com identificador único, nome e contato).
- Cadastro de itens (com identificador único, título e dados complementares).
- Listagem de pessoas e itens.
- Busca de itens por parte do título (exemplo: buscar "harry" encontra "Harry Potter…").

### 🔄 Empréstimo

- Possibilidade de realizar empréstimos informando quem e qual item.
- O empréstimo só pode ocorrer se todas estas condições forem atendidas:
  - A pessoa existir.
  - O item existir.
  - O item estiver disponível.
  - A pessoa não tiver excedido seu limite de empréstimos em aberto.
- Registro da data do empréstimo e da data prevista de devolução (de acordo com o perfil da pessoa).

### ↩️ Devolução

- Permitir devolução de item, informando qual item está sendo devolvido.
- Ao devolver um item:
  - Encerrar o empréstimo, registrando a data real de devolução.
  - Tornar o item disponível novamente.
  - Calcular multa por atraso, se houver, conforme o tipo do item.

### 📊 Relatórios

- Listar itens disponíveis.
- Listar itens emprestados.
- Listar empréstimos em aberto, ordenados pela data prevista de devolução (primeiros a vencer no topo).
- Mostrar um resumo: total de empréstimos ativos e quantidade de empréstimos atrasados.

## ✨ Qualidade e Extensibilidade

- O sistema roda em loop, exibindo um menu interativo, até o usuário escolher sair.
- Evita estados inválidos (como campos vazios, valores negativos, etc.).
- **Sistema extensível:** permite fácil adição de novos perfis de pessoa ou tipos de item com regras próprias, sem necessidade de grandes modificações no código.
- Todos os dados são armazenados em memória (não é necessário salvar em arquivo ou banco de dados).
- Fique livre para definir como representar identificadores, regras e validações, desde que o funcionamento esteja correto.

## 🚀 Como Executar

1. Clone este repositório:
   ```sh
   git clone https://github.com/profYuriSouza/projeto_biblioteca_dart_turmaA.git
   cd projeto_biblioteca_dart_turmaA
   ```

2. Certifique-se de ter o [Dart SDK](https://dart.dev/get-dart) instalado.

3. Execute o programa via terminal:
   ```sh
   dart run
   ```

O sistema apresentará um menu interativo para todas as operações descritas acima.

## 📋 Estrutura do Projeto

```
projeto_biblioteca_dart_turmaA/
├── bin/
│   └── main.dart          # Ponto de entrada da aplicação
├── lib/
│   ├── models/            # Classes de modelos (Pessoa, Item, Empréstimo)
│   ├── services/          # Lógica de negócios e regras
│   └── ui/                # Interface com o usuário (menus, inputs)
├── pubspec.yaml           # Dependências do projeto
└── README.md              # Este arquivo
```

## 🛠️ Tecnologias Utilizadas

- **Dart:** Linguagem de programação
- **Console I/O:** Entrada e saída em linha de comando

## 📖 Exemplo de Uso

Após executar o programa, você verá um menu como:

```
=== SISTEMA DE BIBLIOTECA ESCOLAR ===
1. Cadastrar Pessoa
2. Cadastrar Item
3. Realizar Empréstimo
4. Devolver Item
5. Listar Relatórios
6. Sair
Escolha uma opção: 
```

## 🎓 Trabalho Acadêmico

Este é um projeto da **Turma A** desenvolvido como exercício prático de programação em Dart, focando em:
- Modelagem de objetos
- Tratamento de erros e validações
- Design extensível e reutilizável
- Interface amigável para usuários não-técnicos

---

**Desenvolvido com ❤️ para a disciplina de Programação em Dart**