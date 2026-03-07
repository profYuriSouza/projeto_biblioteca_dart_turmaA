import 'dart:io';

class Console {
  // ===========================================================================
  // UTILITÁRIOS DE ENTRADA (stdin) COM VALIDAÇÃO
  // - Objetivo: não espalhar "stdin.readLineSync()" pelo sistema inteiro.
  // - Aqui centralizamos:
  //   - leitura de String não vazia
  //   - leitura de int com limites
  // ===========================================================================
  static String lerStringNaoVazia({required String mensagem}) {
    while (true) {
      stdout.write(mensagem);

      final entrada = stdin.readLineSync();

      // Em Dart com null-safety, readLineSync pode retornar null.
      // Isso acontece, por exemplo, se a entrada for encerrada.
      if (entrada == null) {
        print('Entrada inválida (null). Tente novamente.');
        continue;
      }

      final texto = entrada.trim();
      if (texto.isEmpty) {
        print('Valor não pode ser vazio.');
        continue;
      }

      return texto;
    }
  }

  static int lerInt({required String mensagem, int? minimo, int? maximo}) {
    while (true) {
      stdout.write(mensagem);

      final entrada = stdin.readLineSync();
      if (entrada == null) {
        print('Entrada inválida (null). Tente novamente.');
        continue;
      }

      final texto = entrada.trim();
      final valor = int.tryParse(texto);

      // tryParse devolve null se não for número.
      if (valor == null) {
        print('Digite um número inteiro válido.');
        continue;
      }

      if (minimo != null && valor < minimo) {
        print('O valor deve ser >= $minimo.');
        continue;
      }

      if (maximo != null && valor > maximo) {
        print('O valor deve ser <= $maximo.');
        continue;
      }

      return valor;
    }
  }
}
