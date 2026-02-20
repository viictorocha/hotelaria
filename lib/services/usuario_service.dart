import 'dart:convert';
import 'dart:developer' as console;
import 'package:Hotelaria/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/usuario_entity.dart';

class UsuarioService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<List<UsuarioEntity>> getUsuarios() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(ApiConstants.usuarios),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((u) => UsuarioEntity.fromJson(u)).toList();
    }
    return [];
  }

  Future<bool> criarUsuario(UsuarioEntity usuario) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse(ApiConstants.usuarios),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(usuario.toJson()),
      );
      console.log('Criando usuário: ${usuario.toJson()}');
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> atualizarUsuario(UsuarioEntity usuario) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('${ApiConstants.usuarios}/${usuario.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(usuario.toJson()),
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<bool> deletarUsuario(int id) async {
    final token = await _getToken();
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.usuarios}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}
