class PasswordValidationResult {
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasNumber;
  final bool hasSpecialChar;

  PasswordValidationResult({
    required this.hasUpperCase,
    required this.hasLowerCase,
    required this.hasNumber,
    required this.hasSpecialChar,
  });

  // Verifica se todas as regras foram cumpridas
  bool get isValid {
    return hasUpperCase && hasLowerCase && hasNumber && hasSpecialChar;
  }

  // Retorna lista de regras não cumpridas
  List<String> get missingRequirements {
    final List<String> missing = [];
    if (!hasUpperCase) missing.add('Maiúscula');
    if (!hasLowerCase) missing.add('Minúscula');
    if (!hasNumber) missing.add('Número');
    if (!hasSpecialChar) missing.add('Caractere especial');
    return missing;
  }
}

class PasswordValidator {
  // Valida senha e retorna resultado detalhado
  static PasswordValidationResult validate(String password) {
    // Verifica maiúscula
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);

    // Verifica minúscula
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);

    // Verifica número
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    // Verifica caractere especial
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return PasswordValidationResult(
      hasUpperCase: hasUpperCase,
      hasLowerCase: hasLowerCase,
      hasNumber: hasNumber,
      hasSpecialChar: hasSpecialChar,
    );
  }

  // Verifica se a senha é válida (todas as regras cumpridas)
  static bool isValid(String password) {
    return validate(password).isValid;
  }
}


