package br.edu.escolaconectada.repository;

import br.edu.escolaconectada.model.Tarefa;
import br.edu.escolaconectada.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TarefaRepository extends JpaRepository<Tarefa,Long> {
    List<Tarefa> findByDonoOrAmigosContaining(Usuario dono, Usuario amigo);
}
