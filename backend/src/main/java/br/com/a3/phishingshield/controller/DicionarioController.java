package br.com.a3.phishingshield.controller;

import br.com.a3.phishingshield.dto.IndicadorDicionarioDto;
import br.com.a3.phishingshield.model.Indicador;
import br.com.a3.phishingshield.service.DicionarioPhishingService;
import br.com.a3.phishingshield.service.DicionarioPhishingService.Dicionario;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Consulta do dicionario carregado pela API.
 * Os termos sao cadastrados/alterados diretamente no PostgreSQL.
 */
@RestController
@RequestMapping("/api/dicionario")
public class DicionarioController {

    private final DicionarioPhishingService dicionarioService;

    public DicionarioController(DicionarioPhishingService dicionarioService) {
        this.dicionarioService = dicionarioService;
    }

    /** GET /api/dicionario - lista os indicadores e termos em uso. */
    @GetMapping
    public List<IndicadorDicionarioDto> listar() {
        return converter(dicionarioService.atual());
    }

    /** POST /api/dicionario/recarregar - aplica alteracoes feitas no banco sem reiniciar a API. */
    @PostMapping("/recarregar")
    public Map<String, Object> recarregar() {
        Dicionario dicionario = dicionarioService.recarregar();
        Map<String, Object> resposta = new LinkedHashMap<>();
        resposta.put("mensagem", "Dicionario recarregado do banco de dados.");
        resposta.put("indicadores", dicionario.getIndicadores().size());
        resposta.put("termosAtivos", dicionario.getTotalTermos());
        return resposta;
    }

    private List<IndicadorDicionarioDto> converter(Dicionario dicionario) {
        List<IndicadorDicionarioDto> lista = new ArrayList<>();
        for (Indicador indicador : dicionario.getIndicadores()) {
            lista.add(new IndicadorDicionarioDto(
                    indicador.getCodigo(),
                    indicador.getNome(),
                    indicador.getTipo(),
                    indicador.getPesoPorOcorrencia(),
                    indicador.getPontuacaoMaxima(),
                    dicionario.termos(indicador.getCodigo())));
        }
        return lista;
    }
}
