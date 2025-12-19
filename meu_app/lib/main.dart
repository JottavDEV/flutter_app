import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/database_helper.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Inicializar banco de dados
    await DatabaseHelper.instance.database;
  } catch (e) {
    debugPrint('Erro ao inicializar banco de dados: $e');
    // Se for web, mostra mensagem mais clara
    if (e.toString().contains('web') || e.toString().contains('SqfliteFfiWeb')) {
      debugPrint('AVISO: sqflite não funciona completamente em web.');
      debugPrint('Para testar o cadastro, execute em Windows desktop: flutter run -d windows');
    }
  }
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
