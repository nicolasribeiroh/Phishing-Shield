# Guia de publicacao - Phishing Shield A3

Banco: **Neon** (PostgreSQL gratuito) · API: **Render** (Docker gratuito) · Codigo: **GitHub**

## 1. Neon (banco)
1. Crie uma conta em https://neon.com (pode entrar com o GitHub).
2. Crie um projeto: nome `phishing-shield`, PostgreSQL mais recente, regiao **AWS US East (N. Virginia)**.
3. Em **Connect**, desligue **Connection pooling** e anote host, banco (`neondb`), usuario e senha.
4. Monte a URL JDBC:
   `jdbc:postgresql://HOST/neondb?sslmode=require`

## 2. GitHub (codigo)
Envie esta pasta para o repositorio. Nunca envie `backend/credenciais.cmd`.

## 3. Render (API)
1. Crie uma conta em https://render.com com o GitHub.
2. New > Web Service > escolha o repositorio.
3. Configure:
   - Language: **Docker**
   - Root Directory: **backend**
   - Region: **Virginia (US East)**
   - Instance Type: **Free**
   - Health Check Path: `/api/analise/health`
4. Environment Variables: `DB_URL`, `DB_USER`, `DB_PASSWORD`.
5. Deploy. A URL final fica no formato `https://NOME.onrender.com`.

## 4. Extensao
1. Em `extension/config.js`, coloque a URL do Render em `PS_API_BASE`.
2. Em `chrome://extensions`, clique em recarregar na extensao.

## 5. Testes
- `https://NOME.onrender.com/api/analise/health`
- `https://NOME.onrender.com/api/dicionario`

O plano gratuito do Render desliga a API apos 15 minutos sem uso; o primeiro acesso depois disso leva cerca de 1 minuto.
Antes de apresentar, abra o endereco de health para "acordar" o servidor.
