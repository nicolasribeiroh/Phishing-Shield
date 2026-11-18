-- =============================================================
-- Phishing Shield A3 - Estrutura do dicionario de phishing (PostgreSQL)
-- Script idempotente: pode ser executado varias vezes.
-- =============================================================

CREATE TABLE IF NOT EXISTS indicador (
    id                   BIGSERIAL    PRIMARY KEY,
    codigo               VARCHAR(40)  NOT NULL,
    nome                 VARCHAR(80)  NOT NULL,
    descricao            VARCHAR(255),
    tipo                 VARCHAR(20)  NOT NULL,
    mensagem_alerta      VARCHAR(255),
    peso_por_ocorrencia  INTEGER,
    pontuacao_maxima     INTEGER,
    ordem                INTEGER      NOT NULL DEFAULT 0,
    ativo                BOOLEAN      NOT NULL DEFAULT TRUE,
    CONSTRAINT uk_indicador_codigo UNIQUE (codigo),
    CONSTRAINT ck_indicador_tipo CHECK (tipo IN ('TEXTO', 'REFERENCIA')),
    CONSTRAINT ck_indicador_pesos CHECK (
        tipo = 'REFERENCIA'
        OR (peso_por_ocorrencia IS NOT NULL AND peso_por_ocorrencia >= 0
            AND pontuacao_maxima IS NOT NULL AND pontuacao_maxima >= 0)
    )
);

-- No PostgreSQL a comparacao de texto ja diferencia acentos:
-- "ultimo aviso" e "último aviso" sao termos diferentes.
CREATE TABLE IF NOT EXISTS palavra_chave (
    id              BIGSERIAL    PRIMARY KEY,
    indicador_id    BIGINT       NOT NULL,
    termo           VARCHAR(150) NOT NULL,
    ativo           BOOLEAN      NOT NULL DEFAULT TRUE,
    observacao      VARCHAR(255),
    data_cadastro   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_palavra_chave_termo UNIQUE (indicador_id, termo),
    CONSTRAINT fk_palavra_chave_indicador FOREIGN KEY (indicador_id)
        REFERENCES indicador (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_palavra_chave_ativo ON palavra_chave (indicador_id, ativo);

CREATE OR REPLACE VIEW vw_dicionario_ativo AS
SELECT i.codigo AS indicador,
       i.nome   AS nome_indicador,
       i.tipo,
       i.peso_por_ocorrencia,
       i.pontuacao_maxima,
       p.id     AS palavra_id,
       p.termo
FROM palavra_chave p
JOIN indicador i ON i.id = p.indicador_id
WHERE p.ativo = TRUE AND i.ativo = TRUE;
