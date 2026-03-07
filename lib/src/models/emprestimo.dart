import '../utils/formatters.dart';
import 'usuario.dart';
import 'item.dart';

class Emprestimo {
  // ===========================================================================
  // CLASSE: Emprestimo
  // - Exemplo clássico de COMPOSIÇÃO:
  //   um Emprestimo "tem um" Usuario e "tem um" ItemBiblioteca.
  // - Controla datas e cálculo de multa.
  // ===========================================================================

  final Usuario usuario;
  final ItemBiblioteca item;

  final DateTime dataEmprestimo;
  final DateTime dataPrevistaDevolucao;

  DateTime? _dataDevolucao;
  double? _multaCalculada;

  Emprestimo({
    required this.usuario,
    required this.item,
    required this.dataEmprestimo,
    required this.dataPrevistaDevolucao,
  });

  bool get emAberto => _dataDevolucao == null;

  DateTime? get dataDevolucao => _dataDevolucao;
  double? get multaCalculada => _multaCalculada;

  // Encerrar o empréstimo:
  // - registra data de devolução
  // - calcula multa (se houver)
  void finalizar({DateTime? dataDevolucao}) {
    if (!emAberto) {
      throw StateError('Este empréstimo já foi finalizado.');
    }

    final dt = dataDevolucao ?? DateTime.now();
    _dataDevolucao = dt;

    _multaCalculada = _calcularMulta(dt);
  }

  bool get atrasado {
    // Se está em aberto e já passou da data prevista, está atrasado.
    if (!emAberto) return false;
    return DateTime.now().isAfter(dataPrevistaDevolucao);
  }

  double _calcularMulta(DateTime dataDevolucao) {
    // Se devolveu antes ou no dia previsto, multa é zero.
    if (!dataDevolucao.isAfter(dataPrevistaDevolucao)) {
      return 0.0;
    }

    // Diferença em dias.
    // Obs.: para simplificar, usamos diferença inteira baseada em Duration.
    final atraso = dataDevolucao.difference(dataPrevistaDevolucao).inDays;

    // Cada tipo de item define sua multaPorDia (polimorfismo).
    return atraso * item.multaPorDia;
  }

  String descricaoDetalhada() {
    final status = emAberto ? 'EM ABERTO' : 'FINALIZADO';
    final devolucaoStr = (dataDevolucao == null)
        ? '-'
        : Formatters.dataBR(dataDevolucao!);
    final multaStr = (multaCalculada == null)
        ? '-'
        : 'R\$ ${multaCalculada!.toStringAsFixed(2)}';

    return 'Empréstimo [$status] | Pessoa: ${usuario.nome} (${usuario.tipo()}) | '
        'Item: "${item.titulo}" (${item.tipo()}) | '
        'Empréstimo: ${Formatters.dataBR(dataEmprestimo)} | '
        'Previsto: ${Formatters.dataBR(dataPrevistaDevolucao)} | '
        'Devolução: $devolucaoStr | Multa: $multaStr';
  }
}
