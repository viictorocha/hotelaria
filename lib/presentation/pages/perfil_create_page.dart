import 'package:flutter/material.dart';
import 'package:Hotelaria/domain/entities/funcionalidade_entity.dart';
import '../../services/perfil_service.dart';

class PerfilCreatePage extends StatefulWidget {
  const PerfilCreatePage({super.key});

  @override
  State<PerfilCreatePage> createState() => _PerfilCreatePageState();
}

class _PerfilCreatePageState extends State<PerfilCreatePage> {
  final PerfilService _perfilService = PerfilService();
  final TextEditingController _nomeController = TextEditingController();

  List<FuncionalidadeEntity> _todasFuncionalidades = [];
  List<int> _selecionadasIds = [];
  bool _isLoadingData = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchFuncionalidades();
  }

  Future<void> _fetchFuncionalidades() async {
    try {
      final funcs = await _perfilService.getTodasFuncionalidades();
      setState(() {
        _todasFuncionalidades = funcs;
        _isLoadingData = false;
      });
    } catch (e) {
      _showSnackBar("Erro ao carregar permissões", isError: true);
    }
  }

  Future<void> _salvarPerfil() async {
    if (_nomeController.text.trim().isEmpty) {
      _showSnackBar("Por favor, insira um nome para o perfil", isError: true);
      return;
    }

    setState(() => _isSaving = true);

    // No PerfilService, o método 'criarPerfil' envia o POST para a API
    final sucesso = await _perfilService.criarPerfil(
      _nomeController.text.trim(),
      _selecionadasIds,
    );

    setState(() => _isSaving = false);

    if (sucesso) {
      _showSnackBar("Perfil criado com sucesso!");
      Navigator.pop(context, true); // Volta para a lista e sinaliza atualização
    } else {
      _showSnackBar("Erro ao criar perfil no servidor", isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo Perfil de Acesso")),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome do Perfil (ex: Recepcionista)",
                      prefixIcon: Icon(Icons.badge),
                    ),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Selecione as Permissões:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _todasFuncionalidades.length,
                    itemBuilder: (context, index) {
                      final f = _todasFuncionalidades[index];
                      return CheckboxListTile(
                        title: Text(f.nome),
                        subtitle: Text(f.descricao ?? ""),
                        value: _selecionadasIds.contains(f.id),
                        onChanged: (val) {
                          setState(() {
                            val!
                                ? _selecionadasIds.add(f.id)
                                : _selecionadasIds.remove(f.id);
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _salvarPerfil,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isSaving
              ? const CircularProgressIndicator()
              : const Text("CRIAR PERFIL"),
        ),
      ),
    );
  }
}
