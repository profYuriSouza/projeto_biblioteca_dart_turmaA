import 'dart:io';

import '../lib/src/services/biblioteca.dart';
import '../lib/src/models/usuario.dart';
import '../lib/src/models/item.dart';
import '../lib/src/utils/console.dart';

void main() {
  // ===========================================================================
  // PONTO DE ENTRADA DO PROGRAMA (console)
  // - Mantemos o "menu" aqui, e a regra de negócio no serviço (Biblioteca).
  // - Essa separação melhora manutenção e evita um main() gigante.
  // ===========================================================================

  final biblioteca = Biblioteca();

  // Dados de exemplo ajudam a demonstrar rapidamente em aula, e também servem
  // como "caso de teste manual" para validar o fluxo.
  biblioteca.popularDadosDeExemplo();

  while (true) {
    print('\n================= BIBLIOTECA ESCOLAR (CONSOLE) =================');
    print('1) Cadastrar pessoa');
    print('2) Cadastrar item');
    print('3) Listar pessoas');
    print('4) Listar itens');
    print('5) Buscar item por título');
    print('6) Realizar empréstimo');
    print('7) Devolver item');
    print('8) Relatórios');
    print('0) Sair');
    print('=================================================================');

    final opcao = Console.lerInt(
      mensagem: 'Escolha uma opção: ',
      minimo: 0,
      maximo: 8,
    );

    switch (opcao) {
      case 1:
        _menuCadastrarPessoa(biblioteca);
        break;

      case 2:
        _menuCadastrarItem(biblioteca);
        break;

      case 3:
        _menuListarPessoas(biblioteca);
        break;

      case 4:
        _menuListarItens(biblioteca);
        break;

      case 5:
        _menuBuscarItem(biblioteca);
        break;

      case 6:
        _menuEmprestimo(biblioteca);
        break;

      case 7:
        _menuDevolucao(biblioteca);
        break;

      case 8:
        _menuRelatorios(biblioteca);
        break;

      case 0:
        print('Encerrando...');
        return;

      default:
        // Em teoria, não chega aqui porque validamos min/max na leitura.
        print('Opção inválida.');
    }
  }
}

void _menuCadastrarPessoa(Biblioteca biblioteca) {
  print('\n--- Cadastro de Pessoa ---');

  // Usamos stdout.write para manter o cursor na mesma linha (prompt clássico).
  // print() sempre quebra linha no final. Em console, isso melhora usabilidade.
  final id = Console.lerInt(mensagem: 'ID numérico: ', minimo: 1);

  final nome = Console.lerStringNaoVazia(mensagem: 'Nome: ');
  final contato = Console.lerStringNaoVazia(
    mensagem: 'Contato (ex.: e-mail): ',
  );

  print('Perfis disponíveis:');
  print('1) Aluno');
  print('2) Professor');
  final tipo = Console.lerInt(
    mensagem: 'Escolha o perfil: ',
    minimo: 1,
    maximo: 2,
  );

  try {
    // A decisão do tipo concreto (Aluno/Professor) acontece aqui.
    // A partir daí, o resto do sistema trata ambos como Usuario (polimorfismo).
    final Usuario pessoa = (tipo == 1)
        ? Aluno(id: id, nome: nome, contato: contato)
        : Professor(id: id, nome: nome, contato: contato);

    biblioteca.cadastrarUsuario(pessoa);
    print('Pessoa cadastrada com sucesso.');
  } catch (e) {
    print('Falha ao cadastrar pessoa: $e');
  }
}

void _menuCadastrarItem(Biblioteca biblioteca) {
  print('\n--- Cadastro de Item ---');

  final id = Console.lerInt(mensagem: 'ID numérico: ', minimo: 1);
  final titulo = Console.lerStringNaoVazia(mensagem: 'Título: ');

  print('Tipos disponíveis:');
  print('1) Livro');
  print('2) Revista');
  final tipo = Console.lerInt(
    mensagem: 'Escolha o tipo: ',
    minimo: 1,
    maximo: 2,
  );

  try {
    // Campos diferentes por tipo (o aluno escolhe como modelar).
    // Aqui, mantemos um exemplo simples e didático.
    if (tipo == 1) {
      final autor = Console.lerStringNaoVazia(mensagem: 'Autor: ');
      final ano = Console.lerInt(mensagem: 'Ano (ex.: 2020): ', minimo: 0);

      final item = Livro(id: id, titulo: titulo, autor: autor, ano: ano);

      biblioteca.cadastrarItem(item);
      print('Livro cadastrado com sucesso.');
    } else {
      final edicao = Console.lerInt(mensagem: 'Edição (ex.: 15): ', minimo: 1);

      final item = Revista(id: id, titulo: titulo, edicao: edicao);

      biblioteca.cadastrarItem(item);
      print('Revista cadastrada com sucesso.');
    }
  } catch (e) {
    print('Falha ao cadastrar item: $e');
  }
}

