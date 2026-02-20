import 'package:Hotelaria/domain/entities/usuario_entity.dart';
import 'package:Hotelaria/presentation/pages/configuracoes/configuracoes_screen.dart';
import 'package:Hotelaria/presentation/pages/financeiro/financeiro_screen.dart';
import 'package:Hotelaria/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:Hotelaria/presentation/pages/consumo/consumo_screen.dart';
import 'package:Hotelaria/presentation/pages/dashboard/dashboard_screen.dart';
import 'package:Hotelaria/presentation/pages/quarto/mapa_quartos_screen.dart';
import 'package:Hotelaria/presentation/pages/reserva/reservas_lista_screen.dart';

class HomeMenuScreen extends StatefulWidget {
  const HomeMenuScreen({super.key});

  @override
  State<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen> {
  UsuarioEntity? _usuario;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    final user = await AuthService.getUsuarioLogado();

    setState(() {
      _usuario = user;
      _isLoading = false;
    });
  }

  bool _temAcesso(String funcionalidade) {
    if (_usuario == null) return false;
    if (_usuario!.perfilId == 1) return true;

    final buscaNormalizada = funcionalidade
        .toLowerCase()
        .replaceAll('_', '')
        .replaceAll(' ', '');

    return _usuario!.perfil?.funcionalidades?.any((f) {
          final nomeApiNormalizado = f.nome
              .toLowerCase()
              .replaceAll('_', '')
              .replaceAll(' ', '');
          return nomeApiNormalizado == buscaNormalizada;
        }) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final accentColor = Theme.of(context).primaryColor;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Cabeçalho Dinâmico ---
              // --- Cabeçalho ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bom dia, ${_usuario?.nome.split(' ')[0] ?? 'Gestor'}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
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

                  // --- Avatar com Menu de Sair ---
                  PopupMenuButton<int>(
                    offset: const Offset(
                      0,
                      50,
                    ), // Faz o menu aparecer abaixo do avatar
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onSelected: (value) async {
                      if (value == 1) {
                        // 1. Limpa os dados do SharedPreferences usando seu AuthService
                        final authService = AuthService();
                        await authService
                            .logout(); // Certifique-se de que o logout() está implementado

                        // 2. Volta para a tela de login removendo todas as rotas anteriores
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Sair da Conta',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          Colors.grey[200], // Fundo neutro caso a imagem falhe
                      backgroundImage: const NetworkImage(
                        'https://i.pravatar.cc/150?img=12',
                      ),
                      // ESSA É A CHAVE: Trata o erro de rede/CORS
                      onBackgroundImageError: (exception, stackTrace) {
                        debugPrint("Erro ao carregar avatar: $exception");
                      },
                      // O ícone abaixo só aparece se a imagem falhar ou estiver carregando
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 24,
                      ),
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

              // --- Grid do Menu com Filtro de Permissões ---
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    if (_temAcesso('Dashboard'))
                      _buildMenuItem(
                        context,
                        icon: Icons.dashboard_rounded,
                        label: 'Dashboard',
                        color: accentColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DashboardScreen(),
                          ),
                        ),
                      ),

                    if (_temAcesso('MapaQuartos'))
                      _buildMenuItem(
                        context,
                        icon: Icons.meeting_room_rounded,
                        label: 'Mapa de Quartos',
                        color: accentColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MapaQuartosScreen(),
                          ),
                        ),
                      ),

                    if (_temAcesso('Reservas'))
                      _buildMenuItem(
                        context,
                        icon: Icons.calendar_month_rounded,
                        label: 'Reservas',
                        color: accentColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReservasListaScreen(),
                          ),
                        ),
                      ),

                    if (_temAcesso('Consumo'))
                      _buildMenuItem(
                        context,
                        icon: Icons.room_service_rounded,
                        label: 'Consumo',
                        color: accentColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ConsumoScreen(),
                          ),
                        ),
                      ),

                    if (_temAcesso('Financeiro'))
                      _buildMenuItem(
                        context,
                        icon: Icons.attach_money_rounded,
                        label: 'Financeiro',
                        color: accentColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FinanceiroScreen(),
                          ),
                        ),
                      ),

                    if (_temAcesso('Configuracoes'))
                      _buildMenuItem(
                        context,
                        icon: Icons.settings_rounded,
                        label: 'Configurações',
                        color: Colors.grey,
                        isSecondary: true,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ConfiguracoesScreen(),
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
