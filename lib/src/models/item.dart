abstract class ItemBiblioteca {
  // ===========================================================================
  // CLASSE ABSTRATA: ItemBiblioteca
  // - Representa qualquer item emprestável.
  // - Tipos concretos (Livro, Revista) especializam regras (ex.: multa por dia).
  // ===========================================================================

  final int id;

  String _titulo;

  // Disponibilidade é um estado interno do item.
  // Mantemos privado para não permitir que qualquer lugar do código "mexa" livremente.
  bool _disponivel = true;

  ItemBiblioteca({required this.id, required String titulo})
    : _titulo = titulo.trim() {
    _validarTitulo(_titulo);
  }

  String get titulo => _titulo;

  set titulo(String value) {
    final v = value.trim();
    _validarTitulo(v);
    _titulo = v;
  }

  bool get disponivel => _disponivel;

  // Controle explícito de estado:
  // Em vez de "item.disponivel = false", usamos métodos com intenção.
  void marcarEmprestado() {
    if (!_disponivel) {
      throw StateError('Item já está emprestado.');
    }
    _disponivel = false;
  }

  void marcarDevolvido() {
    if (_disponivel) {
      // Não é necessariamente erro fatal, mas indica fluxo estranho.
      // Preferimos sinalizar para depuração.
      throw StateError('Item já estava disponível.');
    }
    _disponivel = true;
  }

  // Regras específicas do tipo:
  // multa por dia (cada tipo pode cobrar diferente).
  double get multaPorDia;

  String tipo();

  String descricaoDetalhada() {
    final status = disponivel ? 'Disponível' : 'Emprestado';
    return 'Item #$id | ${tipo()} | Título: "$titulo" | Status: $status | Multa/dia: R\$ ${multaPorDia.toStringAsFixed(2)}';
  }

  void _validarTitulo(String titulo) {
    if (titulo.isEmpty) {
      throw ArgumentError('Título não pode ser vazio.');
    }
    if (titulo.length < 2) {
      throw ArgumentError('Título muito curto.');
    }
  }
}

class Livro extends ItemBiblioteca {
  // Campos específicos de Livro:
  final String autor;
  final int ano;

  Livro({
    required super.id,
    required super.titulo,
    required String autor,
    required int ano,
  }) : autor = autor.trim(),
       ano = ano {
    // Validações simples de domínio:
    if (this.autor.isEmpty) {
      throw ArgumentError('Autor não pode ser vazio.');
    }
    if (this.ano < 0) {
      throw ArgumentError('Ano não pode ser negativo.');
    }
  }

  @override
  double get multaPorDia => 1.50;

  @override
  String tipo() => 'Livro';
}

class Revista extends ItemBiblioteca {
  final int edicao;

  Revista({required super.id, required super.titulo, required int edicao})
    : edicao = edicao {
    if (this.edicao < 1) {
      throw ArgumentError('Edição deve ser >= 1.');
    }
  }

  @override
  double get multaPorDia => 0.75;

  @override
  String tipo() => 'Revista';
}
