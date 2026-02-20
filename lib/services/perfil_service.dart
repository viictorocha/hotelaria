import 'dart:convert';
import 'package:Hotelaria/constants/api_constants.dart';
import 'package:Hotelaria/domain/entities/funcionalidade_entity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/perfil_entity.dart';

class PerfilService {
  /// Recupera o Token JWT salvo no SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  /// Busca todos os perfis cadastrados (incluindo suas funcionalidades)
  Future<List<PerfilEntity>> getPerfis() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(ApiConstants.perfis),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((p) => PerfilEntity.fromJson(p)).toList();
      } else {
        print("Erro ao buscar perfis: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Erro de conexão: $e");
      return [];
    }
  }

  /// Busca todas as funcionalidades disponíveis no sistema
  Future<List<FuncionalidadeEntity>> getTodasFuncionalidades() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(ApiConstants.funcionalidades),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse
            .map((f) => FuncionalidadeEntity.fromJson(f))
            .toList();
      } else {
        print("Erro ao buscar funcionalidades: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Erro de conexão: $e");
      return [];
    }
  }

  /// Atualiza um perfil existente, definindo novas funcionalidades (relação N para N)
  Future<bool> updatePerfil(
    int id,
    String nome,
    List<int> funcionalidadesIds,
  ) async {
    try {
      final token = await _getToken();

      final response = await http.put(
        Uri.parse('${ApiConstants.perfis}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nome': nome,
          'funcionalidadesIds': funcionalidadesIds,
        }),
      );

      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      print("Erro ao atualizar perfil: $e");
      return false;
    }
  }

  /// Opcional: Cria um novo perfil
  Future<bool> criarPerfil(String nome, List<int> funcionalidadesIds) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse(ApiConstants.perfis),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nome': nome,
          'funcionalidadesIds': funcionalidadesIds,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
