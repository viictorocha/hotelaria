import 'package:flutter/material.dart';
import '../../domain/entities/perfil_entity.dart';
import '../../domain/entities/usuario_entity.dart';
import '../../services/perfil_service.dart';
import '../../services/usuario_service.dart';

class UsuarioCreatePage extends StatefulWidget {
  const UsuarioCreatePage({super.key});

  @override
  State<UsuarioCreatePage> createState() => _UsuarioCreatePageState();
}

class _UsuarioCreatePageState extends State<UsuarioCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioService = UsuarioService();
  final _perfilService = PerfilService();

  // Controllers
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  List<PerfilEntity> _perfis = [];
  int? _perfilSelecionadoId;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _carregarPerfis();
  }

  Future<void> _carregarPerfis() async {
    final lista = await _perfilService.getPerfis();
    setState(() {
      _perfis = lista;
      _isLoading = false;
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate() || _perfilSelecionadoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha todos os campos e selecione um perfil"),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final novoUsuario = UsuarioEntity(
      id: 0,
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      senha: _senhaController.text.trim(),
      perfilId: _perfilSelecionadoId!,
    );

    final sucesso = await _usuarioService.criarUsuario(novoUsuario);

    setState(() => _isSaving = false);

    if (sucesso) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao criar usuário"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo Usuário")),
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senhaController,
                      decoration: const InputDecoration(
                        labelText: "Senha Provisória",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (v) =>
                          v!.length < 6 ? "Mínimo 6 caracteres" : null,
                    ),
                    const SizedBox(height: 24),

                    // --- O DROPDOWN DE PERFIS ---
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
                      validator: (v) =>
                          v == null ? "Selecione um perfil" : null,
                    ),

                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _salvar,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator()
                          : const Text("CADASTRAR USUÁRIO"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
