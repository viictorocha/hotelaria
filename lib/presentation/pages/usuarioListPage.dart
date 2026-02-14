import 'package:Hotelaria/domain/entities/usuario_entity.dart';
import 'package:Hotelaria/presentation/pages/usuario_create_page.dart';
import 'package:Hotelaria/services/usuario_service.dart';
import 'package:flutter/material.dart';

class UsuarioListPage extends StatefulWidget {
  const UsuarioListPage({super.key});

  @override
  State<UsuarioListPage> createState() => _UsuarioListPageState();
}

class _UsuarioListPageState extends State<UsuarioListPage> {
  final UsuarioService _usuarioService = UsuarioService();
  late Future<List<UsuarioEntity>> _futureUsuarios;

  @override
  void initState() {
    super.initState();
    _futureUsuarios = _usuarioService.getUsuarios();
  }

  void _atualizarLista() {
    setState(() {
      _futureUsuarios = _usuarioService.getUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equipe do Hotel')),
      body: FutureBuilder<List<UsuarioEntity>>(
        future: _futureUsuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar usuários: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum funcionário cadastrado.'));
          }

          final usuarios = snapshot.data!;

          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final user = usuarios[index];
              return ListTile(
                leading: CircleAvatar(child: Text(user.nome[0])),
                title: Text(user.nome),
                subtitle: Text(user.email),
                trailing: Chip(
                  label: Text(user.perfil?.nome ?? 'Sem Perfil'),
                  backgroundColor: Colors.blue.shade50,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega para a página de criação e aguarda o retorno
          final sucesso = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UsuarioCreatePage()),
          );

          if (sucesso == true) _atualizarLista();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
