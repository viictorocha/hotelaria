import 'package:flutter/material.dart';
import 'package:Hotelaria/services/quarto_service.dart';
import '../../../domain/entities/quarto_entity.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final QuartoService _quartoService = QuartoService();

  // Variáveis de estado
  bool _isLoading = true;
  int _totalOcupados = 0;
  int _totalQuartos = 0;
  int _emLimpeza = 0;
  double _faturamento = 0.0;

  @override
  void initState() {
    super.initState();
    _atualizarDados();
  }

  Future<void> _atualizarDados() async {
    setState(() => _isLoading = true);

    // 1. Busca quartos para calcular ocupação e limpeza
    final quartos = await _quartoService.getQuartos();

    // 2. Simulando busca de faturamento (ou chame seu novo endpoint)
    // final stats = await _financeiroService.getStatsHoje();

    if (mounted) {
      setState(() {
        _totalQuartos = quartos.length;
        _totalOcupados = quartos
            .where((q) => q.status == StatusQuarto.ocupado)
            .length;
        _emLimpeza = quartos
            .where((q) => q.status == StatusQuarto.limpeza)
            .length;
        _faturamento = 1250.00; // Mock por enquanto ou stats['total']
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;
    final taxaOcupacao = _totalQuartos > 0
        ? (_totalOcupados / _totalQuartos) * 100
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _atualizarDados,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _atualizarDados,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Desempenho Hoje',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${_faturamento.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Grid de Métricas Dinâmicas
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
                          '$_emLimpeza',
                          Icons.cleaning_services_rounded,
                          const Color(0xFF8B5CF6),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    const Text(
                      'Últimas Atividades',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Aqui você pode mapear uma lista de notificações vinda da API
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
                  ],
                ),
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
