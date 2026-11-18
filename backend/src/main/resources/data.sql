-- =============================================================
-- Phishing Shield A3 - Carga inicial do dicionario (PostgreSQL)
-- ON CONFLICT DO NOTHING: nao sobrescreve alteracoes feitas no banco.
-- Para retirar um termo, use ativo = FALSE (nao apague o registro,
-- pois esta carga o recriaria na proxima inicializacao da API).
-- =============================================================

INSERT INTO indicador (codigo, nome, descricao, tipo, mensagem_alerta, peso_por_ocorrencia, pontuacao_maxima, ordem, ativo) VALUES
    ('URGENCIA', 'Urgência e pressão', 'Termos que criam senso de urgência, medo ou ameaça de bloqueio.', 'TEXTO', 'Linguagem de urgência detectada: "{termo}"', 8, 24, 1, TRUE),
    ('DADO_SENSIVEL', 'Solicitação de dados sensíveis', 'Pedidos de senha, documentos, dados bancários ou pagamentos.', 'TEXTO', 'Solicitação de dado sensível detectada: "{termo}"', 12, 36, 2, TRUE),
    ('ISCA_FINANCEIRA', 'Isca financeira', 'Promessas de prêmio, reembolso, herança ou vantagem financeira.', 'TEXTO', 'Possível isca financeira: "{termo}"', 10, 20, 3, TRUE),
    ('SAUDACAO_GENERICA', 'Saudação genérica', 'Saudações impessoais, típicas de envio em massa.', 'TEXTO', 'Saudação genérica ("{termo}") em vez do seu nome.', 10, 10, 4, TRUE),
    ('MARCA_CONHECIDA', 'Marca conhecida', 'Marcas e instituições frequentemente imitadas em golpes.', 'REFERENCIA', NULL, NULL, NULL, 5, TRUE),
    ('DOMINIO_GRATUITO', 'Domínio gratuito', 'Provedores de e-mail gratuitos, incomuns em comunicados oficiais.', 'REFERENCIA', NULL, NULL, NULL, 6, TRUE),
    ('ENCURTADOR_URL', 'Encurtador de URL', 'Serviços que escondem o destino real do link.', 'REFERENCIA', NULL, NULL, NULL, 7, TRUE),
    ('TLD_SUSPEITO', 'Extensão de domínio suspeita', 'Extensões (TLDs) muito usadas em campanhas maliciosas.', 'REFERENCIA', NULL, NULL, NULL, 8, TRUE)
ON CONFLICT (codigo) DO NOTHING;

