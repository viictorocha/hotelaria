import 'package:flutter/material.dart';
import 'package:hotelaria/presentation/pages/login_page.dart';
import 'package:hotelaria/presentation/pages/perfil_list_page.dart';
import 'package:hotelaria/service_locator.dart';
import 'presentation/pages/home_menu_screen.dart';

void main() {
  setupLocator();
  runApp(const HotelariaApp());
}

class HotelariaApp extends StatelessWidget {
  const HotelariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotelaria Gestão',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF38BDF8),
        cardColor: const Color(0xFF1E293B),
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E293B),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          labelStyle: const TextStyle(color: Color(0xFF38BDF8)),
        ),
      ),

      // Definimos a página de login como inicial
      initialRoute: '/login',

      // Tabela de Rotas
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomeMenuScreen(),
        '/perfis': (context) => const PerfilListPage(),
      },
    );
  }
}
