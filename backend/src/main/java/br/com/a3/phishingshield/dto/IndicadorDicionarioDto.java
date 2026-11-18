package br.com.a3.phishingshield.dto;

import java.util.ArrayList;
import java.util.List;

/** Visao de um indicador do dicionario com seus termos ativos. */
public class IndicadorDicionarioDto {

    private String codigo;
    private String nome;
    private String tipo;
    private Integer pesoPorOcorrencia;
    private Integer pontuacaoMaxima;
    private int totalTermos;
    private List<String> termos = new ArrayList<>();

    public IndicadorDicionarioDto() {
    }

    public IndicadorDicionarioDto(String codigo, String nome, String tipo, Integer pesoPorOcorrencia,
                                  Integer pontuacaoMaxima, List<String> termos) {
        this.codigo = codigo;
        this.nome = nome;
        this.tipo = tipo;
        this.pesoPorOcorrencia = pesoPorOcorrencia;
        this.pontuacaoMaxima = pontuacaoMaxima;
        this.termos = new ArrayList<>(termos);
        this.totalTermos = termos.size();
    }

    public String getCodigo() { return codigo; }
    public String getNome() { return nome; }
    public String getTipo() { return tipo; }
    public Integer getPesoPorOcorrencia() { return pesoPorOcorrencia; }
    public Integer getPontuacaoMaxima() { return pontuacaoMaxima; }
    public int getTotalTermos() { return totalTermos; }
    public List<String> getTermos() { return termos; }
}
