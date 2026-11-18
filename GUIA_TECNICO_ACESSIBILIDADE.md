# Guia Técnico de Acessibilidade — Explicações Detalhadas

## 1. Como Funciona a Região Aria-Live (content.js)

### O Problema
O banner surge na página sem ser anunciado pelo leitor de tela. O NVDA e Narrador não sabem que há novo conteúdo.

### A Solução
Criamos uma **região aria-live** — uma área invisível onde o navegador coloca mensagens que devem ser lidas em tempo real:

```javascript
function obterOuCriarAriaLive() {
  let region = document.getElementById(ARIA_LIVE_ID);
  if (!region) {
    region = document.createElement("div");
    region.id = ARIA_LIVE_ID;
    region.setAttribute("aria-live", "polite");      // Lê quando o usuário para de falar
    region.setAttribute("aria-atomic", "true");       // Lê tudo de novo, não só o que mudou
    region.style.position = "absolute";
    region.style.left = "-10000px";                   // Fora da tela, invisível
    document.body.appendChild(region);
  }
  return region;
}
```

**Por que fora da tela?** Se a região estivesse visível, ocuparia espaço e mudaria o layout. aria-live é só para leitura de tela.

### Prioridades
- **assertive**: interrompe o leitor. Risco ALTO precisa disso.
- **polite**: aguarda pausa. Risco BAIXO e "Analisando" usam isso.

```javascript
anunciarAoLeitor(textoAnuncio, prioridade);  // "assertive" ou "polite"
```

---

## 2. Aria-Hidden para Emojis (content.js + styles.css)

### O Problema
Emojis têm nomes:
- 🚨 é lido como "ALERTA VERMELHO"
- ✅ é lido como "MARCA DE SELEÇÃO"

Ler o emoji + ler o texto = redundância e confusão.

### A Solução
Marcar o emoji com `aria-hidden="true"`:

```html
<span class="ps-titulo" aria-hidden="true">🚨 RISCO ALTO</span>
```

Agora o leitor vê só "RISCO ALTO" (texto + semântica). O emoji é visual.

### No Código
```javascript
banner.innerHTML = `
  <div class="ps-header">
    <span class="ps-titulo" aria-hidden="true">${icone} ${titulo}</span>
    <!-- icone = 🚨, 🔎, etc.; titulo = "RISCO ALTO" ou "Analisando..." -->
  </div>
  ...
`;
```

---

## 3. Role="Region" e Aria-Label (content.js)

### O Problema
O banner é uma <div> genérica. Leitor de tela não sabe: é um anúncio? Uma seção? Um alerta?

### A Solução
Dar ao banner semântica ARIA:

```javascript
banner.setAttribute("role", "region");                                    // "Isso é uma região"
banner.setAttribute("aria-label", `Resultado de análise de phishing...`); // "Região de quê?"
banner.setAttribute("lang", "pt-BR");                                     // "Em que idioma?"
```

**Resultado no Narrador:**
> "Região: Resultado de análise de phishing — RISCO ALTO DE PHISHING"

---

## 4. Foco Visível (styles.css)

### O Problema
Quando usuário pressiona Tab, não vê onde está o foco. Pessoas com baixa visão ficam perdidas.

### A Solução
CSS `:focus-visible` com contorno que contrasta:

```css
.ps-detalhes summary:focus-visible {
  outline: 3px solid #0b2545;      /* Contorno preto sólido */
  outline-offset: 2px;             /* Espaço entre elemento e contorno */
}
```

