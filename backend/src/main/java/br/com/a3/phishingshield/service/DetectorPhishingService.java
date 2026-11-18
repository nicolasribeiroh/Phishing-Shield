package br.com.a3.phishingshield.service;

import br.com.a3.phishingshield.dto.EmailPayloadDto;
import br.com.a3.phishingshield.dto.LinkDto;
import br.com.a3.phishingshield.dto.ResultadoAnaliseDto;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

/**
 * Motor de deteccao de phishing baseado em heuristicas e pontuacao (0 a 100).
 * Cada regra violada soma pontos de risco e gera um motivo legivel ao usuario.
 */
@Service
public class DetectorPhishingService {

    // Marcas frequentemente imitadas em golpes no Brasil
    private static final List<String> MARCAS = Arrays.asList(
        "banco do brasil", "bradesco", "itau", "santander", "caixa", "nubank",
        "inter", "c6", "sicredi", "banrisul", "safra", "pagbank", "picpay",
        "mercado pago", "receita federal", "serasa", "correios", "gov.br",
        "netflix", "magalu", "americanas", "shopee", "mercado livre"
    );

    // Provedores gratuitos: instituicao seria nao usa isso como remetente oficial
    private static final List<String> PROVEDORES_GRATUITOS = Arrays.asList(
        "gmail.com", "hotmail.com", "outlook.com", "yahoo.com", "yahoo.com.br",
        "live.com", "bol.com.br", "uol.com.br", "icloud.com", "proton.me"
    );

    // Encurtadores de URL escondem o destino real
    private static final List<String> ENCURTADORES = Arrays.asList(
        "bit.ly", "tinyurl.com", "goo.gl", "t.co", "is.gd", "cutt.ly",
        "rebrand.ly", "shorturl.at", "encurtador.com.br", "rb.gy", "ow.ly"
    );

    // TLDs muito usados em campanhas maliciosas
    private static final List<String> TLDS_SUSPEITOS = Arrays.asList(
        ".tk", ".ml", ".ga", ".cf", ".gq", ".top", ".xyz", ".click",
        ".zip", ".mov", ".work", ".rest", ".country"
    );

    // Gatilhos de urgencia / engenharia social
    private static final List<String> TERMOS_URGENCIA = Arrays.asList(
        "urgente", "imediato", "ultimo aviso", "ultima chance", "sua conta sera",
        "conta bloqueada", "conta suspensa", "bloqueio", "regularize",
        "atualize seus dados", "recadastramento", "confirme seus dados",
        "clique aqui agora", "expira hoje", "em 24 horas", "pendencia",
        "divida", "cpf irregular", "premio", "sorteado", "resgate seu",
        "pix bloqueado", "comprovante de pagamento", "nota fiscal", "boleto atrasado"
    );

    // Pedidos de credencial - sinal forte de phishing
    private static final List<String> TERMOS_CREDENCIAL = Arrays.asList(
        "senha", "codigo de seguranca", "token", "cvv", "numero do cartao",
        "assinatura eletronica", "chave de seguranca", "senha de 4 digitos"
    );

