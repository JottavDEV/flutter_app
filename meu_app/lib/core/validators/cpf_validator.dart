class CpfValidator {
  // Remove caracteres não numéricos
  static String _cleanCpf(String cpf) {
    return cpf.replaceAll(RegExp(r'[^\d]'), '');
  }

  // Valida o formato do CPF (XXX.XXX.XXX-XX)
  static bool isValidFormat(String cpf) {
    // Aceita com ou sem máscara
    final cleaned = _cleanCpf(cpf);
    if (cleaned.length != 11) return false;

    // Verifica se todos os dígitos são iguais (CPF inválido)
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cleaned)) return false;

    return true;
  }

  // Valida os dígitos verificadores do CPF
  static bool isValidDigits(String cpf) {
    final cleaned = _cleanCpf(cpf);
    if (cleaned.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cleaned)) return false;

    // Valida primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cleaned[i]) * (10 - i);
    }
    int remainder = sum % 11;
    int firstDigit = remainder < 2 ? 0 : 11 - remainder;

    if (int.parse(cleaned[9]) != firstDigit) return false;

    // Valida segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cleaned[i]) * (11 - i);
    }
    remainder = sum % 11;
    int secondDigit = remainder < 2 ? 0 : 11 - remainder;

    if (int.parse(cleaned[10]) != secondDigit) return false;

    return true;
  }

  // Validação completa (formato e dígitos)
  static bool isValid(String cpf) {
    if (!isValidFormat(cpf)) return false;
    return isValidDigits(cpf);
  }

  // Formata CPF para XXX.XXX.XXX-XX
  static String format(String cpf) {
    final cleaned = _cleanCpf(cpf);
    if (cleaned.length != 11) return cpf;

    return '${cleaned.substring(0, 3)}.${cleaned.substring(3, 6)}.${cleaned.substring(6, 9)}-${cleaned.substring(9, 11)}';
  }
}


