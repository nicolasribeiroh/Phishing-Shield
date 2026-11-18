package br.com.a3.phishingshield.service;

import br.com.a3.phishingshield.dto.AnaliseResponse;
import br.com.a3.phishingshield.dto.EmailRequest;
import br.com.a3.phishingshield.model.Indicador;
import br.com.a3.phishingshield.service.DicionarioPhishingService.Dicionario;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class AnalisadorService {

    // As palavras-chave e listas de referencia ficam no PostgreSQL
    // (tabelas indicador e palavra_chave) e sao carregadas pelo DicionarioPhishingService.
    private final DicionarioPhishingService dicionarioService;

    private static final Pattern PADRAO_URL =
            Pattern.compile("https?://[\\w\\-./?%&=:+#~@]+", Pattern.CASE_INSENSITIVE);

    private static final Pattern PADRAO_IP_URL =
            Pattern.compile("https?://(\\d{1,3}\\.){3}\\d{1,3}", Pattern.CASE_INSENSITIVE);

    public AnalisadorService(DicionarioPhishingService dicionarioService) {
        this.dicionarioService = dicionarioService;
    }

    public AnaliseResponse analisar(EmailRequest req) {

        AnaliseResponse resp = new AnaliseResponse();

        // Mesma versao do dicionario do inicio ao fim desta analise
        Dicionario dicionario = dicionarioService.atual();
        List<String> marcas = dicionario.termos(DicionarioPhishingService.MARCA_CONHECIDA);
        List<String> dominiosGratuitos = dicionario.termos(DicionarioPhishingService.DOMINIO_GRATUITO);
        List<String> encurtadores = dicionario.termos(DicionarioPhishingService.ENCURTADOR_URL);
        List<String> tldsSuspeitos = dicionario.termos(DicionarioPhishingService.TLD_SUSPEITO);

        String remetente = normalizar(req.getRemetente());
        String assunto = normalizar(req.getAssunto());
        String corpo = normalizar(req.getCorpo());
        String textoCompleto = assunto + " " + corpo;

        int pontos = 0;

        // ---------- 1) ANALISE DO REMETENTE ----------
        String dominio = extrairDominio(remetente);

        if (dominio.isEmpty()) {
            pontos += 10;
            resp.addAlerta("Não foi possível identificar o domínio do remetente.");
        } else {
            if (dominiosGratuitos.contains(dominio)) {
                boolean citaMarca = marcas.stream().anyMatch(textoCompleto::contains);
                if (citaMarca) {
                    pontos += 30;
                    resp.addAlerta("E-mail cita uma empresa conhecida, mas foi enviado de um domínio gratuito ("
                            + dominio + "). Empresas usam domínio próprio.");
                } else {
                    pontos += 8;
                    resp.addAlerta("Remetente usa domínio gratuito (" + dominio + ").");
                }
            }

            for (String tld : tldsSuspeitos) {
                if (dominio.endsWith(tld)) {
                    pontos += 20;
                    resp.addAlerta("Domínio do remetente usa extensão suspeita (" + tld + ").");
                    break;
                }
            }

            if (dominio.contains("-") && marcas.stream().anyMatch(dominio::contains)) {
                pontos += 20;
                resp.addAlerta("Domínio imita marca conhecida com hífen (" + dominio + "), técnica comum de falsificação.");
            }

            if (contaCaracter(dominio, '.') >= 3) {
                pontos += 12;
                resp.addAlerta("Domínio com muitos subdomínios (" + dominio + "), típico de sites falsos.");
            }

            if (dominio.matches(".*\\d{2,}.*")) {
                pontos += 10;
                resp.addAlerta("Domínio do remetente contém sequência de números incomum.");
            }
        }

        // ---------- 2) PALAVRAS-CHAVE DO DICIONARIO ----------
        // Urgencia, dados sensiveis, iscas financeiras, saudacao generica e
        // qualquer novo indicador do tipo TEXTO cadastrado no banco.
        for (Indicador indicador : dicionario.indicadoresDeTexto()) {
            pontos += contarOcorrencias(textoCompleto, dicionario.termos(indicador.getCodigo()), resp,
                    indicador.getMensagemAlerta(), valor(indicador.getPesoPorOcorrencia()),
                    valor(indicador.getPontuacaoMaxima()));
        }

        // ---------- 3) ANALISE DOS LINKS ----------
        Matcher m = PADRAO_URL.matcher(corpo);
        int totalLinks = 0;
        boolean achouEncurtador = false;
        boolean achouTldRuim = false;

        while (m.find()) {
            totalLinks++;
            String url = m.group().toLowerCase();

            if (!achouEncurtador) {
                for (String enc : encurtadores) {
                    if (url.contains(enc)) {
                        pontos += 18;
                        resp.addAlerta("Link encurtado encontrado (" + enc + ") — esconde o destino real.");
                        achouEncurtador = true;
                        break;
                    }
                }
            }

            if (!achouTldRuim) {
                for (String tld : tldsSuspeitos) {
                    if (url.contains(tld + "/") || url.endsWith(tld)) {
                        pontos += 18;
                        resp.addAlerta("Link aponta para domínio de extensão suspeita (" + tld + ").");
                        achouTldRuim = true;
                        break;
                    }
                }
            }
        }

        if (PADRAO_IP_URL.matcher(corpo).find()) {
            pontos += 25;
            resp.addAlerta("Link usa endereço IP em vez de nome de domínio — altamente suspeito.");
        }

        if (totalLinks > 5) {
            pontos += 8;
            resp.addAlerta("E-mail contém muitos links (" + totalLinks + ").");
        }

        if (corpo.contains("http://")) {
            pontos += 10;
            resp.addAlerta("Link sem criptografia (http://) encontrado.");
        }

        // ---------- 4) ANEXOS PERIGOSOS CITADOS ----------
        if (corpo.matches("(?s).*\\.(exe|scr|bat|cmd|js|vbs|jar|zip|rar)\\b.*")) {
            pontos += 15;
            resp.addAlerta("Menção a arquivo executável ou compactado — risco de malware.");
        }

        // ---------- 5) QUALIDADE DO TEXTO ----------
        if (contarMaiusculasExcessivas(assunto)) {
            pontos += 8;
            resp.addAlerta("Assunto escrito com excesso de letras MAIÚSCULAS.");
        }

        if (assunto.contains("!!!") || corpo.contains("!!!")) {
            pontos += 5;
            resp.addAlerta("Uso exagerado de pontos de exclamação.");
        }

        // ---------- FECHAMENTO ----------
        if (pontos > 100) {
            pontos = 100;
        }

        resp.setPontuacao(pontos);

        if (pontos >= 60) {
            resp.setNivelRisco("ALTO");
            resp.setRecomendacao("NÃO clique em links nem responda. Denuncie como phishing e exclua o e-mail.");
        } else if (pontos >= 30) {
            resp.setNivelRisco("MEDIO");
            resp.setRecomendacao("Desconfie. Confirme pelo canal oficial da empresa antes de clicar em qualquer link.");
        } else {
            resp.setNivelRisco("BAIXO");
            resp.setRecomendacao("Nenhum indício forte de phishing, mas mantenha sempre a atenção.");
        }

        if (resp.getAlertas().isEmpty()) {
            resp.addAlerta("Nenhum indicador de phishing identificado.");
        }

        return resp;
    }

    // ================= METODOS AUXILIARES =================

    private String normalizar(String texto) {
        return texto == null ? "" : texto.toLowerCase().trim();
    }

    private String extrairDominio(String remetente) {
        int i = remetente.lastIndexOf('@');
        if (i < 0 || i == remetente.length() - 1) {
            return "";
        }
        return remetente.substring(i + 1).replace(">", "").trim();
    }

    private int contaCaracter(String texto, char c) {
        int total = 0;
        for (char atual : texto.toCharArray()) {
            if (atual == c) {
                total++;
            }
        }
        return total;
    }

    private boolean contarMaiusculasExcessivas(String textoOriginal) {
        if (textoOriginal == null || textoOriginal.length() < 10) {
            return false;
        }
        int maiusculas = 0;
        int letras = 0;
        for (char c : textoOriginal.toCharArray()) {
            if (Character.isLetter(c)) {
                letras++;
                if (Character.isUpperCase(c)) {
                    maiusculas++;
                }
            }
        }
        return letras > 0 && ((double) maiusculas / letras) > 0.6;
    }

    private int valor(Integer numero) {
        return numero == null ? 0 : numero;
    }

    private int contarOcorrencias(String texto, List<String> lista, AnaliseResponse resp,
                                  String modeloAlerta, int pesoCada, int tetoMax) {
        int soma = 0;
        for (String termo : lista) {
            if (texto.contains(termo)) {
                if (soma < tetoMax) {
                    resp.addAlerta(montarAlerta(modeloAlerta, termo));
                }
                soma += pesoCada;
            }
        }
        return Math.min(soma, tetoMax);
    }

    private String montarAlerta(String modelo, String termo) {
        if (modelo == null || modelo.trim().isEmpty()) {
            return "Termo suspeito detectado: \"" + termo + "\"";
        }
        return modelo.contains("{termo}") ? modelo.replace("{termo}", termo) : modelo + " \"" + termo + "\"";
    }
}
