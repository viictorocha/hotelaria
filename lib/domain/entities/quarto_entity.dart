enum StatusQuarto { disponivel, ocupado, limpeza, manutencao }

enum TipoQuarto { standard, luxo, suite }

class QuartoEntity {
  final int id;
  final String numero;
  final TipoQuarto tipo;
  final StatusQuarto status;
  final int capacidade;
  final double precoBase;

  QuartoEntity({
    required this.id,
    required this.numero,
    required this.tipo,
    required this.status,
    required this.capacidade,
    required this.precoBase,
  });

  factory QuartoEntity.fromJson(Map<String, dynamic> json) {
    return QuartoEntity(
      id: json['id'],
      numero: json['numero'],
      // Mapeia o int da API para o Enum do Flutter
      tipo: TipoQuarto.values[json['tipo']],
      status: StatusQuarto.values[json['status']],
      capacidade: json['capacidade'],
      precoBase: (json['precoBase'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'tipo': tipo.index,
      'status': status.index,
      'capacidade': capacidade,
      'precoBase': double.parse(precoBase.toStringAsFixed(2)),
    };
  }
}
