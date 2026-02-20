class PousadaEntity {
  final int id;
  final String nomeFantasia;
  final String razaoSocial;
  final String cnpj;
  final String telefone;
  final String endereco;
  final String cidade;
  final String checkInPadrao;
  final String checkOutPadrao;

  PousadaEntity({
    required this.id,
    required this.nomeFantasia,
    required this.razaoSocial,
    this.cnpj = '',
    this.telefone = '',
    this.endereco = '',
    this.cidade = '',
    this.checkInPadrao = '14:00',
    this.checkOutPadrao = '12:00',
  });

  factory PousadaEntity.fromJson(Map<String, dynamic> json) {
    return PousadaEntity(
      id: json['id'] ?? 0,
      nomeFantasia: json['nomeFantasia'] ?? '',
      razaoSocial: json['razaoSocial'] ?? '',
      cnpj: json['cnpj'] ?? '',
      telefone: json['telefone'] ?? '',
      endereco: json['endereco'] ?? '',
      cidade: json['cidade'] ?? '',
      checkInPadrao: json['checkInPadrao'] ?? '14:00',
      checkOutPadrao: json['checkOutPadrao'] ?? '12:00',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nomeFantasia': nomeFantasia,
    'razaoSocial': razaoSocial,
    'cnpj': cnpj,
    'telefone': telefone,
    'endereco': endereco,
    'cidade': cidade,
    'checkInPadrao': checkInPadrao,
    'checkOutPadrao': checkOutPadrao,
  };
}
