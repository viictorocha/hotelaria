import 'package:flutter/material.dart';

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Configurações',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSettingsGroup('Hotel', [
            _buildSettingsTile(
              Icons.hotel_outlined,
              'Dados da Pousada',
              'Nome, CNPJ, Endereço',
            ),
            _buildSettingsTile(
              Icons.bed_outlined,
              'Gerenciar Quartos',
              'Adicionar ou remover unidades',
            ),
          ]),
          const SizedBox(height: 32),
          _buildSettingsGroup('Sistema', [
            _buildSettingsTile(
              Icons.person_outline,
              'Perfil do Gestor',
              'Senha e e-mail',
            ),
            _buildSettingsTile(
              Icons.notifications_none_rounded,
              'Notificações',
              'Alertas de check-in e consumo',
            ),
            _buildSettingsTile(
              Icons.dark_mode_outlined,
              'Aparência',
              'Tema escuro habilitado',
            ),
          ]),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Sair da Conta',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white38, fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      onTap: () {},
    );
  }
}
