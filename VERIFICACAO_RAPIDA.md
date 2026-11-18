# ✅ Verificação Rápida — Checklist de Implantação

Antes de fazer commit ou submeter a A3, execute este checklist para garantir que todas as correções estão em lugar.

---

## 1. Arquivos Corrigidos (4)

### 1.1 content.js
```bash
# Deve conter:
grep -c "aria-live" content.js              # ≥ 1 (região aria-live criada)
grep -c "aria-hidden" content.js            # ≥ 1 (emojis com aria-hidden)
grep -c "role=\"region\"" content.js        # ≥ 1 (banner com role)
grep -c "aria-label" content.js             # ≥ 1 (nome da região)
grep -c "lang=\"pt-BR\"" content.js         # ≥ 1 (idioma do banner)
grep -c "ARIA_LIVE_ID" content.js           # ≥ 1 (ID da região)
grep -c "obterOuCriarAriaLive" content.js   # ≥ 1 (função nova)
grep -c "anunciarAoLeitor" content.js       # ≥ 2 (função + uso)

# Resultado esperado: ✅ Todas as strings presentes
```

### 1.2 styles.css
```bash
# Deve conter:
grep -c "rem" styles.css                    # ≥ 10 (fontes em rem)
grep -c "focus-visible" styles.css          # ≥ 2 (foco em summary + button)
grep -c "outline: 3px" styles.css           # ≥ 2 (3px em elementos)
grep -c "#c26401" styles.css                # ≥ 1 (cor nova borda MÉDIO)
grep -c "@media (prefers-reduced-motion" styles.css  # ≥ 1
grep -c "@media (forced-colors: active)" styles.css  # ≥ 1

# Resultado esperado: ✅ Todas as strings presentes
```

### 1.3 popup.html
```bash
# Deve conter:
grep -c "role=\"status\"" popup.html        # ≥ 1 (status API)
grep -c "aria-live=\"polite\"" popup.html   # ≥ 1 (anúncio)
grep -c "análise" popup.html                # ≥ 1 (acentuação corrigida)
grep -c "conexão" popup.html                # ≥ 1 (acentuação corrigida)
grep -c "0.75rem" popup.html                # ≥ 2 (fontes pequenas em rem)
grep -c "lang=\"pt-BR\"" popup.html         # ≥ 1 (idioma)
grep -c ":focus-visible" popup.html         # ≥ 1 (foco visível no botão)

# Resultado esperado: ✅ Todas as strings presentes
```

### 1.4 popup.js
```bash
# Deve conter:
grep -c "Online" popup.js                   # ≥ 1 (texto do status)
grep -c "Offline" popup.js                  # ≥ 1 (texto do status)
grep -c "aria-live" popup.js                # ≥ 1 (setAttribute)

# Resultado esperado: ✅ Todas as strings presentes
```

---

## 2. Validação Rápida de Cores

### 2.1 OFFLINE (#ff6b5e)
```
Esperado: #ff6b5e (não #e74c3c)
Verificar em: popup.html (comment de mudança) ou popup.js (className "off")
```

### 2.2 Borda MÉDIO (#c26401)
```
Esperado: #c26401 (não #f29900)
Verificar em: styles.css → .ps-medio { border-left-color: #c26401; }
```

---

## 3. Testes Manuais (5 min)

### 3.1 Teclado
```
1. Abra Gmail em nova aba
2. Clique em um e-mail
3. Aguarde banner surgir
4. Pressione TAB até banner ter foco (deve ver contorno preto)
5. Pressione SPACE/ENTER em <summary> (deve expandir)
   ✅ Resultado: Sem perda de foco, contorno visível
```

### 3.2 Narrador Windows
```
1. Pressione Ctrl + Windows + Enter (ativa Narrador)
2. Aguarde banner surgir no Gmail
   ✅ Resultado: Narrador anuncia "Phishing Shield: risco [nível]..."
3. Pressione Ctrl + Windows + Enter (desativa)
```

### 3.3 Zoom 200%
```
1. No Chrome, pressione Ctrl + Plus (+) 4 vezes
   ✅ Resultado: Banner redimensiona, sem cortes, botão legível
2. Pressione Ctrl + Zero (volta 100%)
```

