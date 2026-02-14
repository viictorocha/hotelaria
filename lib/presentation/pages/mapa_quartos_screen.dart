import 'package:flutter/material.dart';
import 'package:Hotelaria/presentation/pages/quarto_detalhe_screen.dart';
import '../../domain/entities/quarto_entity.dart';
import '../../data/repositories/quarto_mock_repository.dart';

class MapaQuartosScreen extends StatefulWidget {
  const MapaQuartosScreen({super.key});

  @override
  State<MapaQuartosScreen> createState() => _MapaQuartosScreenState();
}

class _MapaQuartosScreenState extends State<MapaQuartosScreen> {
  // 1. Pegamos a lista original do mock
  final List<QuartoEntity> todosOsQuartos = QuartoMockRepository()
      .getTodosOsQuartos();

  // 2. Variável para controlar o filtro (null significa "Todos")
  StatusQuarto? statusSelecionado;

  // 3. Lógica que filtra a lista em tempo real para o GridView
  List<QuartoEntity> get quartosFiltrados {
    if (statusSelecionado == null) return todosOsQuartos;
    return todosOsQuartos.where((q) => q.status == statusSelecionado).toList();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mapa de Quartos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filtros
          _buildFiltros(accentColor),

          // Grid que agora usa os 'quartosFiltrados'
          Expanded(
            child: quartosFiltrados.isEmpty
                ? _buildEmptyState() // Caso não tenha quartos naquele status
                : GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: quartosFiltrados.length,
                    itemBuilder: (context, index) {
                      return _buildQuartoCard(quartosFiltrados[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltros(Color accentColor) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _filterChip(
            "Todos",
            isSelected: statusSelecionado == null,
            onTap: () {
              setState(() => statusSelecionado = null);
            },
          ),
          _filterChip(
            "Disponíveis",
            isSelected: statusSelecionado == StatusQuarto.disponivel,
            onTap: () {
              setState(() => statusSelecionado = StatusQuarto.disponivel);
            },
          ),
          _filterChip(
            "Ocupados",
            isSelected: statusSelecionado == StatusQuarto.ocupado,
            onTap: () {
              setState(() => statusSelecionado = StatusQuarto.ocupado);
            },
          ),
          _filterChip(
            "Limpeza",
            isSelected: statusSelecionado == StatusQuarto.limpeza,
            onTap: () {
              setState(() => statusSelecionado = StatusQuarto.limpeza);
            },
          ),
        ],
      ),
    );
  }

  Widget _filterChip(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          // Borda sutil para dar profundidade
          border: Border.all(
            color: isSelected ? Colors.white24 : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            "Nenhum quarto encontrado\ncom este status.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuartoCard(QuartoEntity quarto) {
    // Definindo a cor baseada no status
    Color statusColor;
    switch (quarto.status) {
      case StatusQuarto.disponivel:
        statusColor = const Color(0xFF10B981); // Verde Esmeralda
        break;
      case StatusQuarto.ocupado:
        statusColor = const Color(0xFFEF4444); // Vermelho
        break;
      case StatusQuarto.limpeza:
        statusColor = const Color(0xFF8B5CF6); // Roxo
        break;
      case StatusQuarto.manutencao:
        statusColor = const Color(0xFFF59E0B); // Âmbar
        break;
    }

    // 1. Adicionamos o GestureDetector para detectar o toque
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuartoDetalheScreen(quarto: quarto),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 2. Adicionamos o Hero para animação fluida (a tag deve ser única por quarto)
                  Hero(
                    tag: 'quarto-${quarto.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        '#${quarto.numero}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    quarto.status == StatusQuarto.disponivel
                        ? Icons.check_circle_outline
                        : Icons.do_not_disturb_on_outlined,
                    color: statusColor,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                quarto.tipo.name.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: Colors.white70,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${quarto.capacidade}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    quarto.status.name.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
