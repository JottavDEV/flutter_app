import 'package:flutter/material.dart';
import '../presentation/views/text_analyzer/text_analyzer_screen.dart';
import '../presentation/views/register/register_screen.dart';
import '../presentation/views/login/login_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String textAnalyzer = '/';
  static const String register = '/register';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case textAnalyzer:
        return MaterialPageRoute(
          builder: (_) => const TextAnalyzerScreen(),
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
    }
  }
}

