-- =============================================================
-- Phishing Shield A3 - Consultas e manutencao do dicionario (PostgreSQL)
-- Use no SQL Editor do Neon. Depois de alterar dados, aplique na API:
--   POST https://SEU-SERVICO.onrender.com/api/dicionario/recarregar
-- =============================================================

-- 1) Quantidade de termos por indicador
SELECT i.codigo, i.nome, i.tipo,
       COUNT(p.id) FILTER (WHERE p.ativo)     AS termos_ativos,
       COUNT(p.id) FILTER (WHERE NOT p.ativo) AS termos_inativos
FROM indicador i
LEFT JOIN palavra_chave p ON p.indicador_id = i.id
GROUP BY i.id, i.codigo, i.nome, i.tipo
ORDER BY i.ordem;

-- 2) Dicionario em uso
SELECT * FROM vw_dicionario_ativo ORDER BY indicador, termo;

-- 3) Termos sugeridos, ainda inativos
SELECT i.codigo, p.id, p.termo, p.observacao
FROM palavra_chave p
JOIN indicador i ON i.id = p.indicador_id
WHERE p.ativo = FALSE
ORDER BY i.ordem, p.termo;

-- 4) Cadastrar um novo termo
INSERT INTO palavra_chave (indicador_id, termo, ativo)
SELECT id, 'processo judicial', TRUE
FROM indicador WHERE codigo = 'URGENCIA';

-- 5) Ativar um termo sugerido
UPDATE palavra_chave
SET ativo = TRUE, observacao = NULL
WHERE termo = 'cvv'
  AND indicador_id = (SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL');

-- 6) Desativar um termo (preferivel a apagar)
UPDATE palavra_chave
SET ativo = FALSE
WHERE termo = 't.co'
  AND indicador_id = (SELECT id FROM indicador WHERE codigo = 'ENCURTADOR_URL');

-- 7) Ajustar a pontuacao de uma categoria de texto
UPDATE indicador
SET peso_por_ocorrencia = 10, pontuacao_maxima = 30
WHERE codigo = 'URGENCIA';

-- 8) Criar uma nova categoria de texto, sem alterar o codigo Java
INSERT INTO indicador (codigo, nome, descricao, tipo, mensagem_alerta,
                       peso_por_ocorrencia, pontuacao_maxima, ordem, ativo)
VALUES ('AMEACA_JURIDICA', 'Ameaça jurídica',
        'Termos que ameaçam processo, multa ou ação judicial.',
        'TEXTO', 'Ameaça jurídica detectada: "{termo}"', 10, 20, 9, TRUE);

INSERT INTO palavra_chave (indicador_id, termo, ativo)
SELECT i.id, v.termo, TRUE
FROM indicador i
CROSS JOIN (VALUES ('protesto em cartório'), ('multa'), ('ação judicial')) AS v(termo)
WHERE i.codigo = 'AMEACA_JURIDICA'
ON CONFLICT (indicador_id, termo) DO NOTHING;