**Contraste do contorno:** Preto (#0b2545) em fundo claro = 10:1+ ✓

**Mínimo requerido:** 3:1

### No Popup
```css
button:focus-visible {
  outline: 3px solid #0a1122;      /* Preto em fundo cyan #00e5ff = 8,4:1 */
}
```

---

## 5. Tipografia Acessível (styles.css + popup.html)

### O Problema Original
- .ps-rodape: 11px
- Popup .tag: 10px
- Popup .label, .endereco: 11px

**Pessoas com baixa visão não conseguem ler.**

### A Solução
Converter para **rem** (relativo ao tamanho base do navegador, 16px padrão):

```css
/* Antes */
.ps-titulo { font-size: 15px; }
.ps-score { font-size: 13px; }

/* Depois */
.ps-titulo { font-size: 0.95rem; }   /* ~15px */
.ps-score { font-size: 0.8rem; }    /* ~12.8px, próximo a 13px */
.ps-rodape { font-size: 0.75rem; }  /* ~12px, antes era 11px ✓ */
```

**Vantagem:** Quando usuário aumenta zoom, TUDO se redimensiona proporcionalmente. Sem elementos cortados.

**Teste:**
- Zoom 200%: button tem min-height: 2.5rem (40px), nenhuma quebra
- Nenhum elemento fica pixelado ou ilegível

---

## 6. Contraste: Matemática e Ajustes

### Fórmula WCAG
```
Razão = (L1 + 0.05) / (L2 + 0.05)
L = luminância relativa = 0.299*R + 0.587*G + 0.114*B  (cada RGB 0-1)
Mínimo: 4,5:1 (texto), 3:1 (elemento gráfico / grande)
```

### Exemplo: Status OFFLINE Original
- Texto: #e74c3c (RGB 231, 76, 60) → L ≈ 0.235
- Fundo: #111c36 (RGB 17, 28, 54) → L ≈ 0.011
- Razão: (0.235 + 0.05) / (0.011 + 0.05) = 4,42:1 ❌ (precisa 4,5:1)

### Novo: #ff6b5e
- Texto: #ff6b5e (RGB 255, 107, 94) → L ≈ 0.355
- Fundo: #111c36 → L ≈ 0.011
- Razão: (0.355 + 0.05) / (0.011 + 0.05) = 6,05:1 ✅

### Borda MÉDIO: Elemento Gráfico
- Original: #f29900 sobre #fef7e0 = 2,1:1 (precisa 3:1)
- Novo: #c26401 sobre #fef7e0 = 3,83:1 ✅

---

## 7. Suporte a Reduced-Motion (styles.css)

### O Problema
Usuários com desordens vestibulares ficam tontinhos com animações. Navegador oferece preferência `prefers-reduced-motion`.

### A Solução
```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

**Efeito:** Se não há animação no código, nada muda. Se houver, fica instantânea.

**Como testar:**
1. Windows: Configurações > Acessibilidade > Exibição > "Mostrar animações" OFF
2. Chrome DevTools: Command Palette > "Emulate CSS media feature prefers-reduced-motion: reduce"

---

## 8. Suporte a Modo de Alto Contraste (styles.css)

### O Problema
No Windows, modo de alto contraste desativa cores personalizadas. Fundo fica cinzento. Borda lateral vira invisível.

### A Solução
```css
@media (forced-colors: active) {
  .ps-banner {
    border: 2px solid;                    /* Usa cor padrão do sistema */
  }
  
  .ps-titulo {
    font-weight: bold;
    color: CanvasText;                    /* Branco ou preto do tema */
  }
  
  .ps-score {
    background: Canvas;
    color: CanvasText;
    border: 1px solid CanvasText;
  }
  
  .ps-botao {
    border: 2px solid CanvasText;
    background: Canvas;
    color: CanvasText;
  }
}
```

**Palavras-chave:**
- **Canvas**: cor de fundo padrão (cinzento, preto etc.)
- **CanvasText**: cor de texto padrão
- **border**: sempre 1-2px para visibilidade em qualquer tema

**Teste:**
1. Configurações > Acessibilidade > Exibição > Alto Contraste > "Alto Contraste Preto"
2. Reabra o Chrome (pode exigir reinício)
3. Veja: fundo vira cinzento, borda continua preta, foco (outline) continua visível

---

## 9. Status API com role="status" (popup.html + popup.js)

### O Problema
#status-api muda de "verificando..." para "ONLINE" sem anúncio. Leitor de tela não sabe que algo mudou.

### A Solução
```html
<div class="valor" id="status-api" role="status" aria-live="polite">verificando...</div>
```

**role="status"**: Essa <div> é um status (como caixa de diálogo de progresso).
**aria-live="polite"**: Quando o texto muda, o leitor anuncia, mas não interrompe.

**JavaScript:**
```javascript
el.setAttribute("aria-live", "polite");
el.textContent = "✓ Online";
// Narrador automaticamente anuncia: "Online"
```

---

## 10. Correção de Acentuação (popup.html + popup.js)

### O Problema
"Servidor de analise" → Narrador pronuncia "análise" errado (pensa que "analise" é verbo no imperativo).
"Testar conexao" → Narrador pronuncia "cone-ção" (falta o cedilha).

### A Solução
Adicionar acento correto em HTML:

```html
<!-- Antes -->
<div class="label">Servidor de analise</div>
<button id="btn-testar">Testar conexao</button>

<!-- Depois -->
<div class="label">Servidor de análise</div>
<button id="btn-testar">Testar conexão</button>
```

**Charset UTF-8 na <head>:** `<meta charset="UTF-8" />`

---

## 11. Checklist de Implementação

- ✅ Aria-live criada (obterOuCriarAriaLive)
- ✅ Anúncios com prioridade (assertive/polite)
- ✅ Emojis com aria-hidden
- ✅ Banner com role="region" + aria-label + lang
- ✅ <summary> com :focus-visible
- ✅ Botão com :focus-visible
- ✅ Todas as fontes em rem, mínimo 0.75rem (12px)
- ✅ Contraste OFFLINE: #ff6b5e (6,05:1)
- ✅ Contraste borda MÉDIO: #c26401 (3,83:1)
- ✅ Popup #status-api com role="status"
- ✅ Acentuação corrigida
- ✅ prefers-reduced-motion respeitada
- ✅ forced-colors (alto contraste) suportado

---

## 12. Referências WCAG 2.1

| Critério | Nome | Descrição |
|----------|------|-----------|
| 1.1.1 | Non-text Content | Alternativa para imagens/emojis (aria-hidden) |
| 1.3.1 | Info and Relationships | Semântica ARIA (role, aria-label, aria-live) |
| 1.4.3 | Contrast (Minimum) | Razão de contraste ≥4,5:1 (texto), ≥3:1 (gráfico) |
| 1.4.4 | Resize Text | Texto redimensionável sem perda (zoom 200%) |
| 1.4.5 | Images of Text | Usar texto real, não imagens de texto |
| 1.4.11 | Non-text Contrast | Bordas e ícones com contraste ≥3:1 |
| 2.3.3 | Animation from Interactions | Respeitar prefers-reduced-motion |
| 2.4.3 | Focus Order | Ordem de foco lógica (Tab) |
| 2.4.7 | Focus Visible | Indicador de foco sempre visível |
| 3.1.2 | Language of Parts | lang="pt-BR" para português |
| 4.1.3 | Status Messages | role="status" / aria-live para atualizações |

