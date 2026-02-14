class FuncionalidadeEntity {
  final int id;
  final String nome;
  final String? descricao;

  FuncionalidadeEntity({required this.id, required this.nome, this.descricao});

  // Transforma o JSON que vem da API C# em um objeto Dart
  factory FuncionalidadeEntity.fromJson(Map<String, dynamic> json) {
    return FuncionalidadeEntity(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      descricao: json['descricao'],
    );
  }

  // Transforma o objeto Dart em JSON caso precise enviar para a API
  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'descricao': descricao};
  }

  // Sobrescrevendo o operador de igualdade para facilitar
  // comparacoes em Checkboxes e listas no Flutter
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuncionalidadeEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
