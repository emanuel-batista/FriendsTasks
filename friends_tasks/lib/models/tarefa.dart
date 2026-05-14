import 'usuario.dart';

class Tarefa {
  final int id;
  final String titulo;
  final String descricao;
  final String status;
  final Usuario dono;
  final List<Usuario> amigos;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.status,
    required this.dono,
    required this.amigos,
  });

  factory Tarefa.fromJson(Map<String, dynamic> json) => Tarefa(
        id: json['id'],
        titulo: json['titulo'],
        descricao: json['descricao'] ?? '',
        status: json['status'],
        dono: Usuario.fromJson(json['dono']),
        amigos: (json['amigos'] as List<dynamic>? ?? [])
            .map((a) => Usuario.fromJson(a))
            .toList(),
      );
}
