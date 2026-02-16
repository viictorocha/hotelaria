import 'package:flutter/material.dart';
import '../../domain/entities/pousada_entity.dart';
import '../../services/pousada_service.dart';

class PousadaPage extends StatefulWidget {
  const PousadaPage({super.key});

  @override
  State<PousadaPage> createState() => _PousadaPageState();
}

class _PousadaPageState extends State<PousadaPage> {
  final _formKey = GlobalKey<FormState>();
  final _pousadaService = PousadaService();

  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _telController = TextEditingController();
  final _endController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final p = await _pousadaService.getPousada();
    if (p != null) {
      _nomeController.text = p.nomeFantasia;
      _cnpjController.text = p.cnpj;
      _telController.text = p.telefone;
      _endController.text = p.endereco;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final p = PousadaEntity(
      nomeFantasia: _nomeController.text.trim(),
      cnpj: _cnpjController.text.trim(),
      telefone: _telController.text.trim(),
      endereco: _endController.text.trim(),
    );

    final ok = await _pousadaService.salvarPousada(p);

    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? "Dados atualizados!" : "Erro ao salvar"),
          backgroundColor: ok ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dados da Pousada")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildField("Nome Fantasia", _nomeController, Icons.hotel),
                    _buildField("CNPJ", _cnpjController, Icons.business),
                    _buildField("Telefone", _telController, Icons.phone),
                    _buildField("Endereço", _endController, Icons.location_on),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _salvar,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator()
                          : const Text("SALVAR ALTERAÇÕES"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
      ),
    );
  }
}
