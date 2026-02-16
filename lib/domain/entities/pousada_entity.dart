class PousadaEntity {
  final int? id;
  final String nomeFantasia;
  final String cnpj;
  final String telefone;
  final String endereco;

  PousadaEntity({
    this.id,
    required this.nomeFantasia,
    required this.cnpj,
    required this.telefone,
    required this.endereco,
  });

  factory PousadaEntity.fromJson(Map<String, dynamic> json) {
    return PousadaEntity(
      id: json['id'],
      nomeFantasia: json['nomeFantasia'] ?? '',
      cnpj: json['cnpj'] ?? '',
      telefone: json['telefone'] ?? '',
      endereco: json['endereco'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'nomeFantasia': nomeFantasia,
    'cnpj': cnpj,
    'telefone': telefone,
    'endereco': endereco,
  };
}
