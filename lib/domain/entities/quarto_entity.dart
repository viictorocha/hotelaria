enum StatusQuarto { disponivel, ocupado, limpeza, manutencao }

enum TipoQuarto { standard, luxo, master, flat }

class QuartoEntity {
  final String id;
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
}
