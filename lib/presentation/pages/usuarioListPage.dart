import 'package:Hotelaria/domain/entities/usuario_entity.dart';
import 'package:Hotelaria/presentation/pages/UsuarioEditPage.dart';
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

              // Widget que permite deslizar para excluir
              return Dismissible(
                key: Key(user.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Excluir Usuário?"),
                      content: Text("Deseja remover ${user.nome}?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text("NÃO"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            "SIM",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) async {
                  final ok = await _usuarioService.deletarUsuario(user.id);
                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${user.nome} removido")),
                    );
                  }
                  _atualizarLista();
                },
                child: ListTile(
                  leading: CircleAvatar(child: Text(user.nome[0])),
                  title: Text(user.nome),
                  subtitle: Text(user.email),
                  trailing: Chip(
                    label: Text(user.perfil?.nome ?? 'Sem Perfil'),
                    backgroundColor: Colors.blue.shade50,
                  ),
                  onTap: () async {
                    final editado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UsuarioEditPage(usuario: user),
                      ),
                    );
                    if (editado == true) _atualizarLista();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
