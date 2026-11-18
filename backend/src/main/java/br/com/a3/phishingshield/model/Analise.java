package br.com.a3.phishingshield.model;

// FASE 2 - historico no PostgreSQL.
// Descomente as dependencias de JPA no pom.xml e as anotacoes abaixo.

// import jakarta.persistence.*;
import java.time.LocalDateTime;

// @Entity
// @Table(name = "analise")
public class Analise {

    // @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String remetente;
    private String assunto;
    private String classificacao;
    private Integer score;

    // @Column(length = 1000)
    private String motivos;

    private LocalDateTime dataAnalise = LocalDateTime.now();

    public Analise() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getRemetente() { return remetente; }
    public void setRemetente(String remetente) { this.remetente = remetente; }

    public String getAssunto() { return assunto; }
    public void setAssunto(String assunto) { this.assunto = assunto; }

    public String getClassificacao() { return classificacao; }
    public void setClassificacao(String classificacao) { this.classificacao = classificacao; }

    public Integer getScore() { return score; }
    public void setScore(Integer score) { this.score = score; }

    public String getMotivos() { return motivos; }
    public void setMotivos(String motivos) { this.motivos = motivos; }

    public LocalDateTime getDataAnalise() { return dataAnalise; }
    public void setDataAnalise(LocalDateTime dataAnalise) { this.dataAnalise = dataAnalise; }
}
