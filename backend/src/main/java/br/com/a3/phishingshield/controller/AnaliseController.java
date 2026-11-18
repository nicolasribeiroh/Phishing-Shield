package br.com.a3.phishingshield.controller;

import br.com.a3.phishingshield.dto.AnaliseResponse;
import br.com.a3.phishingshield.dto.EmailRequest;
import br.com.a3.phishingshield.service.AnalisadorService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/analise")
@CrossOrigin(origins = "*")
public class AnaliseController {

    private final AnalisadorService service;

    public AnaliseController(AnalisadorService service) {
        this.service = service;
    }

    @GetMapping("/health")
    public Map<String, String> health() {
        Map<String, String> status = new HashMap<>();
        status.put("status", "UP");
        status.put("servico", "Phishing Shield A3");
        return status;
    }

    @PostMapping
    public ResponseEntity<AnaliseResponse> analisar(@RequestBody EmailRequest request) {
        AnaliseResponse resposta = service.analisar(request);
        return ResponseEntity.ok(resposta);
    }
}
