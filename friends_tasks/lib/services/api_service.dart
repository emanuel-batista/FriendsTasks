import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tarefa.dart';
import '../models/usuario.dart';

class ApiService {
  static const _base = 'http://localhost:8080/api';

  static Future<List<Usuario>> listarUsuarios() async {
    final res = await http.get(Uri.parse('$_base/usuarios'));
    return (jsonDecode(res.body) as List)
        .map((e) => Usuario.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Usuario> criarUsuario(String nome, String email) async {
    final res = await http.post(
      Uri.parse('$_base/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'email': email}),
    );
    return Usuario.fromJson(jsonDecode(res.body));
  }

  static Future<List<Tarefa>> listarTarefas(int usuarioId) async {
    final res = await http.get(Uri.parse('$_base/tarefas/usuario/$usuarioId'));
    return (jsonDecode(res.body) as List)
        .map((e) => Tarefa.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Tarefa> criarTarefa(
      String titulo, String descricao, int donoId) async {
    final res = await http.post(
      Uri.parse('$_base/tarefas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'titulo': titulo,
        'descricao': descricao,
        'dono': {'id': donoId},
      }),
    );
    return Tarefa.fromJson(jsonDecode(res.body));
  }

  static Future<Tarefa> compartilharTarefa(int tarefaId, int amigoId) async {
    final res = await http.post(
        Uri.parse('$_base/tarefas/$tarefaId/compartilhar/$amigoId'));
    return Tarefa.fromJson(jsonDecode(res.body));
  }

  static Future<Tarefa> atualizarStatus(int tarefaId, String status) async {
    final res = await http.patch(
        Uri.parse('$_base/tarefas/$tarefaId/status?status=$status'));
    return Tarefa.fromJson(jsonDecode(res.body));
  }
}