    public ResultadoAnaliseDto avaliar(EmailPayloadDto email) {
        List<String> motivos = new ArrayList<>();
        int score = 0;

        if (email == null || (vazio(email.getSenderEmail()) && vazio(email.getBodyText()))) {
            return new ResultadoAnaliseDto("INCONCLUSIVO", 0,
                List.of("Dados insuficientes para analisar este e-mail."));
        }

        String remetente = minusculo(email.getSenderEmail());
        String nomeExibido = minusculo(email.getSenderName());
        String assunto = minusculo(email.getSubject());
        String corpo = minusculo(email.getBodyText());
        String texto = assunto + " " + corpo;
        String dominioRemetente = extrairDominioEmail(remetente);

        // -----------------------------------------------------------
        // REGRA 1 - Divergencia de identidade (marca x dominio real)
        // -----------------------------------------------------------
        String marcaCitada = null;
        for (String marca : MARCAS) {
            if (nomeExibido.contains(marca) || assunto.contains(marca)) {
                marcaCitada = marca;
                break;
            }
        }
        if (marcaCitada != null && !dominioRemetente.isEmpty()) {
            boolean dominioCombina = dominioRemetente.contains(
                marcaCitada.replace(" ", "").replace(".", ""));

            if (PROVEDORES_GRATUITOS.contains(dominioRemetente)) {
                score += 40;
                motivos.add("O e-mail se apresenta como \"" + marcaCitada
                    + "\", mas foi enviado por um provedor gratuito (" + dominioRemetente + ").");
            } else if (!dominioCombina) {
                score += 30;
                motivos.add("O nome do remetente cita \"" + marcaCitada
                    + "\", porem o dominio real e \"" + dominioRemetente + "\".");
            }
        }

        // -----------------------------------------------------------
        // REGRA 2 - Dominio do remetente com aparencia forjada
        // -----------------------------------------------------------
        if (!dominioRemetente.isEmpty()) {
            if (contarOcorrencias(dominioRemetente, '-') >= 2) {
                score += 20;
                motivos.add("O dominio do remetente possui varios hifens, padrao comum em dominios falsos.");
            }
            if (dominioRemetente.matches(".*\\d{2,}.*")) {
                score += 15;
                motivos.add("O dominio do remetente contem sequencias numericas incomuns.");
            }
            for (String tld : TLDS_SUSPEITOS) {
                if (dominioRemetente.endsWith(tld)) {
                    score += 25;
                    motivos.add("O remetente usa a extensao \"" + tld + "\", frequente em campanhas maliciosas.");
                    break;
                }
            }
        }

        // -----------------------------------------------------------
        // REGRA 3 - Analise dos links do corpo do e-mail
        // -----------------------------------------------------------
        boolean achouEncurtador = false;
        boolean achouHttp = false;
        boolean achouIp = false;
        boolean achouSpoofing = false;
        boolean achouTldRuim = false;
        boolean achouPunycode = false;

        if (email.getLinks() != null) {
            for (LinkDto link : email.getLinks()) {
                String url = minusculo(link.getUrlDestino());
                if (url.isEmpty()) continue;

                String host = extrairHost(url);
                String textoLink = minusculo(link.getTextoVisivel());

                if (!achouHttp && url.startsWith("http://")) {
                    achouHttp = true;
                    score += 20;
                    motivos.add("Existe link sem criptografia HTTPS no corpo da mensagem.");
                }
                if (!achouEncurtador && ENCURTADORES.stream().anyMatch(host::contains)) {
                    achouEncurtador = true;
                    score += 30;
                    motivos.add("O e-mail usa encurtador de URL, ocultando o endereco real do destino.");
                }
                if (!achouIp && host.matches("^\\d{1,3}(\\.\\d{1,3}){3}$")) {
                    achouIp = true;
                    score += 35;
                    motivos.add("Um dos links aponta para um endereco IP em vez de um dominio.");
                }
                if (!achouPunycode && host.contains("xn--")) {
                    achouPunycode = true;
                    score += 30;
                    motivos.add("Link com caracteres internacionais disfarcados (tecnica de dominio sosia).");
                }
                if (!achouTldRuim) {
                    for (String tld : TLDS_SUSPEITOS) {
                        if (host.endsWith(tld)) {
                            achouTldRuim = true;
                            score += 25;
                            motivos.add("Link hospedado em extensao suspeita (" + tld + ").");
                            break;
                        }
                    }
                }
                // Spoofing: o texto mostra um endereco, mas o destino e outro
                if (!achouSpoofing && (textoLink.contains("www.") || textoLink.contains("http")
                        || textoLink.contains(".com") || textoLink.contains(".br"))) {
                    String hostVisivel = extrairHost(
                        textoLink.startsWith("http") ? textoLink : "http://" + textoLink);
                    if (!hostVisivel.isEmpty() && !host.isEmpty()
                            && !dominioBase(host).equals(dominioBase(hostVisivel))) {
                        achouSpoofing = true;
                        score += 40;
                        motivos.add("O texto do link exibe \"" + hostVisivel
                            + "\", mas o destino real e \"" + host + "\".");
                    }
                }
                // Dominio do link diverge da marca citada
                if (marcaCitada != null && !host.isEmpty()
                        && !host.contains(marcaCitada.replace(" ", "").replace(".", ""))
                        && (host.contains("login") || host.contains("seguranca")
                            || host.contains("acesso") || host.contains("atualiza")
                            || host.contains("verificacao"))) {
                    score += 20;
                    motivos.add("Link com palavras de autenticacao em dominio nao oficial: " + host);
                }
            }
        }

        // -----------------------------------------------------------
        // REGRA 4 - Engenharia social no texto
        // -----------------------------------------------------------
        List<String> urgenciaEncontrada = new ArrayList<>();
        for (String termo : TERMOS_URGENCIA) {
            if (texto.contains(termo)) urgenciaEncontrada.add(termo);
        }
        if (!urgenciaEncontrada.isEmpty()) {
            int pontos = Math.min(30, urgenciaEncontrada.size() * 10);
            score += pontos;
            motivos.add("Mensagem usa gatilhos de urgencia: "
                + String.join(", ", urgenciaEncontrada.subList(0, Math.min(3, urgenciaEncontrada.size()))) + ".");
        }

        // -----------------------------------------------------------
        // REGRA 5 - Solicitacao de dados sensiveis
        // -----------------------------------------------------------
        for (String termo : TERMOS_CREDENCIAL) {
            if (texto.contains(termo)) {
                score += 25;
                motivos.add("O e-mail menciona dados sensiveis (\"" + termo
                    + "\"). Instituicoes serias nunca pedem isso por e-mail.");
                break;
            }
        }

        // -----------------------------------------------------------
        // REGRA 6 - Saudacao genérica (sem personalizacao)
        // -----------------------------------------------------------
        if (corpo.contains("prezado cliente") || corpo.contains("caro usuario")
                || corpo.contains("prezado(a) cliente") || corpo.contains("estimado cliente")) {
            score += 10;
            motivos.add("Saudacao genérica, sem o seu nome - tipico de disparo em massa.");
        }

        // -----------------------------------------------------------
        // CLASSIFICACAO FINAL
        // -----------------------------------------------------------
        if (score > 100) score = 100;

        String classificacao;
        if (score >= 61)      classificacao = "ALTO_RISCO";
        else if (score >= 26) classificacao = "SUSPEITO";
        else                  classificacao = "SEGURO";

        if (motivos.isEmpty()) {
            motivos.add("Nenhum indicio relevante de phishing foi identificado nesta mensagem.");
        }

        return new ResultadoAnaliseDto(classificacao, score, motivos);
    }

    // ------------------------- utilitarios -------------------------

    private boolean vazio(String s) { return s == null || s.trim().isEmpty(); }

    private String minusculo(String s) {
        return s == null ? "" : s.toLowerCase(Locale.ROOT).trim();
    }

    private String extrairDominioEmail(String email) {
        int i = email.indexOf('@');
        return (i >= 0 && i < email.length() - 1) ? email.substring(i + 1) : "";
    }

    private String extrairHost(String url) {
        try {
            String host = URI.create(url).getHost();
            if (host == null) return "";
            return host.startsWith("www.") ? host.substring(4) : host;
        } catch (Exception e) {
            return "";
        }
    }

    /** Retorna os dois ultimos rotulos do host (ex: login.banco.com -> banco.com). */
    private String dominioBase(String host) {
        String[] partes = host.split("\\.");
        if (partes.length <= 2) return host;
        return partes[partes.length - 2] + "." + partes[partes.length - 1];
    }

    private int contarOcorrencias(String texto, char c) {
        int n = 0;
        for (char ch : texto.toCharArray()) if (ch == c) n++;
        return n;
    }
}