-- URGENCIA: 20 termos ativos + 16 sugeridos (inativos)
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao)
SELECT i.id, v.termo, v.ativo, CAST(v.observacao AS VARCHAR(255))
FROM (VALUES
    (1, 'urgente', TRUE, NULL),
    (2, 'imediato', TRUE, NULL),
    (3, 'imediatamente', TRUE, NULL),
    (4, 'ultimo aviso', TRUE, NULL),
    (5, 'último aviso', TRUE, NULL),
    (6, 'expira hoje', TRUE, NULL),
    (7, 'expira em', TRUE, NULL),
    (8, 'suspensa', TRUE, NULL),
    (9, 'suspenso', TRUE, NULL),
    (10, 'bloqueada', TRUE, NULL),
    (11, 'bloqueado', TRUE, NULL),
    (12, 'cancelada', TRUE, NULL),
    (13, 'cancelado', TRUE, NULL),
    (14, 'acao necessaria', TRUE, NULL),
    (15, 'ação necessária', TRUE, NULL),
    (16, 'prazo final', TRUE, NULL),
    (17, 'responda agora', TRUE, NULL),
    (18, 'clique agora', TRUE, NULL),
    (19, '24 horas', TRUE, NULL),
    (20, '48 horas', TRUE, NULL),
    (21, 'ultima chance', FALSE, 'Sugerido - revisar antes de ativar'),
    (22, 'sua conta sera', FALSE, 'Sugerido - revisar antes de ativar'),
    (23, 'conta bloqueada', FALSE, 'Sugerido - revisar antes de ativar'),
    (24, 'conta suspensa', FALSE, 'Sugerido - revisar antes de ativar'),
    (25, 'bloqueio', FALSE, 'Sugerido - revisar antes de ativar'),
    (26, 'regularize', FALSE, 'Sugerido - revisar antes de ativar'),
    (27, 'clique aqui agora', FALSE, 'Sugerido - revisar antes de ativar'),
    (28, 'em 24 horas', FALSE, 'Sugerido - revisar antes de ativar'),
    (29, 'pendencia', FALSE, 'Sugerido - revisar antes de ativar'),
    (30, 'divida', FALSE, 'Sugerido - revisar antes de ativar'),
    (31, 'cpf irregular', FALSE, 'Sugerido - revisar antes de ativar'),
    (32, 'resgate seu', FALSE, 'Sugerido - revisar antes de ativar'),
    (33, 'pix bloqueado', FALSE, 'Sugerido - revisar antes de ativar'),
    (34, 'comprovante de pagamento', FALSE, 'Sugerido - revisar antes de ativar'),
    (35, 'nota fiscal', FALSE, 'Sugerido - revisar antes de ativar'),
    (36, 'boleto atrasado', FALSE, 'Sugerido - revisar antes de ativar')
) AS v(ordem, termo, ativo, observacao)
JOIN indicador i ON i.codigo = 'URGENCIA'
ORDER BY v.ordem
ON CONFLICT (indicador_id, termo) DO NOTHING;

-- DADO_SENSIVEL: 19 termos ativos + 5 sugeridos (inativos)
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao)
SELECT i.id, v.termo, v.ativo, CAST(v.observacao AS VARCHAR(255))
FROM (VALUES
    (1, 'senha', TRUE, NULL),
    (2, 'cpf', TRUE, NULL),
    (3, 'cartao de credito', TRUE, NULL),
    (4, 'cartão de crédito', TRUE, NULL),
    (5, 'codigo de seguranca', TRUE, NULL),
    (6, 'código de segurança', TRUE, NULL),
    (7, 'token', TRUE, NULL),
    (8, 'pix', TRUE, NULL),
    (9, 'deposito', TRUE, NULL),
    (10, 'depósito', TRUE, NULL),
    (11, 'transferencia', TRUE, NULL),
    (12, 'transferência', TRUE, NULL),
    (13, 'boleto', TRUE, NULL),
    (14, 'atualize seus dados', TRUE, NULL),
    (15, 'confirme seus dados', TRUE, NULL),
    (16, 'valide sua conta', TRUE, NULL),
    (17, 'recadastramento', TRUE, NULL),
    (18, 'dados bancarios', TRUE, NULL),
    (19, 'dados bancários', TRUE, NULL),
    (20, 'cvv', FALSE, 'Sugerido - revisar antes de ativar'),
    (21, 'numero do cartao', FALSE, 'Sugerido - revisar antes de ativar'),
    (22, 'assinatura eletronica', FALSE, 'Sugerido - revisar antes de ativar'),
    (23, 'chave de seguranca', FALSE, 'Sugerido - revisar antes de ativar'),
    (24, 'senha de 4 digitos', FALSE, 'Sugerido - revisar antes de ativar')
) AS v(ordem, termo, ativo, observacao)
JOIN indicador i ON i.codigo = 'DADO_SENSIVEL'
ORDER BY v.ordem
ON CONFLICT (indicador_id, termo) DO NOTHING;

