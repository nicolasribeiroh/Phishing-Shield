package br.com.a3.phishingshield.dto;

import java.util.ArrayList;
import java.util.List;

public class ResultadoAnaliseDto {

    private String classificacao;   // SEGURO | SUSPEITO | ALTO_RISCO | INCONCLUSIVO
    private int score;              // 0 a 100
    private List<String> motivos = new ArrayList<>();

    public ResultadoAnaliseDto() {}

    public ResultadoAnaliseDto(String classificacao, int score, List<String> motivos) {
        this.classificacao = classificacao;
        this.score = score;
        this.motivos = motivos;
    }

    public String getClassificacao() { return classificacao; }
    public void setClassificacao(String classificacao) { this.classificacao = classificacao; }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    public List<String> getMotivos() { return motivos; }
    public void setMotivos(List<String> motivos) { this.motivos = motivos; }
}
