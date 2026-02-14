import 'package:flutter/material.dart';
import 'package:hotelaria/presentation/pages/perfil_create_page.dart';
import '../../domain/entities/perfil.dart';
import '../../services/perfil_service.dart';
import 'perfil_edit_page.dart';

class PerfilListPage extends StatefulWidget {
  const PerfilListPage({super.key});

  @override
  State<PerfilListPage> createState() => _PerfilListPageState();
}

class _PerfilListPageState extends State<PerfilListPage> {
  final PerfilService _perfilService = PerfilService();
  late Future<List<PerfilEntity>> _perfisFuture;

  @override
  void initState() {
    super.initState();
    _carregarPerfis();
  }

  void _carregarPerfis() {
    setState(() {
      _perfisFuture = _perfilService.getPerfis();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestão de Perfis"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarPerfis,
          ),
        ],
      ),
      body: FutureBuilder<List<PerfilEntity>>(
        future: _perfisFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao carregar perfis: ${snapshot.error}"),
            );
          }

          final perfis = snapshot.data ?? [];

          if (perfis.isEmpty) {
            return const Center(child: Text("Nenhum perfil encontrado."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: perfis.length,
            itemBuilder: (context, index) {
              final perfil = perfis[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF38BDF8),
                    child: Icon(Icons.badge, color: Colors.black),
                  ),
                  title: Text(
                    perfil.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    perfil.permissoesResumo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    // Navega para a edição e aguarda o retorno
                    final mudou = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PerfilEditPage(perfil: perfil),
                      ),
                    );

                    // Se a edição retornou 'true', atualizamos a lista
                    if (mudou == true) {
                      _carregarPerfis();
                    }
                  },
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF38BDF8), // Azul do seu tema
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          // Abre a tela de criação e aguarda o retorno
          final criado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PerfilCreatePage()),
          );

          // Se retornou true, recarrega a lista do servidor
          if (criado == true) {
            _carregarPerfis();
          }
        },
      ),
    );
  }
}