void _menuListarPessoas(Biblioteca biblioteca) {
  print('\n--- Pessoas Cadastradas ---');

  final pessoas = biblioteca.listarUsuarios();

  if (pessoas.isEmpty) {
    print('Nenhuma pessoa cadastrada.');
    return;
  }

  for (final p in pessoas) {
    print(p.descricaoDetalhada());
  }
}

void _menuListarItens(Biblioteca biblioteca) {
  print('\n--- Itens Cadastrados ---');

  final itens = biblioteca.listarItens();

  if (itens.isEmpty) {
    print('Nenhum item cadastrado.');
    return;
  }

  for (final item in itens) {
    print(item.descricaoDetalhada());
  }
}

void _menuBuscarItem(Biblioteca biblioteca) {
  print('\n--- Busca por Título ---');

  final termo = Console.lerStringNaoVazia(mensagem: 'Digite parte do título: ');

  final resultados = biblioteca.buscarItensPorTitulo(termo);

  if (resultados.isEmpty) {
    print('Nenhum item encontrado para "$termo".');
    return;
  }

  print('Encontrados ${resultados.length} item(ns):');
  for (final item in resultados) {
    print(item.descricaoDetalhada());
  }
}

void _menuEmprestimo(Biblioteca biblioteca) {
  print('\n--- Realizar Empréstimo ---');

  final usuarioId = Console.lerInt(mensagem: 'ID da pessoa: ', minimo: 1);
  final itemId = Console.lerInt(mensagem: 'ID do item: ', minimo: 1);

  try {
    final emprestimo = biblioteca.realizarEmprestimo(
      usuarioId: usuarioId,
      itemId: itemId,
    );

    print('Empréstimo realizado com sucesso:');
    print(emprestimo.descricaoDetalhada());
  } catch (e) {
    print('Falha ao realizar empréstimo: $e');
  }
}

void _menuDevolucao(Biblioteca biblioteca) {
  print('\n--- Devolver Item ---');

  final itemId = Console.lerInt(mensagem: 'ID do item a devolver: ', minimo: 1);

  try {
    final resultado = biblioteca.devolverItem(itemId: itemId);

    print('Devolução concluída:');
    print(resultado.descricaoDetalhada());
  } catch (e) {
    print('Falha ao devolver item: $e');
  }
}

void _menuRelatorios(Biblioteca biblioteca) {
  print('\n--- Relatórios ---');

  print('1) Itens disponíveis');
  print('2) Itens emprestados');
  print('3) Empréstimos em aberto (ordenados por vencimento)');
  print('4) Resumo (ativos e atrasados)');
  final tipo = Console.lerInt(mensagem: 'Escolha: ', minimo: 1, maximo: 4);

  switch (tipo) {
    case 1:
      final disponiveis = biblioteca.listarItensDisponiveis();
      if (disponiveis.isEmpty) {
        print('Nenhum item disponível.');
      } else {
        for (final i in disponiveis) {
          print(i.descricaoDetalhada());
        }
      }
      break;

    case 2:
      final emprestados = biblioteca.listarItensEmprestados();
      if (emprestados.isEmpty) {
        print('Nenhum item emprestado.');
      } else {
        for (final i in emprestados) {
          print(i.descricaoDetalhada());
        }
      }
      break;

    case 3:
      final emAberto = biblioteca.listarEmprestimosEmAbertoOrdenados();
      if (emAberto.isEmpty) {
        print('Nenhum empréstimo em aberto.');
      } else {
        for (final e in emAberto) {
          print(e.descricaoDetalhada());
        }
      }
      break;

    case 4:
      final resumo = biblioteca.gerarResumo();
      print(resumo);
      break;
  }

  // Pausa simples para leitura (evita “piscar” o menu rápido demais).
  stdout.write('\nPressione ENTER para voltar ao menu...');
  stdin.readLineSync();
}
