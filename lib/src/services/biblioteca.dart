import '../models/usuario.dart';
import '../models/item.dart';
import '../models/emprestimo.dart';

class Biblioteca {
  // ===========================================================================
  // SERVIÇO: Biblioteca
  // - Centraliza regras de negócio:
  //   * cadastro
  //   * empréstimo
  //   * devolução
  //   * consultas/relatórios
  //
  // Estruturas usadas:
  // - Map<int, Usuario> para acesso rápido por ID.
  // - Map<int, ItemBiblioteca> para acesso rápido por ID.
  // - List<Emprestimo> para histórico e consultas.
  // ===========================================================================

  final Map<int, Usuario> _usuarios = {};
  final Map<int, ItemBiblioteca> _itens = {};
  final List<Emprestimo> _emprestimos = [];

  // -------------------------
  // CADASTRO
  // -------------------------
  void cadastrarUsuario(Usuario usuario) {
    if (_usuarios.containsKey(usuario.id)) {
      throw StateError('Já existe pessoa com ID ${usuario.id}.');
    }
    _usuarios[usuario.id] = usuario;
  }

  void cadastrarItem(ItemBiblioteca item) {
    if (_itens.containsKey(item.id)) {
      throw StateError('Já existe item com ID ${item.id}.');
    }
    _itens[item.id] = item;
  }

  // -------------------------
  // LISTAGENS
  // -------------------------
  List<Usuario> listarUsuarios() => _usuarios.values.toList();

  List<ItemBiblioteca> listarItens() => _itens.values.toList();

  List<ItemBiblioteca> listarItensDisponiveis() {
    final itens = _itens.values.where((i) => i.disponivel).toList();
    itens.sort((a, b) => a.titulo.compareTo(b.titulo));
    return itens;
  }

  List<ItemBiblioteca> listarItensEmprestados() {
    final itens = _itens.values.where((i) => !i.disponivel).toList();
    itens.sort((a, b) => a.titulo.compareTo(b.titulo));
    return itens;
  }

  // -------------------------
  // BUSCA
  // -------------------------
  List<ItemBiblioteca> buscarItensPorTitulo(String termo) {
    final t = termo.trim().toLowerCase();
    if (t.isEmpty) return [];

    return _itens.values
        .where((item) => item.titulo.toLowerCase().contains(t))
        .toList();
  }

  // -------------------------
  // EMPRÉSTIMO
  // -------------------------
  Emprestimo realizarEmprestimo({required int usuarioId, required int itemId}) {
    final usuario = _usuarios[usuarioId];
    if (usuario == null) {
      throw StateError('Pessoa não encontrada (ID $usuarioId).');
    }

    final item = _itens[itemId];
    if (item == null) {
      throw StateError('Item não encontrado (ID $itemId).');
    }

    if (!item.disponivel) {
      throw StateError('Item já está emprestado.');
    }

    // Contar empréstimos em aberto desse usuário:
    final emAbertoDoUsuario = _emprestimos.where((e) {
      return e.emAberto && e.usuario.id == usuarioId;
    }).length;

    if (emAbertoDoUsuario >= usuario.limiteEmprestimosAbertos) {
      throw StateError(
        'Limite de empréstimos em aberto atingido (${usuario.limiteEmprestimosAbertos}).',
      );
    }

    // Agora podemos efetivar o empréstimo.
    // - item: marca como emprestado
    // - cria Emprestimo com datas
    item.marcarEmprestado();

    final agora = DateTime.now();
    final prevista = agora.add(Duration(days: usuario.prazoDiasEmprestimo));

    final emprestimo = Emprestimo(
      usuario: usuario,
      item: item,
      dataEmprestimo: agora,
      dataPrevistaDevolucao: prevista,
    );

    _emprestimos.add(emprestimo);
    return emprestimo;
  }

  // -------------------------
  // DEVOLUÇÃO
  // -------------------------
  Emprestimo devolverItem({required int itemId}) {
    final item = _itens[itemId];
    if (item == null) {
      throw StateError('Item não encontrado (ID $itemId).');
    }

    // Encontrar o empréstimo em aberto desse item.
    // Observação: em um sistema real, poderia haver múltiplos empréstimos no histórico,
    // mas apenas 1 em aberto por item.
    final emprestimoAberto = _emprestimos.where((e) {
      return e.emAberto && e.item.id == itemId;
    }).toList();

    if (emprestimoAberto.isEmpty) {
      throw StateError('Não existe empréstimo em aberto para este item.');
    }

    // Se houver mais de um, é inconsistência de estado.
    if (emprestimoAberto.length > 1) {
      throw StateError(
        'Inconsistência: múltiplos empréstimos em aberto para o mesmo item.',
      );
    }

    final e = emprestimoAberto.first;

    // Finaliza empréstimo (calcula multa) e marca item como devolvido.
    e.finalizar();
    item.marcarDevolvido();

    return e;
  }

  // -------------------------
  // RELATÓRIOS
  // -------------------------
  List<Emprestimo> listarEmprestimosEmAbertoOrdenados() {
    final lista = _emprestimos.where((e) => e.emAberto).toList();

    // Ordenação por data prevista (primeiro vence primeiro).
    lista.sort(
      (a, b) => a.dataPrevistaDevolucao.compareTo(b.dataPrevistaDevolucao),
    );

    return lista;
  }

  String gerarResumo() {
    final emAberto = _emprestimos.where((e) => e.emAberto).toList();
    final atrasados = emAberto.where((e) => e.atrasado).length;

    return 'Resumo: empréstimos ativos = ${emAberto.length} | atrasados = $atrasados | '
        'pessoas cadastradas = ${_usuarios.length} | itens cadastrados = ${_itens.length}';
  }

  // -------------------------
  // DADOS DE EXEMPLO
  // -------------------------
  void popularDadosDeExemplo() {
    // Pessoas:
    cadastrarUsuario(Aluno(id: 1, nome: 'Ana', contato: 'ana@escola.com'));
    cadastrarUsuario(Aluno(id: 2, nome: 'Bruno', contato: 'bruno@escola.com'));
    cadastrarUsuario(
      Professor(id: 3, nome: 'Prof. Carla', contato: 'carla@escola.com'),
    );

    // Itens:
    cadastrarItem(
      Livro(
        id: 10,
        titulo: 'Estruturas de Dados',
        autor: 'N. Wirth',
        ano: 1976,
      ),
    );
    cadastrarItem(
      Livro(id: 11, titulo: 'Clean Code', autor: 'R. Martin', ano: 2008),
    );
    cadastrarItem(Revista(id: 20, titulo: 'Ciência Hoje', edicao: 315));
  }
}
