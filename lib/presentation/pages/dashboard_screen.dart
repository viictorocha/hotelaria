import 'package:flutter/material.dart';
import '../../domain/entities/quarto_entity.dart';
import '../../data/repositories/quarto_mock_repository.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).cardColor;

    // Dados para o Dashboard (na V1 pegamos do mock)
    final todosQuartos = QuartoMockRepository().getTodosOsQuartos();
    final ocupados = todosQuartos
        .where((q) => q.status == StatusQuarto.ocupado)
        .length;
    final taxaOcupacao = (ocupados / todosQuartos.length) * 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Seção de Resumo Financeiro ---
            const Text(
              'Desempenho Hoje',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ 1.250,00',
              style: TextStyle(
                color: accentColor,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // --- Grid de Métricas Rápidas ---
            Row(
              children: [
                _buildStatCard(
                  context,
                  'Ocupação',
                  '${taxaOcupacao.toStringAsFixed(0)}%',
                  Icons.analytics_outlined,
                  accentColor,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  context,
                  'Check-ins',
                  '4',
                  Icons.login_rounded,
                  const Color(0xFF10B981),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard(
                  context,
                  'Check-outs',
                  '2',
                  Icons.logout_rounded,
                  const Color(0xFFF59E0B),
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  context,
                  'Limpeza',
                  '3',
                  Icons.cleaning_services_rounded,
                  const Color(0xFF8B5CF6),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // --- Lista de Atividade Recente ---
            const Text(
              'Últimas Atividades',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              context,
              'Reserva Confirmada',
              'Quarto 101 • Ricardo Silva',
              '10 min atrás',
              Icons.event_available_rounded,
              const Color(0xFF10B981),
            ),
            _buildActivityItem(
              context,
              'Consumo Lançado',
              'Quarto 105 • 2x Cerveja Lata',
              '45 min atrás',
              Icons.shopping_cart_outlined,
              accentColor,
            ),
            _buildActivityItem(
              context,
              'Manutenção Necessária',
              'Quarto 202 • Ar condicionado',
              '2h atrás',
              Icons.build_circle_outlined,
              const Color(0xFFEF4444),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.white24, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
