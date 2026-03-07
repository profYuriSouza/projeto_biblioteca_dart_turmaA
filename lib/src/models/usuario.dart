abstract class Usuario {
  // ===========================================================================
  // CLASSE ABSTRATA: Usuario
  // - "Abstrata" significa que não criamos diretamente um Usuario genérico.
  // - Criamos tipos concretos (Aluno, Professor) que herdam de Usuario.
  //
  // Objetivo didático:
  // - herança
  // - polimorfismo (tratamos Aluno/Professor como Usuario)
  // - encapsulamento (campos privados + validação em setters)
  // ===========================================================================

  final int id;

  String _nome;
  String _contato;

  Usuario({required this.id, required String nome, required String contato})
    : _nome = nome.trim(),
      _contato = contato.trim() {
    // Validações no construtor: impedimos o objeto nascer inválido.
    _validarNome(_nome);
    _validarContato(_contato);
  }

  // -------------------------
  // GETTERS (leitura)
  // -------------------------
  String get nome => _nome;
  String get contato => _contato;

  // -------------------------
  // SETTERS (escrita)
  // - Aqui implementamos validação e controle de invariantes.
  // -------------------------
  set nome(String value) {
    final v = value.trim();
    _validarNome(v);
    _nome = v;
  }

  set contato(String value) {
    final v = value.trim();
    _validarContato(v);
    _contato = v;
  }

  // -------------------------
  // PROPRIEDADES ABSTRATAS
  // - Cada perfil deve definir suas regras.
  // -------------------------
  int get limiteEmprestimosAbertos;
  int get prazoDiasEmprestimo;

  // -------------------------
  // MÉTODOS DE APOIO
  // -------------------------
  String tipo();

  String descricaoDetalhada() {
    return 'Pessoa #$id | ${tipo()} | Nome: $nome | Contato: $contato | '
        'Limite: $limiteEmprestimosAbertos | Prazo: ${prazoDiasEmprestimo} dia(s)';
  }

  // -------------------------
  // VALIDAÇÕES PRIVADAS
  // -------------------------
  void _validarNome(String nome) {
    if (nome.isEmpty) {
      throw ArgumentError('Nome não pode ser vazio.');
    }
    if (nome.length < 2) {
      throw ArgumentError('Nome muito curto.');
    }
  }

  void _validarContato(String contato) {
    if (contato.isEmpty) {
      throw ArgumentError('Contato não pode ser vazio.');
    }

    // Validação simples para fins didáticos.
    // Em sistemas reais, e-mail/telefone têm regras mais complexas.
    if (!contato.contains('@') && contato.length < 8) {
      throw ArgumentError(
        'Contato parece inválido. Use e-mail ou algo identificável.',
      );
    }
  }
}

class Aluno extends Usuario {
  Aluno({required super.id, required super.nome, required super.contato});

  @override
  int get limiteEmprestimosAbertos => 2;

  @override
  int get prazoDiasEmprestimo => 7;

  @override
  String tipo() => 'Aluno';
}

class Professor extends Usuario {
  Professor({required super.id, required super.nome, required super.contato});

  @override
  int get limiteEmprestimosAbertos => 5;

  @override
  int get prazoDiasEmprestimo => 14;

  @override
  String tipo() => 'Professor';
}
