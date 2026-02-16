import 'perfil_entity.dart';

class UsuarioEntity {
  final int id;
  final String nome;
  final String email;
  final String? senha; // Usado apenas na criação
  final int perfilId;
  final PerfilEntity? perfil;

  UsuarioEntity({
    required this.id,
    required this.nome,
    required this.email,
    required this.perfilId,
    this.senha,
    this.perfil,
  });

  factory UsuarioEntity.fromJson(Map<String, dynamic> json) {
    return UsuarioEntity(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      perfilId: json['perfilId'] ?? 0,
      perfil: json['perfil'] != null
          ? PerfilEntity.fromJson(json['perfil'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'perfil': perfil?.toJson(),
    };
  }
}