-- ISCA_FINANCEIRA: 16 termos ativos
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao)
SELECT i.id, v.termo, v.ativo, CAST(v.observacao AS VARCHAR(255))
FROM (VALUES
    (1, 'voce ganhou', TRUE, NULL),
    (2, 'você ganhou', TRUE, NULL),
    (3, 'premio', TRUE, NULL),
    (4, 'prêmio', TRUE, NULL),
    (5, 'sorteio', TRUE, NULL),
    (6, 'heranca', TRUE, NULL),
    (7, 'herança', TRUE, NULL),
    (8, 'restituicao', TRUE, NULL),
    (9, 'restituição', TRUE, NULL),
    (10, 'reembolso', TRUE, NULL),
    (11, 'milhoes', TRUE, NULL),
    (12, 'milhões', TRUE, NULL),
    (13, 'oferta exclusiva', TRUE, NULL),
    (14, 'gratis', TRUE, NULL),
    (15, 'grátis', TRUE, NULL),
    (16, 'sorteado', TRUE, NULL)
) AS v(ordem, termo, ativo, observacao)
JOIN indicador i ON i.codigo = 'ISCA_FINANCEIRA'
ORDER BY v.ordem
ON CONFLICT (indicador_id, termo) DO NOTHING;

-- SAUDACAO_GENERICA: 6 termos ativos + 2 sugeridos (inativos)
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao)
SELECT i.id, v.termo, v.ativo, CAST(v.observacao AS VARCHAR(255))
FROM (VALUES
    (1, 'prezado cliente', TRUE, NULL),
    (2, 'caro usuario', TRUE, NULL),
    (3, 'caro usuário', TRUE, NULL),
    (4, 'prezado usuario', TRUE, NULL),
    (5, 'prezado usuário', TRUE, NULL),
    (6, 'caro cliente', TRUE, NULL),
    (7, 'prezado(a) cliente', FALSE, 'Sugerido - revisar antes de ativar'),
    (8, 'estimado cliente', FALSE, 'Sugerido - revisar antes de ativar')
) AS v(ordem, termo, ativo, observacao)
JOIN indicador i ON i.codigo = 'SAUDACAO_GENERICA'
ORDER BY v.ordem
ON CONFLICT (indicador_id, termo) DO NOTHING;

-- MARCA_CONHECIDA: 17 termos ativos + 10 sugeridos (inativos)
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao)
SELECT i.id, v.termo, v.ativo, CAST(v.observacao AS VARCHAR(255))
FROM (VALUES
    (1, 'banco do brasil', TRUE, NULL),
    (2, 'bradesco', TRUE, NULL),
    (3, 'itau', TRUE, NULL),
    (4, 'itaú', TRUE, NULL),
    (5, 'santander', TRUE, NULL),
    (6, 'caixa', TRUE, NULL),
    (7, 'nubank', TRUE, NULL),
    (8, 'receita federal', TRUE, NULL),
    (9, 'serasa', TRUE, NULL),
    (10, 'correios', TRUE, NULL),
    (11, 'netflix', TRUE, NULL),
    (12, 'mercado livre', TRUE, NULL),
    (13, 'magalu', TRUE, NULL),
    (14, 'americanas', TRUE, NULL),
    (15, 'ford', TRUE, NULL),
    (16, 'microsoft', TRUE, NULL),
    (17, 'google', TRUE, NULL),
    (18, 'inter', FALSE, 'Sugerido - revisar antes de ativar'),
    (19, 'c6', FALSE, 'Sugerido - revisar antes de ativar'),
    (20, 'sicredi', FALSE, 'Sugerido - revisar antes de ativar'),
    (21, 'banrisul', FALSE, 'Sugerido - revisar antes de ativar'),
    (22, 'safra', FALSE, 'Sugerido - revisar antes de ativar'),
    (23, 'pagbank', FALSE, 'Sugerido - revisar antes de ativar'),
    (24, 'picpay', FALSE, 'Sugerido - revisar antes de ativar'),
    (25, 'mercado pago', FALSE, 'Sugerido - revisar antes de ativar'),
    (26, 'gov.br', FALSE, 'Sugerido - revisar antes de ativar'),
    (27, 'shopee', FALSE, 'Sugerido - revisar antes de ativar')
) AS v(ordem, termo, ativo, observacao)
JOIN indicador i ON i.codigo = 'MARCA_CONHECIDA'
ORDER BY v.ordem
ON CONFLICT (indicador_id, termo) DO NOTHING;

