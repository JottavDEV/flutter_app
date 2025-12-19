import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../core/validators/cpf_validator.dart';
import '../../core/validators/email_validator.dart';
import '../../core/validators/password_validator.dart';

// Estado do formulário de cadastro
class RegisterState {
  final String firstName;
  final String lastName;
  final String cpf;
  final DateTime? birthDate;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;
  final String? errorMessage;

  // Flags de validação
  final bool isNameValid;
  final bool isCpfValid;
  final bool isEmailValid;
  final PasswordValidationResult? passwordValidation;
  final bool isConfirmPasswordValid;

  RegisterState({
    this.firstName = '',
    this.lastName = '',
    this.cpf = '',
    this.birthDate,
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
    this.isNameValid = false,
    this.isCpfValid = false,
    this.isEmailValid = false,
    this.passwordValidation,
    this.isConfirmPasswordValid = false,
  });

  RegisterState copyWith({
    String? firstName,
    String? lastName,
    String? cpf,
    DateTime? birthDate,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    bool? isNameValid,
    bool? isCpfValid,
    bool? isEmailValid,
    PasswordValidationResult? passwordValidation,
    bool? isConfirmPasswordValid,
  }) {
    return RegisterState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      cpf: cpf ?? this.cpf,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isNameValid: isNameValid ?? this.isNameValid,
      isCpfValid: isCpfValid ?? this.isCpfValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      passwordValidation: passwordValidation ?? this.passwordValidation,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
    );
  }

  // Verifica se o formulário está completamente válido
  bool get isFormValid {
    return isNameValid &&
        isCpfValid &&
        birthDate != null &&
        isEmailValid &&
        (passwordValidation?.isValid ?? false) &&
        isConfirmPasswordValid;
  }
}

class RegisterViewModel extends StateNotifier<RegisterState> {
  final UserRepository _repository;

  RegisterViewModel(this._repository) : super(RegisterState());

  // Atualizar nome completo
  void updateName(String name) {
    final parts = name.trim().split(' ');
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    final isValid = firstName.isNotEmpty && lastName.isNotEmpty;

    state = state.copyWith(
      firstName: firstName,
      lastName: lastName,
      isNameValid: isValid,
    );
  }

  // Atualizar CPF
  void updateCpf(String cpf) {
    final isValid = CpfValidator.isValid(cpf);
    state = state.copyWith(
      cpf: cpf,
      isCpfValid: isValid,
    );
  }

  // Atualizar data de nascimento
  void updateBirthDate(DateTime date) {
    state = state.copyWith(birthDate: date);
  }

  // Atualizar email
  void updateEmail(String email) {
    final isValid = EmailValidator.isValid(email);
    state = state.copyWith(
      email: email,
      isEmailValid: isValid,
    );
  }

  // Atualizar senha
  void updatePassword(String password) {
    final validation = PasswordValidator.validate(password);
    final isConfirmValid = password.isNotEmpty &&
        state.confirmPassword.isNotEmpty &&
        password == state.confirmPassword;

    state = state.copyWith(
      password: password,
      passwordValidation: validation,
      isConfirmPasswordValid: isConfirmValid,
    );
  }

  // Atualizar confirmação de senha
  void updateConfirmPassword(String confirmPassword) {
    final isValid = confirmPassword.isNotEmpty &&
        state.password.isNotEmpty &&
        confirmPassword == state.password;

    state = state.copyWith(
      confirmPassword: confirmPassword,
      isConfirmPasswordValid: isValid,
    );
  }

  // Alternar visibilidade da senha
  void togglePasswordVisibility() {
    state = state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
    );
  }

  // Alternar visibilidade da confirmação de senha
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  // Registrar usuário
  Future<Result<User>> register() async {
    if (!state.isFormValid) {
      return Result.failure('Preencha todos os campos corretamente');
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      print('RegisterViewModel: Iniciando cadastro...');
      final result = await _repository.registerUser(
        firstName: state.firstName,
        lastName: state.lastName,
        cpf: state.cpf,
        birthDate: state.birthDate!,
        email: state.email,
        password: state.password,
      );

      print('RegisterViewModel: Cadastro concluído. Sucesso: ${result.isSuccess}');
      
      state = state.copyWith(isLoading: false);

      if (result.isFailure) {
        state = state.copyWith(errorMessage: result.error);
        print('RegisterViewModel: Erro no cadastro: ${result.error}');
      }

      return result;
    } catch (e, stackTrace) {
      print('RegisterViewModel: Exceção capturada: $e');
      print('RegisterViewModel: Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro inesperado: ${e.toString()}',
      );
      return Result.failure('Erro inesperado: ${e.toString()}');
    }
  }

  // Limpar estado
  void clear() {
    state = RegisterState();
  }
}

