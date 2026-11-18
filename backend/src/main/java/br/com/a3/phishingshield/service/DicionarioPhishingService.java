package br.com.a3.phishingshield.service;

import br.com.a3.phishingshield.model.Indicador;
import br.com.a3.phishingshield.model.PalavraChave;
import br.com.a3.phishingshield.repository.IndicadorRepository;
import br.com.a3.phishingshield.repository.PalavraChaveRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Carrega o dicionario de phishing do PostgreSQL e o mantem em memoria.
 * Assim, cada e-mail analisado nao precisa consultar o banco.
 * Depois de alterar o banco, chame POST /api/dicionario/recarregar.
 */
@Service
public class DicionarioPhishingService {

    public static final String URGENCIA = "URGENCIA";
    public static final String DADO_SENSIVEL = "DADO_SENSIVEL";
    public static final String ISCA_FINANCEIRA = "ISCA_FINANCEIRA";
    public static final String SAUDACAO_GENERICA = "SAUDACAO_GENERICA";
    public static final String MARCA_CONHECIDA = "MARCA_CONHECIDA";
    public static final String DOMINIO_GRATUITO = "DOMINIO_GRATUITO";
    public static final String ENCURTADOR_URL = "ENCURTADOR_URL";
    public static final String TLD_SUSPEITO = "TLD_SUSPEITO";

    private static final Logger log = LoggerFactory.getLogger(DicionarioPhishingService.class);

    private final IndicadorRepository indicadorRepository;
    private final PalavraChaveRepository palavraChaveRepository;

    private volatile Dicionario atual =
            new Dicionario(Collections.<Indicador>emptyList(), Collections.<String, List<String>>emptyMap());

    public DicionarioPhishingService(IndicadorRepository indicadorRepository,
                                     PalavraChaveRepository palavraChaveRepository) {
        this.indicadorRepository = indicadorRepository;
        this.palavraChaveRepository = palavraChaveRepository;
    }

    @PostConstruct
    public void inicializar() {
        recarregar();
    }

    /** Le novamente indicadores e termos ativos do banco. */
    public synchronized Dicionario recarregar() {
        List<Indicador> indicadores = indicadorRepository.findByAtivoTrueOrderByOrdemAscIdAsc();

        Map<String, List<String>> termosPorIndicador = new LinkedHashMap<>();
        for (Indicador indicador : indicadores) {
            termosPorIndicador.put(indicador.getCodigo(), new ArrayList<String>());
        }

        for (PalavraChave palavra : palavraChaveRepository.buscarTermosAtivos()) {
            List<String> lista = termosPorIndicador.get(palavra.getIndicador().getCodigo());
            String termo = normalizar(palavra.getTermo());
            if (lista != null && !termo.isEmpty() && !lista.contains(termo)) {
                lista.add(termo);
            }
        }

        Dicionario novo = new Dicionario(indicadores, termosPorIndicador);
        atual = novo;

        if (novo.getTotalTermos() == 0) {
            log.warn("Dicionario de phishing vazio: verifique as tabelas indicador e palavra_chave.");
        } else {
            log.info("Dicionario de phishing carregado: {} indicadores e {} termos ativos.",
                    indicadores.size(), novo.getTotalTermos());
        }
        return novo;
    }

    /** Copia imutavel do dicionario em uso. */
    public Dicionario atual() {
        return atual;
    }

    private static String normalizar(String texto) {
        return texto == null ? "" : texto.toLowerCase(Locale.ROOT).trim();
    }

    /** Fotografia imutavel do dicionario, usada do inicio ao fim de uma analise. */
    public static final class Dicionario {

        private final List<Indicador> indicadores;
        private final Map<String, List<String>> termosPorIndicador;
        private final int totalTermos;

        Dicionario(List<Indicador> indicadores, Map<String, List<String>> termosPorIndicador) {
            this.indicadores = Collections.unmodifiableList(new ArrayList<>(indicadores));

            Map<String, List<String>> copia = new LinkedHashMap<>();
            int total = 0;
            for (Map.Entry<String, List<String>> item : termosPorIndicador.entrySet()) {
                copia.put(item.getKey(), Collections.unmodifiableList(new ArrayList<>(item.getValue())));
                total += item.getValue().size();
            }
            this.termosPorIndicador = Collections.unmodifiableMap(copia);
            this.totalTermos = total;
        }

        public List<String> termos(String codigoIndicador) {
            List<String> termos = termosPorIndicador.get(codigoIndicador);
            return termos == null ? Collections.<String>emptyList() : termos;
        }

        public List<Indicador> indicadoresDeTexto() {
            List<Indicador> resultado = new ArrayList<>();
            for (Indicador indicador : indicadores) {
                if (indicador.isTipoTexto()) {
                    resultado.add(indicador);
                }
            }
            return resultado;
        }

        public List<Indicador> getIndicadores() {
            return indicadores;
        }

        public int getTotalTermos() {
            return totalTermos;
        }
    }
}
