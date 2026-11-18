// PS_API_BASE vem do arquivo config.js
const API_HEALTH = PS_API_BASE + "/api/analise/health";

async function verificarApi() {
  const el = document.getElementById("status-api");
  el.textContent = "verificando... (até 1 min se o servidor estava sem uso)";
  el.className = "";

  const controle = new AbortController();
  const timer = setTimeout(() => controle.abort(), 90000);
  try {
    const r = await fetch(API_HEALTH, { signal: controle.signal });
    if (!r.ok) throw new Error();
    el.textContent = "✓ ONLINE";
    el.className = "on";
  } catch (e) {
    el.textContent = "✗ OFFLINE";
    el.className = "off";
  } finally {
    clearTimeout(timer);
  }
}

document.getElementById("endereco-api").textContent = PS_API_BASE;
document.getElementById("btn-testar").addEventListener("click", verificarApi);
verificarApi();