-- DOMINIO_GRATUITO: 8 termos ativos + 3 sugeridos (inativos)
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao)
SELECT i.id, v.termo, v.ativo, CAST(v.observacao AS VARCHAR(255))
FROM (VALUES
    (1, 'gmail.com', TRUE, NULL),
    (2, 'hotmail.com', TRUE, NULL),
    (3, 'outlook.com', TRUE, NULL),
    (4, 'yahoo.com', TRUE, NULL),
    (5, 'bol.com.br', TRUE, NULL),
    (6, 'uol.com.br', TRUE, NULL),
    (7, 'live.com', TRUE, NULL),
    (8, 'protonmail.com', TRUE, NULL),
    (9, 'yahoo.com.br', FALSE, 'Sugerido - revisar antes de ativar'),
    (10, 'icloud.com', FALSE, 'Sugerido - revisar antes de ativar'),
    (11, 'proton.me', FALSE, 'Sugerido - revisar antes de ativar')
) AS v(ordem, termo, ativo, observacao)
JOIN indicador i ON i.codigo = 'DOMINIO_GRATUITO'
ORDER BY v.ordem
ON CONFLICT (indicador_id, termo) DO NOTHING;

-- ENCURTADOR_URL: 9 termos ativos + 2 sugeridos (inativos)
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao)
SELECT i.id, v.termo, v.ativo, CAST(v.observacao AS VARCHAR(255))
FROM (VALUES
    (1, 'bit.ly', TRUE, NULL),
    (2, 'tinyurl.com', TRUE, NULL),
    (3, 'goo.gl', TRUE, NULL),
    (4, 't.co', TRUE, NULL),
    (5, 'is.gd', TRUE, NULL),
    (6, 'ow.ly', TRUE, NULL),
    (7, 'cutt.ly', TRUE, NULL),
    (8, 'rebrand.ly', TRUE, NULL),
    (9, 'encurtador.com.br', TRUE, NULL),
    (10, 'shorturl.at', FALSE, 'Sugerido - revisar antes de ativar'),
    (11, 'rb.gy', FALSE, 'Sugerido - revisar antes de ativar')
) AS v(ordem, termo, ativo, observacao)
JOIN indicador i ON i.codigo = 'ENCURTADOR_URL'
ORDER BY v.ordem
ON CONFLICT (indicador_id, termo) DO NOTHING;

-- TLD_SUSPEITO: 13 termos ativos + 2 sugeridos (inativos)
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao)
SELECT i.id, v.termo, v.ativo, CAST(v.observacao AS VARCHAR(255))
FROM (VALUES
    (1, '.xyz', TRUE, NULL),
    (2, '.top', TRUE, NULL),
    (3, '.click', TRUE, NULL),
    (4, '.zip', TRUE, NULL),
    (5, '.review', TRUE, NULL),
    (6, '.country', TRUE, NULL),
    (7, '.tk', TRUE, NULL),
    (8, '.ml', TRUE, NULL),
    (9, '.ga', TRUE, NULL),
    (10, '.cf', TRUE, NULL),
    (11, '.gq', TRUE, NULL),
    (12, '.work', TRUE, NULL),
    (13, '.fit', TRUE, NULL),
    (14, '.mov', FALSE, 'Sugerido - revisar antes de ativar'),
    (15, '.rest', FALSE, 'Sugerido - revisar antes de ativar')
) AS v(ordem, termo, ativo, observacao)
JOIN indicador i ON i.codigo = 'TLD_SUSPEITO'
ORDER BY v.ordem
ON CONFLICT (indicador_id, termo) DO NOTHING;
