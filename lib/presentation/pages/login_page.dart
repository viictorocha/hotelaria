import 'package:flutter/material.dart';
import 'package:Hotelaria/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      _showError("Preencha todos os campos");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthService().login(
        _emailController.text,
        _passController.text,
      );

      if (response != null) {
        // 1. Salvar o Token localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', response.token);
        await prefs.setString('user_email', response.user.email);

        if (!mounted) return;

        // 2. Navegar para a Home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showError("E-mail ou senha incorretos");
      }
    } catch (e) {
      _showError("Erro ao conectar com o servidor");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.hotel, size: 80, color: Colors.blue),
            const SizedBox(height: 32),
            Text(
              "Bem-vindo ao HotelariaPro",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "E-mail",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("ENTRAR"),
            ),
          ],
        ),
      ),
    );
  }
}
