import 'dart:convert';
import 'package:Hotelaria/constants/api_constants.dart';
import 'package:Hotelaria/domain/entities/pousada_entity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PousadaService {
  Future<PousadaEntity?> getPousada() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(ApiConstants.pousada),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return PousadaEntity.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> salvarPousada(PousadaEntity pousada) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse(ApiConstants.pousada),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(pousada.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
}
