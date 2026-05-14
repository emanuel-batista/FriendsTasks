package br.edu.escolaconectada.service;

import br.edu.escolaconectada.model.Tarefa;
import br.edu.escolaconectada.model.Usuario;
import br.edu.escolaconectada.repository.TarefaRepository;
import br.edu.escolaconectada.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TarefaService {

    @Autowired
    private TarefaRepository tarefaRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    public Tarefa criarTarefa(Tarefa tarefa) {
        Usuario dono = usuarioRepository.findById(tarefa.getDono().getId())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
        tarefa.setDono(dono);
        tarefa.setStatus("PENDENTE");
        return tarefaRepository.save(tarefa);
    }

    public Tarefa atualizarStatus(Long tarefaId, String novoStatus) {
        Tarefa tarefa = tarefaRepository.findById(tarefaId)
                .orElseThrow(() -> new RuntimeException("Tarefa não encontrada"));
        tarefa.setStatus(novoStatus);
        return tarefaRepository.save(tarefa);
    }

    public Tarefa compartilharTarefa(Long tarefaId, Long amigoId) {
        Tarefa tarefa = tarefaRepository.findById(tarefaId)
                .orElseThrow(() -> new RuntimeException("Tarefa não encontrada"));
        Usuario amigo = usuarioRepository.findById(amigoId)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        tarefa.getAmigos().add(amigo);
        return tarefaRepository.save(tarefa);
    }

    public List<Tarefa> consultarTarefasDoUsuario(Long usuarioId) {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
        // Retorna tarefas que ele é dono ou que foram compartilhadas com ele
        return tarefaRepository.findByDonoOrAmigosContaining(usuario, usuario);
    }
}
