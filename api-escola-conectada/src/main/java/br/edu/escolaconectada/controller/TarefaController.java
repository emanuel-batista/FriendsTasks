package br.edu.escolaconectada.controller;

import br.edu.escolaconectada.model.Tarefa;
import br.edu.escolaconectada.service.TarefaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tarefas")
public class TarefaController {

    @Autowired
    private TarefaService tarefaService;

    // 1. Cadastrar Tarefa
    @PostMapping
    public ResponseEntity<Tarefa> cadastrarTarefa(@RequestBody Tarefa tarefa) {
        return ResponseEntity.ok(tarefaService.criarTarefa(tarefa));
    }

    // 2. Compartilhar tarefa com amigo
    @PostMapping("/{tarefaId}/compartilhar/{amigoId}")
    public ResponseEntity<Tarefa> compartilhar(@PathVariable Long tarefaId, @PathVariable Long amigoId) {
        return ResponseEntity.ok(tarefaService.compartilharTarefa(tarefaId, amigoId));
    }

    // 3. Atualizar Status
    @PatchMapping("/{tarefaId}/status")
    public ResponseEntity<Tarefa> atualizarStatus(@PathVariable Long tarefaId, @RequestParam String status) {
        return ResponseEntity.ok(tarefaService.atualizarStatus(tarefaId, status));
    }

    // 4. Consultar informações (Tarefas de um usuário específico)
    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<Tarefa>> listarTarefas(@PathVariable Long usuarioId) {
        return ResponseEntity.ok(tarefaService.consultarTarefasDoUsuario(usuarioId));
    }

}
