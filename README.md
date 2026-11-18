# Phishing Shield A3

Detector de phishing em e-mails do Gmail:

- **Extensao do Chrome** (frontend): captura o e-mail aberto e exibe o alerta.
- **API REST em Java 11 / Spring Boot** (backend): calcula a pontuacao de risco.
- **PostgreSQL** (Neon): guarda o dicionario de palavras-chave usado na deteccao.

Em producao, a API roda no **Render** e o banco no **Neon** (planos gratuitos).

## Estrutura

```
phishing-shield-a3/
├── extension/                  # Extensao do Chrome (Manifest V3)
│   ├── config.js               # ENDERECO DA API (altere aqui)
│   ├── content.js              # captura o e-mail no Gmail e mostra o alerta
│   ├── styles.css
│   ├── popup.html / popup.js   # status do servidor
│   └── icons/
├── backend/                    # API Java (Spring Boot)
│   ├── Dockerfile              # usado pelo Render
│   ├── rodar.cmd               # executa localmente com banco H2 (Windows)
│   ├── rodar-neon.cmd          # executa localmente com o banco do Neon
│   ├── credenciais.exemplo.cmd # modelo das credenciais locais
│   └── src/main/
│       ├── java/br/com/a3/phishingshield/
│       │   ├── controller/  AnaliseController, DicionarioController
│       │   ├── service/     AnalisadorService, DicionarioPhishingService
│       │   ├── model/       Indicador, PalavraChave
│       │   └── repository/  IndicadorRepository, PalavraChaveRepository
│       └── resources/
│           ├── application.properties
│           ├── application-local.properties  # perfil local (H2)
│           ├── schema.sql      # tabelas do dicionario (PostgreSQL)
│           ├── data.sql        # carga das palavras-chave (PostgreSQL)
│           └── h2/             # mesmas tabelas e dados para o H2
└── database/
    ├── phishing_shield_banco.sql   # script completo (opcional)
    └── consultas_dicionario.sql    # consultas e exemplos de manutencao
```

## Endpoints

| Metodo | Caminho | Descricao |
|---|---|---|
| GET | `/api/analise/health` | Status da API |
| POST | `/api/analise` | Analisa um e-mail (`remetente`, `assunto`, `corpo`) |
| GET | `/api/dicionario` | Lista o dicionario carregado |
| POST | `/api/dicionario/recarregar` | Recarrega o dicionario do banco |

## Banco de dados (dicionario de phishing)

| Tabela | Conteudo |
|---|---|
| `indicador` | 8 categorias (URGENCIA, DADO_SENSIVEL, ISCA_FINANCEIRA, SAUDACAO_GENERICA, MARCA_CONHECIDA, DOMINIO_GRATUITO, ENCURTADOR_URL, TLD_SUSPEITO), pesos e mensagem do alerta |
| `palavra_chave` | 108 termos ativos + 40 sugeridos (inativos) |
| `vw_dicionario_ativo` | View com o dicionario em uso |

Ao iniciar, a API executa `schema.sql` e `data.sql` (idempotentes) e carrega o dicionario na memoria.
Para alterar termos, use o **SQL Editor do Neon** (exemplos em `database/consultas_dicionario.sql`)
e depois chame `POST /api/dicionario/recarregar`.

> Para retirar um termo, use `ativo = FALSE` em vez de apagar: a carga inicial recriaria um termo apagado.

## Variaveis de ambiente da API

| Variavel | Exemplo |
|---|---|
| `DB_URL` | `jdbc:postgresql://ep-xxxx.us-east-1.aws.neon.tech/neondb?sslmode=require` |
| `DB_USER` | `neondb_owner` |
| `DB_PASSWORD` | senha do Neon |
| `PORT` | definida automaticamente pelo Render (local: 9090) |

## Executar localmente (Windows)

| Script | Banco usado | Quando usar |
|---|---|---|
| `backend/rodar.cmd` | H2 em memoria (perfil `local`) | Desenvolvimento e testes; funciona em qualquer rede |
| `backend/rodar-neon.cmd` | PostgreSQL do Neon | Fora da rede corporativa; exige `backend/credenciais.cmd` |

1. Execute `backend/rodar.cmd`.
2. Em `extension/config.js`, use `http://localhost:9090` e recarregue a extensao.
3. Console do banco local: `http://localhost:9090/h2-console`
   (JDBC URL `jdbc:h2:mem:phishing_shield`, usuario `sa`, senha vazia).

No modo local o dicionario e recriado a cada inicializacao; alteracoes permanentes
devem ser feitas no Neon.

## Publicar

Veja o passo a passo em `GUIA_PUBLICACAO.md`.

## Classificacao

0-29 BAIXO · 30-59 MEDIO · 60-100 ALTO. A pontuacao e um indice calculado por regras,
nao uma probabilidade estatistica de fraude.

## Proximos passos

- Gravar o historico de analises no banco
- Melhorias e testes de acessibilidade
- Autenticacao (opcional, apenas para historico)
