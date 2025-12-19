class EmailValidator {
  // Regex para validação de email
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Valida o formato do email
  static bool isValid(String email) {
    if (email.isEmpty) return false;
    return _emailRegex.hasMatch(email);
  }

  // Validação mais rigorosa (opcional)
  static bool isValidStrict(String email) {
    if (!isValid(email)) return false;

    // Verifica se não começa ou termina com ponto ou traço
    if (email.startsWith('.') || email.startsWith('-') ||
        email.endsWith('.') || email.endsWith('-')) {
      return false;
    }

    // Verifica se não tem pontos consecutivos
    if (email.contains('..')) return false;

    // Verifica se tem @ e pelo menos um ponto após o @
    final parts = email.split('@');
    if (parts.length != 2) return false;
    if (!parts[1].contains('.')) return false;

    return true;
  }
}


