class Formatters {
  // ===========================================================================
  // FORMATADORES SIMPLES
  // - Evitamos dependências externas.
  // - Em console, um formato "dd/mm/aaaa" já resolve o básico.
  // ===========================================================================
  static String dataBR(DateTime dt) {
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year.toString().padLeft(4, '0');
    return '$dd/$mm/$yyyy';
  }
}
