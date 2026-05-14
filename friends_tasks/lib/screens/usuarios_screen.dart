import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import 'tarefas_screen.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  List<Usuario> _usuarios = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista = await ApiService.listarUsuarios();
    setState(() {
      _usuarios = lista;
      _loading = false;
    });
  }

  void _novoUsuario() {
    final nomeCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Novo usuário'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await ApiService.criarUsuario(nomeCtrl.text, emailCtrl.text);
              if (mounted) Navigator.pop(context);
              _carregar();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _usuarios.length,
              itemBuilder: (_, i) {
                final u = _usuarios[i];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(u.nome),
                  subtitle: Text(u.email),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TarefasScreen(usuario: u)),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _novoUsuario,
        child: const Icon(Icons.add),
      ),
    );
  }
}
