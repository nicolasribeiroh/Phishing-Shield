// PS_API_BASE vem do arquivo config.js
const API_URL = PS_API_BASE + "/api/analise";
const TEMPO_LIMITE_MS = 90000; // o servidor gratuito pode levar ~1 min para acordar
const BANNER_ID = "phishing-shield-banner";

let ultimoAssuntoAnalisado = "";
let requisicaoAtual = 0;

function extrairEmailAberto() {
  const elAssunto = document.querySelector("h2.hP");
  if (!elAssunto) return null;

  const elRemetente = document.querySelector("span.gD");
  const elCorpo = document.querySelector("div.a3s");

  let remetente = "";
  if (elRemetente) {
    remetente = elRemetente.getAttribute("email") || elRemetente.innerText || "";
  }

  return {
    assunto: elAssunto.innerText || "",
    remetente: remetente,
    corpo: elCorpo ? elCorpo.innerText : ""
  };
}

function removerBanner() {
  const antigo = document.getElementById(BANNER_ID);
  if (antigo) antigo.remove();
}

function mostrarBanner(resultado) {
  removerBanner();

  const alvo = document.querySelector("h2.hP");
  if (!alvo) return;

  const nivel = resultado.nivelRisco;
  const classe =
    nivel === "ALTO" ? "ps-alto" : nivel === "MEDIO" ? "ps-medio" : "ps-baixo";
  const icone = nivel === "ALTO" ? "🚨" : nivel === "MEDIO" ? "⚠️" : "✅";
  const titulo =
    nivel === "ALTO"
      ? "RISCO ALTO DE PHISHING"
      : nivel === "MEDIO"
      ? "RISCO MODERADO — DESCONFIE"
      : "RISCO BAIXO";

  const itens = resultado.alertas
    .map((a) => `<li>${escaparHtml(a)}</li>`)
    .join("");

  const banner = document.createElement("div");
  banner.id = BANNER_ID;
  banner.className = `ps-banner ${classe}`;
  banner.innerHTML = `
    <div class="ps-header">
      <span class="ps-titulo">${icone} ${titulo}</span>
      <span class="ps-score">Pontuação: ${resultado.pontuacao}/100</span>
    </div>
    <div class="ps-reco">${escaparHtml(resultado.recomendacao)}</div>
    <details class="ps-detalhes">
      <summary>Ver indicadores encontrados (${resultado.alertas.length})</summary>
      <ul>${itens}</ul>
    </details>
    <div class="ps-rodape">Analisado por Phishing Shield A3 — API Java / Spring Boot</div>
  `;

  alvo.parentNode.insertBefore(banner, alvo);
}

function mostrarAviso(titulo, msg, comBotao) {
  removerBanner();
  const alvo = document.querySelector("h2.hP");
  if (!alvo) return;

  const banner = document.createElement("div");
  banner.id = BANNER_ID;
  banner.className = "ps-banner ps-offline";
  banner.innerHTML = `<div class="ps-header"><span class="ps-titulo">${escaparHtml(titulo)}</span></div>
    <div class="ps-reco">${escaparHtml(msg)}</div>
    ${comBotao ? '<button type="button" class="ps-botao">Tentar novamente</button>' : ""}`;
  alvo.parentNode.insertBefore(banner, alvo);

  if (comBotao) {
    banner.querySelector(".ps-botao").addEventListener("click", () => {
      ultimoAssuntoAnalisado = "";
      analisar();
    });
  }
}

function mostrarCarregando() {
  mostrarAviso("🔎 Analisando o e-mail...",
    "Se o servidor estava sem uso, a primeira análise pode levar até 1 minuto.", false);
}

function mostrarErro(msg) {
  mostrarAviso("🔌 Phishing Shield offline", msg, true);
}

function escaparHtml(txt) {
  const div = document.createElement("div");
  div.textContent = txt == null ? "" : txt;
  return div.innerHTML;
}

async function analisar() {
  const email = extrairEmailAberto();
  if (!email) {
    ultimoAssuntoAnalisado = "";
    removerBanner();
    return;
  }

  const chave = email.assunto + "|" + email.remetente;
  if (chave === ultimoAssuntoAnalisado) return;
  ultimoAssuntoAnalisado = chave;

  const minhaRequisicao = ++requisicaoAtual;
  mostrarCarregando();

  const controle = new AbortController();
  const timer = setTimeout(() => controle.abort(), TEMPO_LIMITE_MS);

  try {
    const resp = await fetch(API_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(email),
      signal: controle.signal
    });

    if (!resp.ok) throw new Error("HTTP " + resp.status);

    const resultado = await resp.json();
    // Ignora respostas atrasadas se o usuario ja abriu outro e-mail
    if (minhaRequisicao !== requisicaoAtual) return;
    mostrarBanner(resultado);
  } catch (e) {
    if (minhaRequisicao !== requisicaoAtual) return;
    mostrarErro(
      "Não foi possível conectar à API em " + PS_API_BASE +
        ". Aguarde alguns segundos e clique em Tentar novamente."
    );
  } finally {
    clearTimeout(timer);
  }
}

// Observa mudanças de tela do Gmail (SPA, não recarrega a página)
const observer = new MutationObserver(() => {
  clearTimeout(window.__psTimer);
  window.__psTimer = setTimeout(analisar, 800);
});

observer.observe(document.body, { childList: true, subtree: true });
setTimeout(analisar, 1500);
