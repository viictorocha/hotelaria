enum StatusReserva { confirmada, checkIn, checkOut, cancelada }

class ReservaEntity {
  final String id;
  final String quartoId;
  final String hospedeNome;
  final DateTime dataEntrada;
  final DateTime dataSaida;
  final StatusReserva status;
  final double valorTotal;

  ReservaEntity({
    required this.id,
    required this.quartoId,
    required this.hospedeNome,
    required this.dataEntrada,
    required this.dataSaida,
    required this.status,
    required this.valorTotal,
  });

  // Helper para calcular total de diárias na UI
  int get totalDias => dataSaida.difference(dataEntrada).inDays;
}
