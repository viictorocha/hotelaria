import 'package:flutter/material.dart';
import 'package:hotelaria/presentation/pages/configuracoes_screen.dart';
import 'package:hotelaria/presentation/pages/consumo_screen.dart';
import 'package:hotelaria/presentation/pages/dashboard_screen.dart';
import 'package:hotelaria/presentation/pages/financeiro_screen.dart';
import 'package:hotelaria/presentation/pages/mapa_quartos_screen.dart';
import 'package:hotelaria/presentation/pages/reservas_lista_screen.dart';

class HomeMenuScreen extends StatelessWidget {
  const HomeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Cabeçalho ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bom dia, Gestor',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Hotelaria Pro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Avatar simples
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: accentColor, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=12',
                      ), // Imagem placeholder
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                'Visão Geral',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // --- Grid do Menu ---
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2, // 2 colunas
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1, // Formato levemente retangular
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.dashboard_rounded,
                      label: 'Dashboard',
                      color: accentColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.meeting_room_rounded,
                      label: 'Mapa de Quartos',
                      color: accentColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapaQuartosScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.calendar_month_rounded,
                      label: 'Reservas',
                      color: accentColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReservasListaScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.room_service_rounded,
                      label: 'Consumo',
                      color: accentColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConsumoScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.attach_money_rounded,
                      label: 'Financeiro',
                      color: accentColor,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FinanceiroScreen(),
                        ),
                      ),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.settings_rounded,
                      label: 'Configurações',
                      color: Colors.grey,
                      isSecondary: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConfiguracoesScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isSecondary = false,
  }) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        // ATUALIZADO: Usando withValues em vez de withOpacity
        splashColor: color.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSecondary
                      ? Colors.white.withValues(alpha: 0.05)
                      : color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSecondary ? Colors.white70 : color,
                  size: 28,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
