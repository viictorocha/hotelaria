import 'package:flutter/material.dart';
import '../../../domain/entities/quarto_entity.dart';
import '../../../services/quarto_service.dart';

class QuartoFormScreen extends StatefulWidget {
  final QuartoEntity? quarto; // null = Novo Quarto

  const QuartoFormScreen({super.key, this.quarto});

  @override
  State<QuartoFormScreen> createState() => _QuartoFormScreenState();
}

class _QuartoFormScreenState extends State<QuartoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quartoService = QuartoService();

  late TextEditingController _numeroController;
  late TextEditingController _precoController;
  late TextEditingController _capacidadeController;

  TipoQuarto _tipoSelecionado = TipoQuarto.standard;
  StatusQuarto _statusSelecionado = StatusQuarto.disponivel;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Inicializa os campos se for edição, ou vazios se for novo
    _numeroController = TextEditingController(
      text: widget.quarto?.numero ?? '',
    );
    _precoController = TextEditingController(
      text: widget.quarto?.precoBase.toString() ?? '',
    );
    _capacidadeController = TextEditingController(
      text: widget.quarto?.capacidade.toString() ?? '2',
    );

    if (widget.quarto != null) {
      _tipoSelecionado = widget.quarto!.tipo;
      _statusSelecionado = widget.quarto!.status;
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final quartoParaSalvar = QuartoEntity(
      id: widget.quarto?.id ?? 0,
      numero: _numeroController.text,
      tipo: _tipoSelecionado,
      status: _statusSelecionado,
      capacidade: int.parse(_capacidadeController.text),
      precoBase: double.parse(_precoController.text.replaceAll(',', '.')),
    );

    final sucesso = await _quartoService.salvarQuarto(quartoParaSalvar);

    if (mounted) {
      setState(() => _isSaving = false);
      if (sucesso) {
        Navigator.pop(
          context,
          true,
        ); // Retorna true para atualizar a lista anterior
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados salvos com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar no servidor.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.quarto != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Unidade' : 'Novo Quarto'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Campo Número
            TextFormField(
              controller: _numeroController,
              decoration: const InputDecoration(
                labelText: 'Número do Quarto',
                prefixIcon: Icon(Icons.meeting_room_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Informe o número' : null,
            ),
            const SizedBox(height: 20),

            // Dropdown Tipo
            DropdownButtonFormField<TipoQuarto>(
              value: _tipoSelecionado,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              items: TipoQuarto.values
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.name.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _tipoSelecionado = v!),
            ),
            const SizedBox(height: 20),

            // Linha com Preço e Capacidade
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _precoController,
                    decoration: const InputDecoration(
                      labelText: 'Preço/Noite',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _capacidadeController,
                    decoration: const InputDecoration(
                      labelText: 'Pessoas',
                      prefixIcon: Icon(Icons.people_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _isSaving ? null : _salvar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.black)
                  : Text(
                      isEdicao ? 'ATUALIZAR' : 'CADASTRAR',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
