import 'package:flutter/material.dart';
import '../../../domain/entities/pousada_entity.dart';
import '../../../services/pousada_service.dart';

class PousadaPage extends StatefulWidget {
  const PousadaPage({super.key});

  @override
  State<PousadaPage> createState() => _PousadaPageState();
}

class _PousadaPageState extends State<PousadaPage> {
  final _formKey = GlobalKey<FormState>();
  final _pousadaService = PousadaService();

  // Controllers para os campos existentes e novos
  final _nomeController = TextEditingController();
  final _razaoController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _telController = TextEditingController();
  final _endController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _checkInController = TextEditingController(text: "14:00");
  final _checkOutController = TextEditingController(text: "12:00");

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final p = await _pousadaService.getPousada();
      if (p != null) {
        _nomeController.text = p.nomeFantasia;
        _razaoController.text = p.razaoSocial;
        _cnpjController.text = p.cnpj;
        _telController.text = p.telefone;
        _endController.text = p.endereco;
        _cidadeController.text = p.cidade;
        _checkInController.text = p.checkInPadrao;
        _checkOutController.text = p.checkOutPadrao;
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selecionarHora(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(controller.text.split(":")[0]),
        minute: int.parse(controller.text.split(":")[1]),
      ),
    );
    if (picked != null) {
      setState(() {
        final String hora = picked.hour.toString().padLeft(2, '0');
        final String minuto = picked.minute.toString().padLeft(2, '0');
        controller.text = "$hora:$minuto";
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final p = PousadaEntity(
      id: 1, // Fixo conforme sua regra de negócio (sempre o primeiro registro)
      nomeFantasia: _nomeController.text.trim(),
      razaoSocial: _razaoController.text.trim(),
      cnpj: _cnpjController.text.trim(),
      telefone: _telController.text.trim(),
      endereco: _endController.text.trim(),
      cidade: _cidadeController.text.trim(),
      checkInPadrao: _checkInController.text,
      checkOutPadrao: _checkOutController.text,
    );

    final ok = await _pousadaService.salvarPousada(p);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok ? "Dados atualizados com sucesso!" : "Erro ao salvar dados",
          ),
          backgroundColor: ok ? Colors.green : Colors.red,
        ),
      );
      if (ok) Navigator.pop(context); // Opcional: volta para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dados da Pousada"), elevation: 0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionHeader("Informações Gerais"),
                    _buildField("Nome Fantasia", _nomeController, Icons.hotel),
                    _buildField(
                      "Razão Social",
                      _razaoController,
                      Icons.assignment_ind,
                    ),
                    _buildField("CNPJ", _cnpjController, Icons.business),

                    _buildSectionHeader("Contato e Localização"),
                    _buildField("Telefone", _telController, Icons.phone),
                    _buildField(
                      "Endereço Completo",
                      _endController,
                      Icons.location_on,
                    ),
                    _buildField("Cidade", _cidadeController, Icons.map),

                    _buildSectionHeader("Políticas de Horário"),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeField(
                            "Check-in",
                            _checkInController,
                            Icons.login,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTimeField(
                            "Check-out",
                            _checkOutController,
                            Icons.logout,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _salvar,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "SALVAR ALTERAÇÕES",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor.withOpacity(0.7),
          letterSpacing: 1.2,
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
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        validator: (v) => v!.isEmpty ? "Campo obrigatório" : null,
      ),
    );
  }

  Widget _buildTimeField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      onTap: () => _selecionarHora(controller),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _razaoController.dispose();
    _cnpjController.dispose();
    _telController.dispose();
    _endController.dispose();
    _cidadeController.dispose();
    _checkInController.dispose();
    _checkOutController.dispose();
    super.dispose();
  }
}
