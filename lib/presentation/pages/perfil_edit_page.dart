import 'package:flutter/material.dart';
import 'package:hotelaria/domain/entities/perfil.dart';
import '../../services/perfil_service.dart';
import '../../domain/entities/funcionalidade_entity.dart';

class PerfilEditPage extends StatefulWidget {
  final PerfilEntity perfil;

  const PerfilEditPage({super.key, required this.perfil});

  @override
  State<PerfilEditPage> createState() => _PerfilEditPageState();
}

class _PerfilEditPageState extends State<PerfilEditPage> {
  final PerfilService _perfilService = PerfilService();

  List<FuncionalidadeEntity> _todasFuncionalidades = [];
  List<int> _selecionadasIds = [];
  bool _isLoadingData = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Inicializa os IDs selecionados com o que o perfil já possui vindo do banco
    _selecionadasIds = widget.perfil.funcionalidades.map((f) => f.id).toList();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final funcs = await _perfilService.getTodasFuncionalidades();
      setState(() {
        _todasFuncionalidades = funcs;
        _isLoadingData = false;
      });
    } catch (e) {
      _showSnackBar("Erro ao carregar funcionalidades", isError: true);
      setState(() => _isLoadingData = false);
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);

    final sucesso = await _perfilService.updatePerfil(
      widget.perfil.id,
      widget.perfil.nome,
      _selecionadasIds,
    );

    setState(() => _isSaving = false);

    if (sucesso) {
      _showSnackBar("Perfil '${widget.perfil.nome}' atualizado!");
      Navigator.pop(context, true); // Retorna true para a lista recarregar
    } else {
      _showSnackBar("Falha ao salvar no servidor", isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Permissões: ${widget.perfil.nome}"),
        elevation: 0,
      ),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Selecione as funcionalidades que este perfil pode acessar no sistema:",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _todasFuncionalidades.length,
                    itemBuilder: (context, index) {
                      final func = _todasFuncionalidades[index];
                      final isSelected = _selecionadasIds.contains(func.id);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: CheckboxListTile(
                          activeColor: Theme.of(context).primaryColor,
                          title: Text(
                            func.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(func.descricao ?? "Sem descrição"),
                          value: isSelected,
                          onChanged: (bool? checked) {
                            setState(() {
                              if (checked == true) {
                                _selecionadasIds.add(func.id);
                              } else {
                                _selecionadasIds.remove(func.id);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: _isSaving ? null : _saveChanges,
          icon: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
          label: Text(_isSaving ? "Salvando..." : "SALVAR ALTERAÇÕES"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
