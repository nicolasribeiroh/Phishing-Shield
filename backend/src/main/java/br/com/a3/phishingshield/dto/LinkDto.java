package br.com.a3.phishingshield.dto;

public class LinkDto {
    private String textoVisivel;
    private String urlDestino;

    public LinkDto() {}

    public String getTextoVisivel() { return textoVisivel; }
    public void setTextoVisivel(String textoVisivel) { this.textoVisivel = textoVisivel; }

    public String getUrlDestino() { return urlDestino; }
    public void setUrlDestino(String urlDestino) { this.urlDestino = urlDestino; }
}
