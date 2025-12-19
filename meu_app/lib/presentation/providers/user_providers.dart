import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository.dart';
import '../viewmodels/register_viewmodel.dart';
import '../viewmodels/login_viewmodel.dart';

// Provider do UserRepository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

// Provider do RegisterViewModel
final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return RegisterViewModel(repository);
});

// Provider do LoginViewModel
final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return LoginViewModel(repository);
});

