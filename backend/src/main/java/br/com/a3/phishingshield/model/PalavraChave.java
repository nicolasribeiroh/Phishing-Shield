package br.com.a3.phishingshield.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import java.time.LocalDateTime;

/** Termo do dicionario de phishing, sempre vinculado a um indicador. */
@Entity
@Table(name = "palavra_chave")
public class PalavraChave {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "indicador_id", nullable = false)
    private Indicador indicador;

    @Column(nullable = false, length = 150)
    private String termo;

    @Column(nullable = false)
    private Boolean ativo;

    @Column(length = 255)
    private String observacao;

    @Column(name = "data_cadastro", insertable = false, updatable = false)
    private LocalDateTime dataCadastro;

    public PalavraChave() {
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Indicador getIndicador() { return indicador; }
    public void setIndicador(Indicador indicador) { this.indicador = indicador; }

    public String getTermo() { return termo; }
    public void setTermo(String termo) { this.termo = termo; }

    public Boolean getAtivo() { return ativo; }
    public void setAtivo(Boolean ativo) { this.ativo = ativo; }

    public String getObservacao() { return observacao; }
    public void setObservacao(String observacao) { this.observacao = observacao; }

    public LocalDateTime getDataCadastro() { return dataCadastro; }
    public void setDataCadastro(LocalDateTime dataCadastro) { this.dataCadastro = dataCadastro; }
}
