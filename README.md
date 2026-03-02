Tema: Biblioteca Escolar — Empréstimos com Regras Diferentes

Você foi contratado para implementar um sistema de linha de comando (console) para controlar empréstimos de uma biblioteca escolar. O sistema será usado por funcionários com pouca familiaridade técnica, então deve ser simples, robusto e tolerante a entradas inválidas.

A biblioteca possui:

Pessoas que realizam empréstimos (há pelo menos dois perfis diferentes, com regras distintas de limite e prazo).

Itens que podem ser emprestados (há pelo menos dois tipos diferentes, com regras distintas de multa/atraso e/ou tratamento).

Empréstimos, que conectam uma pessoa e um item, registrando datas e situação do empréstimo.

Regras funcionais (o que o sistema deve fazer)

Cadastro e consulta

Permitir cadastrar pessoas (com identificador único, nome e contato).

Permitir cadastrar itens (com identificador único, título e dados complementares).

Permitir listar pessoas e itens.

Permitir buscar itens por parte do título (ex.: “harry” encontra “Harry Potter…”).

Empréstimo

Permitir realizar empréstimo informando quem e qual item.

O empréstimo só pode acontecer se:

A pessoa existir.

O item existir.

O item estiver disponível.

A pessoa não tiver excedido seu limite de empréstimos em aberto.

Ao emprestar, registrar:

data do empréstimo,

data prevista de devolução (depende do perfil da pessoa).

Devolução

Permitir devolver um item (informando qual item está sendo devolvido).

Ao devolver, o sistema deve:

encerrar o empréstimo (registrar data de devolução),

tornar o item novamente disponível,

calcular multa, se houver atraso (o cálculo depende do tipo do item).

Relatórios

Listar itens disponíveis.

Listar itens emprestados.

Listar empréstimos em aberto, ordenados por data prevista (primeiros a vencer no topo).

Mostrar um resumo: quantos empréstimos ativos existem e quantos estão atrasados.

Regras de qualidade (como você deve implementar)

O sistema deve rodar em loop com um menu até o usuário escolher sair.

O código deve evitar estados inválidos (por exemplo: e-mail/contato vazio, título vazio, ano negativo, etc.).

O sistema deve ser extensível: no futuro pode surgir um novo perfil de pessoa ou um novo tipo de item com regras próprias, e isso não deve exigir “refazer tudo”.

Você pode armazenar tudo apenas em memória (não precisa salvar em arquivo nem banco).

Fique livre para escolher como representar identificadores, regras e validações, desde que o comportamento esteja correto.
