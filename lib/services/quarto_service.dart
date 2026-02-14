import 'dart:convert';
import 'package:Hotelaria/domain/entities/quarto_entity.dart';
import 'package:http/http.dart' as http;

class QuartoService {
  final String baseUrl = "https://hotelariaapi.onrender.com/quartos";

  // Future<List<QuartoEntity>> fetchQuartos() async {
  //   final response = await http.get(Uri.parse(baseUrl));

  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => QuartoEntity.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Erro ao carregar quartos');
  //   }
  // }
}
