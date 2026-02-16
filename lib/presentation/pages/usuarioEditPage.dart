import 'package:flutter/material.dart';
import '../../domain/entities/perfil_entity.dart';
import '../../domain/entities/usuario_entity.dart';
import '../../services/perfil_service.dart';
import '../../services/usuario_service.dart';

class UsuarioEditPage extends StatefulWidget {
  final UsuarioEntity usuario; // Recebe o usuário que será editado

  const UsuarioEditPage({super.key, required this.usuario});

  @override
  State<UsuarioEditPage> createState() => _UsuarioEditPageState();
}

class _UsuarioEditPageState extends State<UsuarioEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioService = UsuarioService();
  final _perfilService = PerfilService();

  late TextEditingController _nomeController;
  late TextEditingController _emailController;

  List<PerfilEntity> _perfis = [];
  int? _perfilSelecionadoId;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Inicializa os controllers com os dados atuais do usuário
    _nomeController = TextEditingController(text: widget.usuario.nome);
    _emailController = TextEditingController(text: widget.usuario.email);
    _perfilSelecionadoId = widget.usuario.perfilId;
    _carregarPerfis();
  }

  Future<void> _carregarPerfis() async {
    final lista = await _perfilService.getPerfis();
    setState(() {
      _perfis = lista;
      _isLoading = false;
    });
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate() || _perfilSelecionadoId == null) {
      return;
    }

    setState(() => _isSaving = true);

    // Criamos uma entidade atualizada
    final usuarioAtualizado = UsuarioEntity(
      id: widget.usuario.id, // Mantém o ID original
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      perfilId: _perfilSelecionadoId!,
      // Senha geralmente não é enviada na edição simples por segurança
    );

    // Você precisará criar o método 'atualizarUsuario' no seu UsuarioService
    final sucesso = await _usuarioService.atualizarUsuario(usuarioAtualizado);

    setState(() => _isSaving = false);

    if (sucesso) {
      if (mounted) Navigator.pop(context, true);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro ao atualizar usuário"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Usuário")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: "Nome Completo",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (v) => v!.isEmpty ? "Obrigatório" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "E-mail",
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v!.contains("@") ? null : "E-mail inválido",
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<int>(
                      value: _perfilSelecionadoId,
                      decoration: const InputDecoration(
                        labelText: "Perfil / Nível de Acesso",
                        prefixIcon: Icon(Icons.admin_panel_settings),
                      ),
                      items: _perfis.map((p) {
                        return DropdownMenuItem(
                          value: p.id,
                          child: Text(p.nome),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _perfilSelecionadoId = val),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _salvarAlteracoes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "SALVAR ALTERAÇÕES",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
