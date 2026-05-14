import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';

class TarefasScreen extends StatefulWidget {
  final Usuario usuario;
  const TarefasScreen({super.key, required this.usuario});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  List<Tarefa> _tarefas = [];
  bool _loading = true;

  static const _statusOpcoes = ['PENDENTE', 'EM_ANDAMENTO', 'CONCLUIDA'];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista = await ApiService.listarTarefas(widget.usuario.id);
    setState(() {
      _tarefas = lista;
      _loading = false;
    });
  }

  void _novaTarefa() {
    final tituloCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova tarefa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: tituloCtrl, decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descrição')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await ApiService.criarTarefa(
                  tituloCtrl.text, descCtrl.text, widget.usuario.id);
              if (mounted) Navigator.pop(context);
              _carregar();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _compartilhar(Tarefa tarefa) async {
    final usuarios = await ApiService.listarUsuarios();
    if (!mounted) return;

    final outros = usuarios.where((u) => u.id != widget.usuario.id).toList();
    if (outros.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nenhum amigo cadastrado')));
      return;
    }

    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Compartilhar com'),
        children: outros
            .map((u) => SimpleDialogOption(
                  onPressed: () async {
                    await ApiService.compartilharTarefa(tarefa.id, u.id);
                    if (mounted) Navigator.pop(context);
                    _carregar();
                  },
                  child: Text(u.nome),
                ))
            .toList(),
      ),
    );
  }

  void _atualizarStatus(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Atualizar status'),
        children: _statusOpcoes
            .map((s) => SimpleDialogOption(
                  onPressed: () async {
                    await ApiService.atualizarStatus(tarefa.id, s);
                    if (mounted) Navigator.pop(context);
                    _carregar();
                  },
                  child: Text(s),
                ))
            .toList(),
      ),
    );
  }

  Color _statusColor(String status) => switch (status) {
        'CONCLUIDA' => Colors.green,
        'EM_ANDAMENTO' => Colors.orange,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tarefas — ${widget.usuario.nome}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tarefas.isEmpty
              ? const Center(child: Text('Nenhuma tarefa'))
              : ListView.builder(
                  itemCount: _tarefas.length,
                  itemBuilder: (_, i) {
                    final t = _tarefas[i];
                    final ehDono = t.dono.id == widget.usuario.id;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(t.titulo),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (t.descricao.isNotEmpty) Text(t.descricao),
                            if (!ehDono)
                              Text('Dono: ${t.dono.nome}',
                                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                            if (t.amigos.isNotEmpty)
                              Text(
                                  'Compartilhado com: ${t.amigos.map((a) => a.nome).join(', ')}',
                                  style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(t.status,
                              style: const TextStyle(color: Colors.white, fontSize: 11)),
                          backgroundColor: _statusColor(t.status),
                        ),
                        onTap: () => _atualizarStatus(t),
                        onLongPress: ehDono ? () => _compartilhar(t) : null,
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _novaTarefa,
        child: const Icon(Icons.add),
      ),
    );
  }
}
