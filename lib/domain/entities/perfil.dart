import 'package:hotelaria/domain/entities/funcionalidade_entity.dart';

class PerfilEntity {
  final int id;
  final String nome;
  final List<FuncionalidadeEntity> funcionalidades;

  PerfilEntity({
    required this.id,
    required this.nome,
    required this.funcionalidades,
  });

  /// Transforma o JSON do C# (incluindo a lista aninhada) em objeto Perfil
  factory PerfilEntity.fromJson(Map<String, dynamic> json) {
    return PerfilEntity(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      // Mapeia a lista de funcionalidades caso ela exista no JSON
      funcionalidades: json['funcionalidades'] != null
          ? (json['funcionalidades'] as List)
                .map((f) => FuncionalidadeEntity.fromJson(f))
                .toList()
          : [],
    );
  }

  /// Converte para JSON (útil para POST/PUT na API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'funcionalidades': funcionalidades.map((f) => f.toJson()).toList(),
    };
  }

  /// Helper para exibir as permissões como uma string separada por vírgula
  String get permissoesResumo {
    if (funcionalidades.isEmpty) return "Nenhuma permissão";
    return funcionalidades.map((f) => f.nome).join(", ");
  }
}
