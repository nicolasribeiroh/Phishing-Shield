-- =============================================================
-- Phishing Shield A3 - Carga do dicionario (H2, somente modo local)
-- O banco H2 fica em memoria e e recriado a cada inicializacao.
-- =============================================================

INSERT INTO indicador (codigo, nome, descricao, tipo, mensagem_alerta, peso_por_ocorrencia, pontuacao_maxima, ordem, ativo) VALUES
    ('URGENCIA', 'Urgência e pressão', 'Termos que criam senso de urgência, medo ou ameaça de bloqueio.', 'TEXTO', 'Linguagem de urgência detectada: "{termo}"', 8, 24, 1, TRUE),
    ('DADO_SENSIVEL', 'Solicitação de dados sensíveis', 'Pedidos de senha, documentos, dados bancários ou pagamentos.', 'TEXTO', 'Solicitação de dado sensível detectada: "{termo}"', 12, 36, 2, TRUE),
    ('ISCA_FINANCEIRA', 'Isca financeira', 'Promessas de prêmio, reembolso, herança ou vantagem financeira.', 'TEXTO', 'Possível isca financeira: "{termo}"', 10, 20, 3, TRUE),
    ('SAUDACAO_GENERICA', 'Saudação genérica', 'Saudações impessoais, típicas de envio em massa.', 'TEXTO', 'Saudação genérica ("{termo}") em vez do seu nome.', 10, 10, 4, TRUE),
    ('MARCA_CONHECIDA', 'Marca conhecida', 'Marcas e instituições frequentemente imitadas em golpes.', 'REFERENCIA', NULL, NULL, NULL, 5, TRUE),
    ('DOMINIO_GRATUITO', 'Domínio gratuito', 'Provedores de e-mail gratuitos, incomuns em comunicados oficiais.', 'REFERENCIA', NULL, NULL, NULL, 6, TRUE),
    ('ENCURTADOR_URL', 'Encurtador de URL', 'Serviços que escondem o destino real do link.', 'REFERENCIA', NULL, NULL, NULL, 7, TRUE),
    ('TLD_SUSPEITO', 'Extensão de domínio suspeita', 'Extensões (TLDs) muito usadas em campanhas maliciosas.', 'REFERENCIA', NULL, NULL, NULL, 8, TRUE);

-- URGENCIA
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao) VALUES
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'urgente', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'imediato', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'imediatamente', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'ultimo aviso', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'último aviso', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'expira hoje', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'expira em', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'suspensa', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'suspenso', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'bloqueada', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'bloqueado', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'cancelada', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'cancelado', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'acao necessaria', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'ação necessária', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'prazo final', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'responda agora', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'clique agora', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), '24 horas', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), '48 horas', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'ultima chance', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'sua conta sera', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'conta bloqueada', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'conta suspensa', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'bloqueio', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'regularize', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'clique aqui agora', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'em 24 horas', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'pendencia', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'divida', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'cpf irregular', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'resgate seu', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'pix bloqueado', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'comprovante de pagamento', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'nota fiscal', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'URGENCIA'), 'boleto atrasado', FALSE, 'Sugerido - revisar antes de ativar');

-- DADO_SENSIVEL
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao) VALUES
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'senha', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'cpf', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'cartao de credito', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'cartão de crédito', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'codigo de seguranca', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'código de segurança', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'token', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'pix', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'deposito', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'depósito', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'transferencia', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'transferência', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'boleto', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'atualize seus dados', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'confirme seus dados', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'valide sua conta', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'recadastramento', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'dados bancarios', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'dados bancários', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'cvv', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'numero do cartao', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'assinatura eletronica', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'chave de seguranca', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'DADO_SENSIVEL'), 'senha de 4 digitos', FALSE, 'Sugerido - revisar antes de ativar');

-- ISCA_FINANCEIRA
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao) VALUES
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'voce ganhou', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'você ganhou', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'premio', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'prêmio', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'sorteio', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'heranca', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'herança', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'restituicao', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'restituição', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'reembolso', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'milhoes', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'milhões', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'oferta exclusiva', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'gratis', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'grátis', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ISCA_FINANCEIRA'), 'sorteado', TRUE, NULL);

-- SAUDACAO_GENERICA
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao) VALUES
    ((SELECT id FROM indicador WHERE codigo = 'SAUDACAO_GENERICA'), 'prezado cliente', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'SAUDACAO_GENERICA'), 'caro usuario', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'SAUDACAO_GENERICA'), 'caro usuário', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'SAUDACAO_GENERICA'), 'prezado usuario', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'SAUDACAO_GENERICA'), 'prezado usuário', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'SAUDACAO_GENERICA'), 'caro cliente', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'SAUDACAO_GENERICA'), 'prezado(a) cliente', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'SAUDACAO_GENERICA'), 'estimado cliente', FALSE, 'Sugerido - revisar antes de ativar');

-- MARCA_CONHECIDA
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao) VALUES
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'banco do brasil', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'bradesco', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'itau', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'itaú', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'santander', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'caixa', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'nubank', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'receita federal', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'serasa', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'correios', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'netflix', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'mercado livre', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'magalu', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'americanas', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'ford', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'microsoft', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'google', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'inter', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'c6', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'sicredi', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'banrisul', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'safra', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'pagbank', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'picpay', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'mercado pago', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'gov.br', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'MARCA_CONHECIDA'), 'shopee', FALSE, 'Sugerido - revisar antes de ativar');

-- DOMINIO_GRATUITO
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao) VALUES
    ((SELECT id FROM indicador WHERE codigo = 'DOMINIO_GRATUITO'), 'gmail.com', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DOMINIO_GRATUITO'), 'hotmail.com', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DOMINIO_GRATUITO'), 'outlook.com', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DOMINIO_GRATUITO'), 'yahoo.com', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DOMINIO_GRATUITO'), 'bol.com.br', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DOMINIO_GRATUITO'), 'uol.com.br', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DOMINIO_GRATUITO'), 'live.com', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DOMINIO_GRATUITO'), 'protonmail.com', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'DOMINIO_GRATUITO'), 'yahoo.com.br', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'DOMINIO_GRATUITO'), 'icloud.com', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'DOMINIO_GRATUITO'), 'proton.me', FALSE, 'Sugerido - revisar antes de ativar');

-- ENCURTADOR_URL
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao) VALUES
    ((SELECT id FROM indicador WHERE codigo = 'ENCURTADOR_URL'), 'bit.ly', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ENCURTADOR_URL'), 'tinyurl.com', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ENCURTADOR_URL'), 'goo.gl', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ENCURTADOR_URL'), 't.co', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ENCURTADOR_URL'), 'is.gd', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ENCURTADOR_URL'), 'ow.ly', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ENCURTADOR_URL'), 'cutt.ly', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ENCURTADOR_URL'), 'rebrand.ly', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ENCURTADOR_URL'), 'encurtador.com.br', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'ENCURTADOR_URL'), 'shorturl.at', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'ENCURTADOR_URL'), 'rb.gy', FALSE, 'Sugerido - revisar antes de ativar');

-- TLD_SUSPEITO
INSERT INTO palavra_chave (indicador_id, termo, ativo, observacao) VALUES
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.xyz', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.top', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.click', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.zip', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.review', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.country', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.tk', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.ml', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.ga', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.cf', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.gq', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.work', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.fit', TRUE, NULL),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.mov', FALSE, 'Sugerido - revisar antes de ativar'),
    ((SELECT id FROM indicador WHERE codigo = 'TLD_SUSPEITO'), '.rest', FALSE, 'Sugerido - revisar antes de ativar');
