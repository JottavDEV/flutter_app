import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';
import '../../core/database/app_database.dart';
import '../../core/validators/cpf_validator.dart';
import '../../core/validators/email_validator.dart';

// Classe para representar resultado de operações
class Result<T> {
  final T? data;
  final String? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;
}

class UserRepository {
  final AppDatabase _database = AppDatabase();

  // Hash de senha usando SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Verificar se email já existe
  Future<bool> emailExists(String email) async {
    try {
      print('UserRepository: Verificando se email existe: $email');
      final user = await _database.getUserByEmail(email);
      print('UserRepository: Email existe: ${user != null}');
      return user != null;
    } catch (e, stackTrace) {
      print('UserRepository: Erro ao verificar email: $e');
      print('UserRepository: Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Verificar se CPF já existe
  Future<bool> cpfExists(String cpf) async {
    try {
      print('UserRepository: Verificando se CPF existe: $cpf');
      final cleanedCpf = CpfValidator.format(cpf).replaceAll(RegExp(r'[^\d]'), '');
      print('UserRepository: CPF limpo: $cleanedCpf');
      final user = await _database.getUserByCpf(cleanedCpf);
      print('UserRepository: CPF existe: ${user != null}');
      return user != null;
    } catch (e, stackTrace) {
      print('UserRepository: Erro ao verificar CPF: $e');
      print('UserRepository: Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Registrar novo usuário
  Future<Result<User>> registerUser({
    required String firstName,
    required String lastName,
    required String cpf,
    required DateTime birthDate,
    required String email,
    required String password,
  }) async {
    try {
      print('UserRepository: Iniciando validações...');
      
      // Validar email
      if (!EmailValidator.isValid(email)) {
        print('UserRepository: Email inválido');
        return Result.failure('Email inválido');
      }

      // Validar CPF
      if (!CpfValidator.isValid(cpf)) {
        print('UserRepository: CPF inválido');
        return Result.failure('CPF inválido');
      }

      print('UserRepository: Verificando duplicidade de email...');
      // Verificar se email já existe
      if (await emailExists(email)) {
        print('UserRepository: Email já existe');
        return Result.failure('Email já cadastrado');
      }

      print('UserRepository: Verificando duplicidade de CPF...');
      // Verificar se CPF já existe
      if (await cpfExists(cpf)) {
        print('UserRepository: CPF já existe');
        return Result.failure('CPF já cadastrado');
      }

      print('UserRepository: Criando hash da senha...');
      // Criar hash da senha
      final passwordHash = _hashPassword(password);

      // Formatar CPF (remover máscara para armazenar)
      final cleanedCpf = CpfValidator.format(cpf).replaceAll(RegExp(r'[^\d]'), '');

      // Criar usuário
      final user = User(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        cpf: cleanedCpf,
        birthDate: birthDate,
        email: email.trim().toLowerCase(),
        passwordHash: passwordHash,
      );

      print('UserRepository: Inserindo usuário no banco...');
      // Inserir no banco
      final id = await _database.insertUser(user);
      print('UserRepository: Usuário inserido com ID: $id');

      // Retornar usuário com ID
      final createdUser = user.copyWith(id: id);

      return Result.success(createdUser);
    } catch (e, stackTrace) {
      print('UserRepository: Erro ao cadastrar: $e');
      print('UserRepository: Stack trace: $stackTrace');
      return Result.failure('Erro ao cadastrar usuário: ${e.toString()}');
    }
  }

  // Buscar usuário por email
  Future<User?> getUserByEmail(String email) async {
    return await _database.getUserByEmail(email);
  }

  // Buscar usuário por CPF
  Future<User?> getUserByCpf(String cpf) async {
    final cleanedCpf = CpfValidator.format(cpf).replaceAll(RegExp(r'[^\d]'), '');
    return await _database.getUserByCpf(cleanedCpf);
  }

  // Buscar usuário por ID
  Future<User?> getUserById(int id) async {
    return await _database.getUserById(id);
  }

  // Buscar todos os usuários
  Future<List<User>> getAllUsers() async {
    return await _database.getAllUsers();
  }

  // Login de usuário
  Future<Result<User>> loginUser(String email, String password) async {
    try {
      // Validar email
      if (!EmailValidator.isValid(email)) {
        return Result.failure('Email inválido');
      }

      // Validar senha não vazia
      if (password.isEmpty) {
        return Result.failure('Senha é obrigatória');
      }

      // Buscar usuário por email
      final user = await _database.getUserByEmail(email.trim().toLowerCase());

      if (user == null) {
        return Result.failure('Email ou senha incorretos');
      }

      // Criar hash da senha fornecida
      final passwordHash = _hashPassword(password);

      // Comparar hash da senha fornecida com hash armazenado
      if (passwordHash != user.passwordHash) {
        return Result.failure('Email ou senha incorretos');
      }

      // Retornar usuário autenticado
      return Result.success(user);
    } catch (e) {
      return Result.failure('Erro ao fazer login: ${e.toString()}');
    }
  }
}

