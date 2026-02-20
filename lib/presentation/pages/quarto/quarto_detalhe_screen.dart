import 'package:flutter/material.dart';
import '../../../domain/entities/quarto_entity.dart';

class QuartoDetalheScreen extends StatelessWidget {
  final QuartoEntity quarto;

  const QuartoDetalheScreen({super.key, required this.quarto});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).cardColor;

    // Lógica de cores baseada no status (repetindo a do mapa para consistência)
    Color statusColor;
    switch (quarto.status) {
      case StatusQuarto.disponivel:
        statusColor = const Color(0xFF10B981);
        break;
      case StatusQuarto.ocupado:
        statusColor = const Color(0xFFEF4444);
        break;
      case StatusQuarto.limpeza:
        statusColor = const Color(0xFF8B5CF6);
        break;
      case StatusQuarto.manutencao:
        statusColor = const Color(0xFFF59E0B);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white70),
            onPressed: () {}, // Editar quarto
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Cabeçalho com Número e Status ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Hero(
                  tag: 'quarto-${quarto.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Quarto ${quarto.numero}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    quarto.status.name.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text(
              '${quarto.tipo.name.toUpperCase()} • R\$ ${quarto.precoBase.toStringAsFixed(2)}/noite',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 32),

            // --- Grid de Atributos ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAttributeCard(
                  Icons.people_outline,
                  "${quarto.capacidade} Pessoas",
                  cardColor,
                ),
                _buildAttributeCard(Icons.ac_unit, "Ar Cond.", cardColor),
                _buildAttributeCard(Icons.wifi, "Wi-Fi 5G", cardColor),
              ],
            ),

            const SizedBox(height: 32),

            // --- Seção Dinâmica (Hóspede ou Ações) ---
            if (quarto.status == StatusQuarto.ocupado) ...[
              const Text(
                'Hóspede Atual',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildGuestInfoCard(cardColor, accentColor),
            ] else if (quarto.status == StatusQuarto.disponivel) ...[
              _buildActionPrompt(accentColor),
            ],

            const SizedBox(height: 32),

            // --- Histórico ou Notas (Placeholder) ---
            const Text(
              'Notas Internas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhuma nota para este quarto. Toque para adicionar informações importantes sobre manutenção ou preferências de hóspedes.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),

      // --- Rodapé com Ações Fixas ---
      bottomNavigationBar: _buildBottomActions(quarto, statusColor),
    );
  }

  Widget _buildAttributeCard(IconData icon, String label, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestInfoCard(Color cardColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: accentColor.withValues(alpha: 0.2),
            child: Icon(Icons.person, color: accentColor),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ricardo Silva',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Check-out: Amanhã, 12:00',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildActionPrompt(Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withValues(alpha: 0.1)),
      ),
      child: const Column(
        children: [
          Icon(Icons.add_home_work_rounded, color: Colors.blue, size: 40),
          SizedBox(height: 12),
          Text(
            'Pronto para Check-in',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            'Este quarto está livre para novas reservas.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(QuartoEntity quarto, Color statusColor) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: statusColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            quarto.status == StatusQuarto.disponivel
                ? 'REALIZAR CHECK-IN'
                : 'GERENCIAR ESTADIA',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
