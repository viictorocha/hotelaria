import 'package:flutter/material.dart';
import 'presentation/pages/home_menu_screen.dart';

void main() {
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
        // Paleta de Cores: Azul Escuro e Azul Claro
        scaffoldBackgroundColor: const Color(
          0xFF0F172A,
        ), // Fundo quase preto (Navy)
        primaryColor: const Color(0xFF38BDF8), // Azul Claro (Cyan/Sky)
        cardColor: const Color(0xFF1E293B), // Azul Petróleo para os cards
        fontFamily: 'Roboto', // Pode trocar por Poppins ou Inter depois
      ),
      home: const HomeMenuScreen(),
    );
  }
}
