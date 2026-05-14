package br.edu.escolaconectada.controller;

import br.edu.escolaconectada.model.Usuario;
import br.edu.escolaconectada.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/usuarios")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    // Atende a exigência: Cadastrar usuários
    @PostMapping
    public ResponseEntity<Usuario> cadastrar(@RequestBody Usuario usuario) {
        return ResponseEntity.ok(usuarioService.cadastrarUsuario(usuario));
    }

    // Atende a exigência: Consultar informações (de usuários)
    @GetMapping
    public ResponseEntity<List<Usuario>> listar() {
        return ResponseEntity.ok(usuarioService.listarUsuarios());
    }

}
