import 'dart:convert';

import 'package:Hotelaria/constants/api_constants.dart';
import 'package:Hotelaria/services/quarto_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/quarto_entity.dart';

class ConsumoScreen extends StatefulWidget {
  const ConsumoScreen({super.key});

  @override
  State<ConsumoScreen> createState() => _ConsumoScreenState();
}

class _ConsumoScreenState extends State<ConsumoScreen> {
  final QuartoService _quartoService = QuartoService();
  List<QuartoEntity> _quartosOcupados = []; // Agora buscamos da API
  bool _isLoading = true;
  int? quartoSelecionadoId;

  // Itens de consumo mocados para a V1
  final List<Map<String, dynamic>> itensMenu = [
    {
      'nome': 'Água s/ Gás',
      'preco': 5.0,
      'icone': Icons.water_drop,
      'cor': Colors.blue,
    },
    {
      'nome': 'Cerveja Lata',
      'preco': 12.0,
      'icone': Icons.local_drink,
      'cor': Colors.amber,
    },
    {
      'nome': 'Refrigerante',
      'preco': 8.0,
      'icone': Icons.liquor,
      'cor': Colors.red,
    },
    {
      'nome': 'Snacks/Chips',
      'preco': 10.0,
      'icone': Icons.fastfood,
      'cor': Colors.orange,
    },
    {
      'nome': 'Lavanderia',
      'preco': 35.0,
      'icone': Icons.local_laundry_service,
      'cor': Colors.teal,
    },
    {
      'nome': 'Café Extra',
      'preco': 15.0,
      'icone': Icons.coffee,
      'cor': Colors.brown,
    },
  ];

  @override
  void initState() {
    super.initState();
    _carregarQuartosOcupados();
  }

  Future<void> _carregarQuartosOcupados() async {
    final todos = await _quartoService.getQuartos();
    setState(() {
      _quartosOcupados = todos
          .where((q) => q.status == StatusQuarto.ocupado)
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _lancarConsumoNoBanco(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/consumo"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'quartoId': quartoSelecionadoId,
        'descricao': item['nome'],
        'valor': item['preco'],
        'quantidade': 1,
      }),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${item['nome']} lançado no Quarto $quartoSelecionadoId!",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Lançar Consumo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Seleção de Quarto ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              'Para qual quarto?',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          _buildSelecaoQuartos(accentColor),

          const SizedBox(height: 24),

          // --- Menu de Itens ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Selecione o Item',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemCount: itensMenu.length,
              itemBuilder: (context, index) {
                final item = itensMenu[index];
                return _buildItemCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelecaoQuartos(Color accentColor) {
    if (_quartosOcupados.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          "Nenhum quarto ocupado no momento.",
          style: TextStyle(color: Colors.white38),
        ),
      );
    }
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _quartosOcupados.length,
        itemBuilder: (context, index) {
          final q = _quartosOcupados[index];
          final isSelected = quartoSelecionadoId == q.id;
          return GestureDetector(
            onTap: () => setState(() => quartoSelecionadoId = q.id),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? accentColor : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? Colors.white24 : Colors.transparent,
                ),
              ),
              child: Center(
                child: Text(
                  'Q. ${q.numero}',
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return InkWell(
      onTap: quartoSelecionadoId == null
          ? () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Selecione um quarto primeiro!")),
            )
          : () => _confirmarLancamento(item),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item['icone'], color: item['cor'], size: 30),
            const SizedBox(height: 8),
            Text(
              item['nome'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'R\$ ${item['preco'].toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarLancamento(Map<String, dynamic> item) {
    final quarto = _quartosOcupados.firstWhere(
      (q) => q.id == quartoSelecionadoId,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${item['nome']} para o Quarto ${quarto.numero}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _lancarConsumoNoBanco(item);
              },
              child: const Text('CONFIRMAR'),
            ),
          ],
        ),
      ),
    );
  }
}
