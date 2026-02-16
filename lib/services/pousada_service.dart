import 'dart:convert';
import 'package:Hotelaria/domain/entities/pousada_entity.dart';
import 'package:http/http.dart' as http;

class PousadaService {
  final String baseUrl = "https://hotelariaapi.onrender.com/pousada";

  Future<PousadaEntity?> getPousada() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200)
      return PousadaEntity.fromJson(jsonDecode(response.body));
    return null;
  }

  Future<bool> salvarPousada(PousadaEntity pousada) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pousada.toJson()),
    );
    return response.statusCode == 200;
  }
}
