import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quarto.dart'; // Importando o modelo que você vai criar

class QuartoService {
  final String baseUrl = "https://hotelariaapi.onrender.com/quartos";

  Future<List<Quarto>> fetchQuartos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Quarto.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar quartos');
    }
  }
}
