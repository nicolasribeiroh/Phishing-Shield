package br.com.a3.phishingshield.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Categoria do dicionario de phishing (ex.: URGENCIA, DADO_SENSIVEL, MARCA_CONHECIDA).
 *
 * TEXTO      -> termos procurados no assunto e no corpo; a pontuacao vem desta tabela.
 * REFERENCIA -> listas usadas pelas regras de remetente e links (marcas, dominios
 *               gratuitos, encurtadores e TLDs); a pontuacao fica na regra do codigo.
 */
@Entity
@Table(name = "indicador")
public class Indicador {

    public static final String TIPO_TEXTO = "TEXTO";
    public static final String TIPO_REFERENCIA = "REFERENCIA";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 40)
    private String codigo;

    @Column(nullable = false, length = 80)
    private String nome;

    @Column(length = 255)
    private String descricao;

    @Column(nullable = false, length = 20)
    private String tipo;

    /** Modelo do alerta exibido ao usuario. Use {termo} para inserir a palavra encontrada. */
    @Column(name = "mensagem_alerta", length = 255)
    private String mensagemAlerta;

    @Column(name = "peso_por_ocorrencia")
    private Integer pesoPorOcorrencia;

    @Column(name = "pontuacao_maxima")
    private Integer pontuacaoMaxima;

    @Column(nullable = false)
    private Integer ordem;

    @Column(nullable = false)
    private Boolean ativo;

    public Indicador() {
    }

    public boolean isTipoTexto() {
        return TIPO_TEXTO.equalsIgnoreCase(tipo);
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getMensagemAlerta() { return mensagemAlerta; }
    public void setMensagemAlerta(String mensagemAlerta) { this.mensagemAlerta = mensagemAlerta; }

    public Integer getPesoPorOcorrencia() { return pesoPorOcorrencia; }
    public void setPesoPorOcorrencia(Integer pesoPorOcorrencia) { this.pesoPorOcorrencia = pesoPorOcorrencia; }

    public Integer getPontuacaoMaxima() { return pontuacaoMaxima; }
    public void setPontuacaoMaxima(Integer pontuacaoMaxima) { this.pontuacaoMaxima = pontuacaoMaxima; }

    public Integer getOrdem() { return ordem; }
    public void setOrdem(Integer ordem) { this.ordem = ordem; }

    public Boolean getAtivo() { return ativo; }
    public void setAtivo(Boolean ativo) { this.ativo = ativo; }
}
