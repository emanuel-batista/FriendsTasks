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
    if (!mounted) return;
    setState(() {
      _tarefas = lista;
      _loading = false;
    });
  }

  String _statusLabel(String status) => switch (status) {
        'CONCLUIDA' => 'Concluída',
        'EM_ANDAMENTO' => 'Em andamento',
        _ => 'Pendente',
      };

  Color _statusBg(String status) => switch (status) {
        'CONCLUIDA' => const Color(0xFFD1FAE5),
        'EM_ANDAMENTO' => const Color(0xFFDBEAFE),
        _ => const Color(0xFFF3F4F6),
      };

  Color _statusFg(String status) => switch (status) {
        'CONCLUIDA' => const Color(0xFF065F46),
        'EM_ANDAMENTO' => const Color(0xFF1E40AF),
        _ => const Color(0xFF6B7280),
      };

  IconData _statusIcon(String status) => switch (status) {
        'CONCLUIDA' => Icons.check_circle_rounded,
        'EM_ANDAMENTO' => Icons.timelapse_rounded,
        _ => Icons.radio_button_unchecked_rounded,
      };

  void _novaTarefa() {
    final tituloCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova tarefa', style: TextStyle(fontWeight: FontWeight.w600)),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            TextField(
              controller: tituloCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Título',
                prefixIcon: Icon(Icons.title_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                prefixIcon: Icon(Icons.notes_rounded),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum amigo cadastrado')),
      );
      return;
    }

    final scheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: Row(
          children: [
            Icon(Icons.people_outline_rounded, size: 20, color: scheme.primary),
            const SizedBox(width: 8),
            const Text('Compartilhar com',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ],
        ),
        children: outros
            .map((u) => SimpleDialogOption(
                  onPressed: () async {
                    await ApiService.compartilharTarefa(tarefa.id, u.id);
                    if (mounted) Navigator.pop(context);
                    _carregar();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: scheme.primaryContainer,
                          foregroundColor: scheme.onPrimaryContainer,
                          child: Text(
                            u.nome.isNotEmpty ? u.nome[0].toUpperCase() : '?',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(u.nome, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  void _atualizarStatus(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: Row(
          children: [
            Icon(Icons.tune_rounded, size: 20,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Atualizar status',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ],
        ),
        children: _statusOpcoes
            .map((s) => SimpleDialogOption(
                  onPressed: () async {
                    await ApiService.atualizarStatus(tarefa.id, s);
                    if (mounted) Navigator.pop(context);
                    _carregar();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(_statusIcon(s), color: _statusFg(s), size: 20),
                        const SizedBox(width: 10),
                        Text(_statusLabel(s), style: const TextStyle(fontSize: 14)),
                        if (s == tarefa.status) ...[
                          const Spacer(),
                          Icon(Icons.check_rounded,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary),
                        ],
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.usuario.nome,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Text(
              'Tarefas',
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _carregar,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Atualizar',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _loading
            ? const Center(key: ValueKey('loading'), child: CircularProgressIndicator())
            : _tarefas.isEmpty
                ? Center(
                    key: const ValueKey('empty'),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.assignment_outlined,
                            size: 56, color: scheme.outlineVariant),
                        const SizedBox(height: 12),
                        Text(
                          'Nenhuma tarefa ainda',
                          style: TextStyle(
                              color: scheme.onSurfaceVariant, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Toque em + para adicionar',
                          style: TextStyle(
                              color: scheme.outlineVariant, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    key: const ValueKey('list'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    itemCount: _tarefas.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final t = _tarefas[i];
                      final ehDono = t.dono.id == widget.usuario.id;
                      return _TarefaCard(
                        tarefa: t,
                        ehDono: ehDono,
                        index: i,
                        statusLabel: _statusLabel(t.status),
                        statusIcon: _statusIcon(t.status),
                        statusBg: _statusBg(t.status),
                        statusFg: _statusFg(t.status),
                        onTap: () => _atualizarStatus(t),
                        onLongPress: ehDono ? () => _compartilhar(t) : null,
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _novaTarefa,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Nova tarefa'),
      ),
    );
  }
}

class _TarefaCard extends StatefulWidget {
  final Tarefa tarefa;
  final bool ehDono;
  final int index;
  final String statusLabel;
  final IconData statusIcon;
  final Color statusBg;
  final Color statusFg;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _TarefaCard({
    required this.tarefa,
    required this.ehDono,
    required this.index,
    required this.statusLabel,
    required this.statusIcon,
    required this.statusBg,
    required this.statusFg,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<_TarefaCard> createState() => _TarefaCardState();
}

class _TarefaCardState extends State<_TarefaCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250 + widget.index * 55),
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = widget.tarefa;
    final showMeta = !widget.ehDono || t.amigos.isNotEmpty;

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          t.titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _StatusBadge(
                        label: widget.statusLabel,
                        icon: widget.statusIcon,
                        bg: widget.statusBg,
                        fg: widget.statusFg,
                      ),
                    ],
                  ),
                  if (t.descricao.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      t.descricao,
                      style: TextStyle(
                          fontSize: 13, color: scheme.onSurfaceVariant),
                    ),
                  ],
                  if (showMeta) ...[
                    const SizedBox(height: 12),
                    Divider(height: 1, color: scheme.outlineVariant.withAlpha(80)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        if (!widget.ehDono)
                          _MetaRow(
                            icon: Icons.person_outline_rounded,
                            label: t.dono.nome,
                            scheme: scheme,
                          ),
                        if (t.amigos.isNotEmpty)
                          _MetaRow(
                            icon: Icons.group_outlined,
                            label: t.amigos.map((a) => a.nome).join(', '),
                            scheme: scheme,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;

  const _StatusBadge({
    required this.label,
    required this.icon,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: fg),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme scheme;

  const _MetaRow({
    required this.icon,
    required this.label,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: scheme.outlineVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
