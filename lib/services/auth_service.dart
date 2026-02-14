import 'dart:convert';
import 'package:Hotelaria/domain/entities/login_response.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // final String baseUrl = "https://hotelariaapi.onrender.com";
  final String baseUrl = "http://127.0.0.1:5299/";

  Future<LoginResponse?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Email': email, 'Senha': password}),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      return null; // Aqui você pode tratar erros (401, 500, etc)
    }
  }
}
