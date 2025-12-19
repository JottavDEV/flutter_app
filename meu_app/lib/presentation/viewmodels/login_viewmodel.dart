import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../core/validators/email_validator.dart';

// Estado do formulário de login
class LoginState {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;
  final bool isEmailValid;

  LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
    this.isEmailValid = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    bool? isEmailValid,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }

  // Verifica se o formulário está válido
  bool get isFormValid {
    return isEmailValid && password.isNotEmpty;
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  final UserRepository _repository;

  LoginViewModel(this._repository) : super(LoginState());

  // Atualizar email
  void updateEmail(String email) {
    final isValid = EmailValidator.isValid(email);
    state = state.copyWith(
      email: email,
      isEmailValid: isValid,
      errorMessage: null, // Limpa erro ao digitar
    );
  }

  // Atualizar senha
  void updatePassword(String password) {
    state = state.copyWith(
      password: password,
      errorMessage: null, // Limpa erro ao digitar
    );
  }

  // Alternar visibilidade da senha
  void togglePasswordVisibility() {
    state = state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
    );
  }

  // Fazer login
  Future<Result<User>> login() async {
    if (!state.isFormValid) {
      return Result.failure('Preencha todos os campos corretamente');
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _repository.loginUser(
        state.email,
        state.password,
      );

      state = state.copyWith(isLoading: false);

      if (result.isFailure) {
        state = state.copyWith(errorMessage: result.error);
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro inesperado: ${e.toString()}',
      );
      return Result.failure('Erro inesperado: ${e.toString()}');
    }
  }

  // Limpar estado
  void clear() {
    state = LoginState();
  }
}


