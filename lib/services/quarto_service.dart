import 'dart:convert';
import 'package:Hotelaria/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/quarto_entity.dart';

class QuartoService {
  // Helper para centralizar os headers e o token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json', // ESSENCIAL para o C# entender o JSON
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<QuartoEntity>> getQuartos() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse(ApiConstants.quartos),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((q) => QuartoEntity.fromJson(q)).toList();
    }
    return [];
  }

  Future<bool> salvarQuarto(QuartoEntity quarto) async {
    final headers = await _getHeaders();
    final isEdicao = quarto.id != 0;

    // Se for edição, usamos o endpoint com ID, se não, usamos a rota base de POST
    final url = isEdicao
        ? "${ApiConstants.baseUrl}/quartos/${quarto.id}"
        : "${ApiConstants.baseUrl}/quartos";

    // Debug para você ver exatamente o que está saindo
    print("Enviando JSON: ${jsonEncode(quarto.toMap())}");

    final response = await (isEdicao
        ? http.put(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(quarto.toMap()),
          )
        : http.post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(quarto.toMap()),
          ));

    // O C# costuma retornar 204 (No Content) no PUT e 201 (Created) no POST
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  Future<bool> excluirQuarto(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/quartos/$id"),
      headers: headers,
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }
}
