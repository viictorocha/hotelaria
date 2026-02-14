import 'dart:convert';
import 'package:hotelaria/domain/entities/login_response.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://hotelariaapi.onrender.com";

  Future<LoginResponse?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': password}),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      return null; // Aqui você pode tratar erros (401, 500, etc)
    }
  }
}
