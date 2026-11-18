package br.com.a3.phishingshield.dto;

import java.util.ArrayList;
import java.util.List;

public class AnaliseResponse {

    private int pontuacao;          // 0 a 100
    private String nivelRisco;      // BAIXO, MEDIO, ALTO
    private String recomendacao;
    private List<String> alertas = new ArrayList<>();

    public int getPontuacao() {
        return pontuacao;
    }

    public void setPontuacao(int pontuacao) {
        this.pontuacao = pontuacao;
    }

    public String getNivelRisco() {
        return nivelRisco;
    }

    public void setNivelRisco(String nivelRisco) {
        this.nivelRisco = nivelRisco;
    }

    public String getRecomendacao() {
        return recomendacao;
    }

    public void setRecomendacao(String recomendacao) {
        this.recomendacao = recomendacao;
    }

    public List<String> getAlertas() {
        return alertas;
    }

    public void setAlertas(List<String> alertas) {
        this.alertas = alertas;
    }

    public void addAlerta(String alerta) {
        this.alertas.add(alerta);
    }
}
