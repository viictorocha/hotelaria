import 'package:flutter/material.dart';
import '../../../domain/entities/reserva_entity.dart';

class ReservasListaScreen extends StatelessWidget {
  const ReservasListaScreen({super.key});

  // Dados Mockados para a V1
  List<ReservaEntity> get reservasMock => [
    ReservaEntity(
      id: '1',
      quartoId: '101',
      hospedeNome: 'Carlos Alberto',
      dataEntrada: DateTime.now(),
      dataSaida: DateTime.now().add(const Duration(days: 3)),
      status: StatusReserva.checkIn,
      valorTotal: 750.0,
    ),
    ReservaEntity(
      id: '2',
      quartoId: '204',
      hospedeNome: 'Mariana Souza',
      dataEntrada: DateTime.now().add(const Duration(days: 2)),
      dataSaida: DateTime.now().add(const Duration(days: 5)),
      status: StatusReserva.confirmada,
      valorTotal: 1200.0,
    ),
    ReservaEntity(
      id: '3',
      quartoId: '105',
      hospedeNome: 'Ana Paula Rodrigues',
      dataEntrada: DateTime.now().subtract(const Duration(days: 1)),
      dataSaida: DateTime.now(),
      status: StatusReserva.checkOut,
      valorTotal: 450.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Reservas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
            onPressed: () {}, // Futuro: Nova Reserva
          ),
        ],
      ),
      body: Column(
        children: [
          // --- Barra de Pesquisa Minimalista ---
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar por hóspede ou quarto...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                prefixIcon: Icon(Icons.search, color: accentColor),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // --- Lista de Reservas ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: reservasMock.length,
              itemBuilder: (context, index) {
                final reserva = reservasMock[index];
                return _buildReservaCard(context, reserva);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservaCard(BuildContext context, ReservaEntity reserva) {
    // Lógica de cores para o status da reserva
    Color statusColor;
    switch (reserva.status) {
      case StatusReserva.confirmada:
        statusColor = Colors.blue;
        break;
      case StatusReserva.checkIn:
        statusColor = const Color(0xFF10B981);
        break;
      case StatusReserva.checkOut:
        statusColor = Colors.orange;
        break;
      case StatusReserva.cancelada:
        statusColor = Colors.red;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reserva.hospedeNome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quarto ${reserva.quartoId} • ${reserva.totalDias} diárias',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  reserva.status.name.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.white10, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateInfo('Entrada', reserva.dataEntrada),
              _buildDateInfo('Saída', reserva.dataSaida),
              Text(
                'R\$ ${reserva.valorTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white24, fontSize: 10),
        ),
        Text(
          "${date.day}/${date.month}",
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
