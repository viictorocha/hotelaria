import 'package:flutter/material.dart';

class FinanceiroScreen extends StatelessWidget {
  const FinanceiroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Financeiro',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- Card de Saldo Atual ---
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor, accentColor.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saldo em Caixa',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'R\$ 12.450,00',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMiniStat('Entradas', 'R\$ 1.500', Icons.arrow_upward),
                    _buildMiniStat('Saídas', 'R\$ 450', Icons.arrow_downward),
                  ],
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transações Recentes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.filter_list, color: Colors.white54),
              ],
            ),
          ),

          // --- Lista de Transações ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildTransactionItem(
                  'Reserva Q. 101',
                  'Hoje, 09:40',
                  'R\$ 450,00',
                  true,
                ),
                _buildTransactionItem(
                  'Limpeza - Produtos',
                  'Hoje, 08:20',
                  '- R\$ 120,00',
                  false,
                ),
                _buildTransactionItem(
                  'Consumo Q. 204',
                  'Ontem',
                  'R\$ 85,00',
                  true,
                ),
                _buildTransactionItem(
                  'Manutenção AC',
                  'Ontem',
                  '- R\$ 350,00',
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black45),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.black45, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String title,
    String date,
    String value,
    bool isPositive,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                date,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: isPositive ? const Color(0xFF10B981) : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
