import 'dart:async';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static bool _initialized = false;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      debugPrint('DatabaseHelper: Retornando banco existente');
      return _database!;
    }
    
    debugPrint('DatabaseHelper: Inicializando banco de dados...');
    
    // Inicializar database factory baseado na plataforma
    if (!_initialized) {
      try {
        if (kIsWeb) {
          // Para web, tentar usar sqflite_common_ffi_web
          debugPrint('DatabaseHelper: Inicializando para WEB...');
          try {
            databaseFactory = databaseFactoryFfiWeb;
            debugPrint('DatabaseHelper: Database factory inicializado para WEB');
          } catch (webError) {
            debugPrint('DatabaseHelper: Erro ao inicializar para web: $webError');
            debugPrint('DatabaseHelper: Web não suporta sqflite nativamente. Use desktop ou mobile.');
            throw Exception('sqflite não está disponível em web. Use desktop (Windows) ou mobile para testar.');
          }
        } else {
          // Para desktop (Windows, Linux, macOS), usar FFI
          debugPrint('DatabaseHelper: Inicializando FFI para desktop...');
          sqfliteFfiInit();
          databaseFactory = databaseFactoryFfi;
          debugPrint('DatabaseHelper: FFI inicializado com sucesso para desktop');
        }
      } catch (e, stackTrace) {
        debugPrint('DatabaseHelper: Erro ao inicializar database factory: $e');
        debugPrint('DatabaseHelper: Stack trace: $stackTrace');
        // Se for web, lança o erro
        if (kIsWeb) {
          rethrow;
        }
        // Continua mesmo se falhar, pode ser que seja mobile
      }
      _initialized = true;
    }
    
    debugPrint('DatabaseHelper: Criando/abrindo banco de dados...');
    _database = await _initDatabase('app_database.db');
    debugPrint('DatabaseHelper: Banco de dados inicializado com sucesso');
    return _database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    String dbPath;
    
    try {
      debugPrint('DatabaseHelper: Obtendo caminho do banco...');
      
      // Para web, adicionar timeout para evitar travamento
      final documentsPath = kIsWeb
          ? await getDatabasesPath().timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                throw TimeoutException(
                  'Timeout ao obter caminho do banco em web. '
                  'sqflite_common_ffi_web precisa de configuração adicional. '
                  'Execute em Windows desktop: flutter run -d windows',
                );
              },
            )
          : await getDatabasesPath();
      
      dbPath = join(documentsPath, filePath);
      debugPrint('DatabaseHelper: Caminho do banco: $dbPath');
    } catch (e, stackTrace) {
      debugPrint('DatabaseHelper: Erro ao obter caminho do banco: $e');
      debugPrint('DatabaseHelper: Stack trace: $stackTrace');
      
      // Se for web e falhar, lança erro claro
      if (kIsWeb) {
        throw Exception(
          'sqflite não está funcionando em web. '
          'Para testar o cadastro, execute em Windows desktop:\n'
          'flutter run -d windows\n\n'
          'Ou instale o Visual Studio com "Desktop development with C++"',
        );
      }
      
      // Se falhar, tenta inicializar novamente (caso não tenha sido inicializado)
      if (!_initialized) {
        try {
          debugPrint('DatabaseHelper: Tentando inicializar factory no fallback...');
          sqfliteFfiInit();
          databaseFactory = databaseFactoryFfi;
          _initialized = true;
          final documentsPath = await getDatabasesPath();
          dbPath = join(documentsPath, filePath);
          debugPrint('DatabaseHelper: Factory inicializado. Caminho: $dbPath');
        } catch (e2, stackTrace2) {
          debugPrint('DatabaseHelper: Erro ao inicializar database factory no fallback: $e2');
          debugPrint('DatabaseHelper: Stack trace: $stackTrace2');
          rethrow;
        }
      } else {
        rethrow;
      }
    }

    try {
      debugPrint('DatabaseHelper: Abrindo banco de dados...');
      final db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: _createDatabase,
      );
      debugPrint('DatabaseHelper: Banco de dados aberto com sucesso');
      return db;
    } catch (e, stackTrace) {
      debugPrint('DatabaseHelper: Erro ao abrir banco: $e');
      debugPrint('DatabaseHelper: Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE users (
        id $idType,
        firstName $textType,
        lastName $textType,
        cpf $textType,
        birthDate $textType,
        email $textType,
        passwordHash $textType
      )
    ''');

    // Criar índices únicos para email e CPF
    await db.execute('''
      CREATE UNIQUE INDEX idx_users_email ON users(email)
    ''');

    await db.execute('''
      CREATE UNIQUE INDEX idx_users_cpf ON users(cpf)
    ''');
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
