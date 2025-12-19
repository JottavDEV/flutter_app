import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../../data/models/user_model.dart';

class AppDatabase {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Inserir usuário
  Future<int> insertUser(User user) async {
    try {
      print('AppDatabase: Obtendo conexão com banco...');
      final db = await _dbHelper.database;
      print('AppDatabase: Conexão obtida. Inserindo usuário...');
      final id = await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      print('AppDatabase: Usuário inserido com sucesso. ID: $id');
      return id;
    } catch (e, stackTrace) {
      print('AppDatabase: Erro ao inserir usuário: $e');
      print('AppDatabase: Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Buscar usuário por email
  Future<User?> getUserByEmail(String email) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  // Buscar usuário por CPF
  Future<User?> getUserByCpf(String cpf) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'cpf = ?',
      whereArgs: [cpf],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  // Buscar todos os usuários
  Future<List<User>> getAllUsers() async {
    final db = await _dbHelper.database;
    final maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  // Buscar usuário por ID
  Future<User?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  // Atualizar usuário
  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Deletar usuário
  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