### 3.4 Alto Contraste Windows
```
1. Vá a Configurações > Acessibilidade > Exibição > Alto Contraste
2. Selecione um tema (ex.: "Alto Contraste Preto")
3. Clique Aplicar; Chrome pode exigir reinício
4. Reabra Gmail, clique em e-mail
   ✅ Resultado: Fundo fica cinzento, borda lateral visível, foco visível
5. Desative alto contraste
```

### 3.5 Popup
```
1. Clique ícone Phishing Shield (canto superior direito)
2. Veja status da API (ONLINE ou OFFLINE)
3. Clique "Testar conexão"
   ✅ Resultado: Status muda, Narrador anuncia mudança (se ativado)
```

---

## 4. Verificação de Integração

### 4.1 Sem quebra de lógica
```bash
# Verificar que originais ainda funcionam:
# - Nenhuma mudança em extrairEmailAberto()
# - Nenhuma mudança em API_URL ou TEMPO_LIMITE_MS
# - Nenhuma mudança em escaparHtml()
# - Nenhuma mudança em seletores Gmail (.hP, .gD, .a3s)
# - Nenhuma mudança em endpoints (/api/analise, /api/analise/health)

✅ Resultado: Lógica de análise + API intactas
```

### 4.2 Sem XSS
```bash
# Verificar que escaparHtml é usada em:
# - resultado.recomendacao
# - resultado.alertas (cada item)
# - msg em mostrarAviso()
# - titulo em mostrarAviso()

✅ Resultado: Sem injeção XSS
```

---

## 5. Documentação

### 5.1 Arquivos Adicionados
```
Projeto-Raiz/
├── ACESSIBILIDADE_RELATORIO.md       (tabelas, testes, parágrafo)
├── GUIA_TECNICO_ACESSIBILIDADE.md    (explicações técnicas)
├── RESUMO_EXECUTIVO.md               (visão geral, compliance)
└── extension/
    ├── content.js                    (corrigido ✓)
    ├── styles.css                    (corrigido ✓)
    ├── popup.html                    (corrigido ✓)
    └── popup.js                      (corrigido ✓)
```

### 5.2 Verificar Estrutura
```bash
# No projeto-raiz:
ls -la extension/content.js extension/styles.css extension/popup.html extension/popup.js
# Deve listar 4 arquivos, datas atualizadas

ls -la ACESSIBILIDADE_RELATORIO.md GUIA_TECNICO_ACESSIBILIDADE.md RESUMO_EXECUTIVO.md
# Deve listar 3 arquivos novos
```

---

## 6. Resumo Final

Marque conforme conclui:

- [ ] content.js: aria-live, aria-hidden, role="region" presentes
- [ ] styles.css: rem, focus-visible, #c26401, @media presentes
- [ ] popup.html: role="status", aria-live, acentuação corrigida, rem
- [ ] popup.js: "Online"/"Offline" presentes, setAttribute
- [ ] Teste teclado: foco visível, sem pulo
- [ ] Teste Narrador: anúncio funciona
- [ ] Teste zoom 200%: sem quebra
- [ ] Teste alto contraste: bordas visíveis
- [ ] Verificado: Lógica intacta, sem XSS
- [ ] Documentação: 3 arquivos presentes

---

## 7. Checklist de Submissão da A3

Antes de fazer push/pull request:

- [ ] Executei o checklist completo acima (marcas todas)
- [ ] Rodei testes locais no Chrome (Dev Tools F12)
- [ ] Narrador testado (Windows)
- [ ] Zoom 200% testado
- [ ] Alto contraste testado (opcional, mas recomendado)
- [ ] Lido RESUMO_EXECUTIVO.md
- [ ] Lido ACESSIBILIDADE_RELATORIO.md (seção 1 mínimo)
- [ ] Pronto para apresentar na A3

---

## 8. Contato Rápido

Dúvida? Consulte:
1. **Como funciona aria-live?** → GUIA_TECNICO_ACESSIBILIDADE.md, seção 1
2. **Por que mudar cor?** → ACESSIBILIDADE_RELATORIO.md, tabela de contraste (seção 2)
3. **Como testar?** → ACESSIBILIDADE_RELATORIO.md, seção 3 (roteiro de testes)
4. **Conformidade legal?** → RESUMO_EXECUTIVO.md, final

---

**Pronto! Clique em cada link acima (Markdown) para navegação.**

