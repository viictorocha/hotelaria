import 'dart:convert';
import 'package:Hotelaria/constants/api_constants.dart';
import 'package:Hotelaria/domain/entities/login_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/usuario_entity.dart'; // Ajuste o path se necessário

class AuthService {
  static const String _userKey = "user_data";

  Future<LoginResponse?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Email': email, 'Senha': password}),
    );

    if (response.statusCode == 200) {
      final loginData = LoginResponse.fromJson(jsonDecode(response.body));

      // SALVAR: Armazena o usuário localmente após o login com sucesso
      await _salvarUsuarioLocal(loginData.user);

      return loginData;
    } else {
      return null;
    }
  }

  // --- MÉTODOS DE PERSISTÊNCIA ---

  Future<void> _salvarUsuarioLocal(UsuarioEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    // Transformamos o objeto em String JSON para salvar
    String userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  /// Recupera o usuário logado do disco
  static Future<UsuarioEntity?> getUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson != null) {
      return UsuarioEntity.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  /// Limpa os dados (Logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
