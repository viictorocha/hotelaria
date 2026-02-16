import 'package:Hotelaria/domain/entities/usuario_entity.dart';

class LoginResponse {
  final String token;
  final UsuarioEntity user; // Use UsuarioEntity aqui

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: UsuarioEntity.fromJson(json['user']),
    );
  }
}

class UserData {
  final int id;
  final String email;
  final String perfil;

  UserData({required this.id, required this.email, required this.perfil});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      email: json['email'],
      // Acessando o nome do perfil dentro do objeto aninhado que sua API envia
      perfil: json['perfil']['nome'],
    );
  }
}
