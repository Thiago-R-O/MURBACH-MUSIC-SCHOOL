USE murbach_music_school;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE';

INSERT INTO pessoa (cpf, nome, data_nascimento, sobrenome) VALUES
('11111111111', 'Ana', '1990-03-12', 'Souza'),
('22222222222', 'João', '1985-07-30', 'Lima'),
('33333333333', 'Carlos', '1982-11-05', 'Mendes'),
('44444444444', 'Beatriz', '2008-05-21', 'Rocha'),
('55555555555', 'Eduardo', '2005-01-14', 'Alves'),
('66666666666', 'Diana', '1993-09-18', 'Prado');

INSERT INTO endereco (cep, cpf, logradouro, numero, complemento, bairro) VALUES
('01310100', '11111111111', 'Avenida Paulista', '1000', 'Apto 52', 'Bela Vista'),
('04538133', '22222222222', 'Avenida Brigadeiro Faria Lima', '200', NULL, 'Itaim Bibi'),
('01310200', '33333333333', 'Avenida Paulista', '1500', 'Sala 3', 'Bela Vista'),
('04538132', '44444444444', 'Avenida Brigadeiro Faria Lima', '350', 'Casa 2', 'Itaim Bibi'),
('13015904', '55555555555', 'Rua Barão de Jaguara', '80', NULL, 'Centro'),
('01310300', '66666666666', 'Avenida Paulista', '900', NULL, 'Bela Vista');

INSERT INTO telefone (ddd, ddl, numero_tel, cpf) VALUES
('11', '55', '912345678', '11111111111'),
('11', '55', '923456789', '22222222222'),
('11', '55', '934567890', '44444444444'),
('11', '55', '945678901', '44444444444'),
('19', '55', '956789012', '55555555555');

INSERT INTO email (endereco_email, cpf, provedor_email, tipo_email) VALUES
('ana.souza@murbach.com.br', '11111111111', 'murbach.com.br', 'PROFISSIONAL'),
('joao.lima@murbach.com.br', '22222222222', 'murbach.com.br', 'PROFISSIONAL'),
('carlos.mendes@email.com', '33333333333', 'email.com', 'PESSOAL'),
('beatriz.rocha@email.com', '44444444444', 'email.com', 'PESSOAL'),
('eduardo.alves@email.com', '55555555555', 'email.com', 'PESSOAL');

INSERT INTO fornecedor (cnpj, nome_empresa, tipo_empresa, data_cadastro) VALUES
('10000000000101', 'Imobiliária Centro Ltda', 'IMOBILIÁRIA', '2025-01-10'),
('10000000000202', 'Energia Paulista S.A.', 'CONCESSIONÁRIA', '2025-01-10'),
('10000000000303', 'INSS - Previdência Social', 'ÓRGÃO PÚBLICO', '2025-01-10'),
('10000000000404', 'PagFácil Meios de Pagamento S.A.', 'OPERADORA DE CARTÃO', '2025-01-10'),
('10000000000505', 'Afina Pianos Serviços Ltda', 'PRESTADOR DE SERVIÇO', '2026-10-01'),
('10000000000606', 'Casa das Cordas Ltda', 'FORNECEDOR DE PRODUTO', '2026-10-01');

-- RH: do recrutamento ao contrato
INSERT INTO cargo (id_cargo, nome_cargo) VALUES
(1, 'Secretária'),
(2, 'Analista financeiro'),
(3, 'Professor de música');

INSERT INTO vaga (data, id_cargo, qtde_vagas, status) VALUES
('2025-01-05', 1, 1, 'FECHADO'),
('2025-01-05', 2, 1, 'FECHADO'),
('2025-01-05', 3, 2, 'FECHADO');

INSERT INTO recrutamento_selecao (id_processo, data, cpf, id_cargo, data_entrevista, status) VALUES
(1, '2025-01-05', '11111111111', 1, '2025-01-15', 'APROVADO'),
(2, '2025-01-05', '22222222222', 2, '2025-01-16', 'APROVADO'),
(3, '2025-01-05', '33333333333', 3, '2025-01-20', 'APROVADO'),
(4, '2025-01-05', '66666666666', 3, '2025-01-21', 'APROVADO');

INSERT INTO contrato_trabalho (id_contrato, id_processo, cpf, tipo_contrato, cnpj_mei, dados_bancarios, documentacao, carga_horaria_mensal_clt, valor_hora_cnpj_mei, status, data_admissao, data_desligamento) VALUES
(1, 1, '11111111111', 'CLT', NULL, 'Banco 001 Ag 1234 CC 11111-1', 'RG, CPF e CTPS entregues', 220, NULL, 'ATIVO', '2025-02-01', NULL),
(2, 2, '22222222222', 'CLT', NULL, 'Banco 341 Ag 4321 CC 22222-2', 'RG, CPF e CTPS entregues', 220, NULL, 'ATIVO', '2025-02-01', NULL),
(3, 3, '33333333333', 'CNPJ', '20000000000101', 'Banco 260 Ag 0001 CC 33333-3', 'Contrato social e cartão CNPJ', NULL, 80.00, 'ATIVO', '2025-02-01', NULL),
(4, 4, '66666666666', 'CNPJ', '20000000000202', 'Banco 077 Ag 0001 CC 44444-4', 'Contrato social e cartão CNPJ', NULL, 90.00, 'ATIVO', '2025-02-01', NULL);

INSERT INTO beneficio (id_beneficio, id_contrato, tipo_beneficio, valor_diario) VALUES
(1, 1, 'VALE-TRANSPORTE', 12.00),
(2, 1, 'VALE-REFEIÇÃO', 30.00),
(3, 2, 'VALE-REFEIÇÃO', 30.00);

INSERT INTO funcionarios (id_funcionario, id_cargo, id_contrato, cpf, status) VALUES
(1, 1, 1, '11111111111', 'ATIVO'),
(2, 2, 2, '22222222222', 'ATIVO');

INSERT INTO atestado_medico (data, id_funcionario, crm_medico, cid, data_emissão, dias_afastados) VALUES
('2026-10-19', 1, 'CRM-SP 123456', 'J11', '2026-10-19', 2);

INSERT INTO registro_ponto (id_ponto, id_funcionario, data_hora_entrada, data_hora_saida, total_horas) VALUES
(1, 1, '2026-10-01 08:00', '2026-10-01 17:00', 9),
(2, 1, '2026-10-02 08:00', '2026-10-02 17:00', 9),
(3, 2, '2026-10-01 09:00', '2026-10-01 18:00', 9);

-- valor_liquido = valor_total_bruto - valor_desconto
INSERT INTO folha_pagamento (mes_ano, id_funcionario, id_contrato, id_ponto, id_beneficio, total_beneficio, total_horas_trabalhadas, valor_total_bruto, valor_desconto, valor_liquido) VALUES
('2026-09-01', 1, 1, NULL, 1, 924.00, 176, 3000.00, 390.00, 2610.00),
('2026-09-01', 2, 2, NULL, 3, 660.00, 176, 3500.00, 490.00, 3010.00),
('2026-10-01', 1, 1, 1, 1, 924.00, 168, 3000.00, 390.00, 2610.00);

INSERT INTO professor (rmsp, cpf, data_contratacao, especialidade, status_professor) VALUES
('P000000000001', '33333333333', '2025-02-01', 'Violão e piano', 'ATIVO'),
('P000000000002', '66666666666', '2025-02-01', 'Guitarra', 'ATIVO');

-- aluno, instrumento, sala e curso
INSERT INTO aluno (rms, cpf, data_matricula, status_aluno) VALUES
('A000000000001', '44444444444', '2026-09-20', 'ATIVO'),
('A000000000002', '55555555555', '2026-09-01', 'INATIVO');

INSERT INTO instrumento (id_instrumento, nome_instrumento, marca, modelo, estado_conservacao, disponibilidade, descricao, porte_instrumento, tipo_instrumento) VALUES
(1, 'Violão', 'Giannini', 'GN-15', 'BOM', 'EMPRESTADO', 'Violão de náilon da escola', 'MÉDIO', 'CORDAS'),
(2, 'Guitarra', 'Tagima', 'TG-510', 'REGULAR', 'MANUTENÇÃO', 'Guitarra de estudo', 'MÉDIO', 'CORDAS'),
(3, 'Piano', 'Yamaha', 'P-45', 'NOVO', 'DISPONÍVEL', 'Piano digital da sala 2', 'GRANDE', 'TECLAS');

-- data_fim vazia: o instrumento ainda nao voltou
INSERT INTO aluno_instrumento (rms, id_instrumento, data_inicio, data_fim, nivel_pratico, status_devolucao) VALUES
('A000000000001', 1, '2026-09-20', NULL, 'INICIANTE', 'PENDENTE'),
('A000000000002', 2, '2026-09-01', '2026-10-22', 'INICIANTE', 'DEVOLVIDO');

INSERT INTO ocorrencia (id_ocorrencia, id_instrumento, rms, data_ocorrencia, status_ocorrencia, descricao) VALUES
(1, 2, 'A000000000002', '2026-10-22', 'ABERTA', 'Tarraxa quebrada na devolução');

INSERT INTO sala (num_sala, capacidade, tipo_sala, status_sala) VALUES
(1, 2, 'Aula individual', 'DISPONÍVEL'),
(2, 3, 'Sala de piano', 'DISPONÍVEL');

INSERT INTO curso (id_curso, nome_curso, descricao, carga_horaria, mensalidade, nivel, status_curso) VALUES
(1, 'Violão', 'Violão popular, aulas particulares semanais', 48, 300.00, 'BÁSICO', 'ATIVO'),
(2, 'Piano', 'Piano clássico e popular', 48, 350.00, 'BÁSICO', 'ATIVO'),
(3, 'Guitarra', 'Guitarra elétrica', 48, 280.00, 'BÁSICO', 'ATIVO');

-- Beatriz faz violao e piano; Eduardo fez guitarra e desistiu
INSERT INTO matricula (id_matricula, rms, id_curso, data_matricula, valor_contratado, dia_combinado, status_matricula) VALUES
(1, 'A000000000001', 1, '2026-09-20', 300.00, 10, 'ATIVO'),
(2, 'A000000000001', 2, '2026-09-20', 350.00, 10, 'ATIVO'),
(3, 'A000000000002', 3, '2026-09-01', 280.00, 5, 'INATIVO');

INSERT INTO taxa_de_adesao (id_taxa, id_matricula, valor, vencimento, situacao) VALUES
(1, 1, 90.00, '2026-09-20', 'PAGO'),
(2, 2, 90.00, '2026-09-20', 'PAGO'),
(3, 3, 90.00, '2026-09-01', 'PAGO');

-- a mensalidade 3 tem desconto de uma falta do professor (300 - 75)
INSERT INTO mensalidade (id_mensalidade, id_matricula, mes_referencia, ano_referencia, vencimento, valor_final, forma_pagamento_prevista, status) VALUES
(1, 1, 10, 2026, '2026-10-10', 300.00, 'PIX', 'PAGO'),
(2, 2, 10, 2026, '2026-10-10', 350.00, 'PIX', 'PAGO'),
(3, 1, 11, 2026, '2026-11-10', 225.00, 'PIX', 'PAGO'),
(4, 2, 11, 2026, '2026-11-10', 350.00, 'PIX', 'PAGO'),
(5, 3, 10, 2026, '2026-10-05', 280.00, 'PIX', 'PAGO'),
(6, 3, 11, 2026, '2026-11-05', 280.00, 'PIX', 'CANCELADA');

-- aula 102: falta do professor com aviso, sem reposicao (vira desconto)
-- aula 103: professor avisou depois do inicio, reposta em 23/10
INSERT INTO aula (cod_aula, id_matricula, rmsp, num_sala, rms, id_curso, data_aula, hora_inicio, hora_fim, conteudo, situacao_aula, cancelada_por, data_hora_aviso) VALUES
(101, 1, 'P000000000001', 1, 'A000000000001', 1, '2026-10-07', '14:00', '15:00', 'Acordes maiores', 'REALIZADA', NULL, NULL),
(102, 1, 'P000000000001', 1, 'A000000000001', 1, '2026-10-14', '14:00', '15:00', NULL, 'CANCELADA', 'PROFESSOR', '2026-10-13 18:00'),
(103, 1, 'P000000000001', 1, 'A000000000001', 1, '2026-10-21', '14:00', '15:00', NULL, 'CANCELADA', 'PROFESSOR', '2026-10-21 14:30'),
(105, 1, 'P000000000001', 1, 'A000000000001', 1, '2026-10-28', '14:00', '15:00', 'Dedilhado', 'REALIZADA', NULL, NULL),
(106, 2, 'P000000000001', 2, 'A000000000001', 2, '2026-10-06', '16:00', '17:00', 'Escalas', 'REALIZADA', NULL, NULL),
(107, 2, 'P000000000001', 2, 'A000000000001', 2, '2026-10-13', '16:00', '17:00', 'Escalas', 'REALIZADA', NULL, NULL),
(108, 2, 'P000000000001', 2, 'A000000000001', 2, '2026-10-20', '16:00', '17:00', 'Leitura', 'REALIZADA', NULL, NULL),
(109, 2, 'P000000000001', 2, 'A000000000001', 2, '2026-10-27', '16:00', '17:00', 'Leitura', 'REALIZADA', NULL, NULL),
(110, 3, 'P000000000002', 1, 'A000000000002', 3, '2026-10-01', '18:00', '19:00', 'Pentatônica', 'REALIZADA', NULL, NULL),
(111, 3, 'P000000000002', 1, 'A000000000002', 3, '2026-10-08', '18:00', '19:00', 'Pentatônica', 'REALIZADA', NULL, NULL),
(112, 3, 'P000000000002', 1, 'A000000000002', 3, '2026-10-15', '18:00', '19:00', 'Bends', 'REALIZADA', NULL, NULL),
(113, 3, 'P000000000002', 1, 'A000000000002', 3, '2026-10-22', '18:00', '19:00', 'Bends', 'REALIZADA', NULL, NULL),
(114, 2, 'P000000000001', 2, 'A000000000001', 2, '2026-11-03', '16:00', '17:00', NULL, 'PREVISTA', NULL, NULL),
(115, 1, 'P000000000001', 1, 'A000000000001', 1, '2026-11-04', '14:00', '15:00', NULL, 'PREVISTA', NULL, NULL);

INSERT INTO presenca (id_matricula, cod_aula, data_registro, status_presenca, observacao) VALUES
(1, 101, '2026-10-07', 'PRESENTE', NULL),
(1, 105, '2026-10-28', 'PRESENTE', NULL),
(2, 106, '2026-10-06', 'PRESENTE', NULL),
(2, 107, '2026-10-13', 'PRESENTE', NULL),
(2, 108, '2026-10-20', 'PRESENTE', NULL),
(2, 109, '2026-10-27', 'PRESENTE', NULL),
(3, 110, '2026-10-01', 'PRESENTE', NULL),
(3, 111, '2026-10-08', 'PRESENTE', NULL),
(3, 112, '2026-10-15', 'PRESENTE', NULL),
(3, 113, '2026-10-22', 'AUSENTE', 'Aluno não compareceu');

INSERT INTO reposicao (id_reposicao, cod_aula, data_solicitacao, data_reposicao, hora_inicio, hora_fim, motivo, status_reposicao) VALUES
(1, 103, '2026-10-21', '2026-10-23', '15:00', '16:00', 'Professor desmarcou depois do início da aula', 'REALIZADA');

INSERT INTO devolucao (id_devolucao, id_matricula, data_desistencia, motivo) VALUES
(1, 3, '2026-10-25', 'Mudança de cidade');

-- contas a pagar
INSERT INTO conta_mensais (id_conta, cnpj, tipo_conta, emissão_conta) VALUES
(1, '10000000000101', 'ALUGUEL', '2026-09-25'),
(2, '10000000000101', 'ALUGUEL', '2026-10-25'),
(3, '10000000000303', 'DESCONTO', '2026-10-01'),
(4, '10000000000202', 'ENERGIA', '2026-10-01'),
(5, '10000000000404', 'TARIFA', '2026-10-10');

INSERT INTO servicos (id_servicos, cnpj, tipo_servico, data_hora_realizada) VALUES
(1, '10000000000505', 'Afinação e regulagem de pianos', '2026-10-16 09:00');

INSERT INTO produto (id_produto, cnpj, tipo_produto, qtde, data_hora_entrega) VALUES
(1, '10000000000606', 'Jogo de cordas de náilon para violão', 20, '2026-10-29 14:00');

INSERT INTO registro_hora_professor (id_registro_horas, rmsp, mes_referencia, ano_referencia) VALUES
(1, 'P000000000001', 10, 2026),
(2, 'P000000000002', 10, 2026);

-- cobrancas 9 e 10 sao as duas parcelas do servico
-- cobranca 12 = 7 horas x 80,00 e cobranca 13 = 4 horas x 90,00
INSERT INTO cobranca (id_cobranca, mes_ano, id_funcionario, id_produto, id_servicos, id_conta, id_registro_horas, id_devolucao, data_emissao, valor, vencimento_cobranca, status_cobranca) VALUES
(1, NULL, NULL, NULL, NULL, 1, NULL, NULL, '2026-09-25', 4500.00, '2026-10-05', 'PAGO'),
(2, NULL, NULL, NULL, NULL, 2, NULL, NULL, '2026-10-25', 4500.00, '2026-11-05', 'EM ABERTO'),
(3, '2026-09-01', 1, NULL, NULL, NULL, NULL, NULL, '2026-09-30', 2610.00, '2026-10-07', 'PAGO'),
(4, '2026-09-01', 2, NULL, NULL, NULL, NULL, NULL, '2026-09-30', 3010.00, '2026-10-07', 'PAGO'),
(5, '2026-10-01', 1, NULL, NULL, NULL, NULL, NULL, '2026-10-31', 2610.00, '2026-11-09', 'EM ABERTO'),
(6, NULL, NULL, NULL, NULL, 3, NULL, NULL, '2026-10-01', 880.00, '2026-10-20', 'PAGO'),
(7, NULL, NULL, NULL, NULL, 4, NULL, NULL, '2026-10-01', 312.40, '2026-10-15', 'PAGO'),
(8, NULL, NULL, NULL, NULL, 5, NULL, NULL, '2026-10-10', 16.25, '2026-10-10', 'PAGO'),
(9, NULL, NULL, NULL, 1, NULL, NULL, NULL, '2026-10-16', 600.00, '2026-10-16', 'PAGO'),
(10, NULL, NULL, NULL, 1, NULL, NULL, NULL, '2026-10-16', 600.00, '2026-11-16', 'EM ABERTO'),
(11, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-10-29', 180.00, '2026-10-29', 'PAGO'),
(12, NULL, NULL, NULL, NULL, NULL, 1, NULL, '2026-10-31', 560.00, '2026-11-05', 'EM ABERTO'),
(13, NULL, NULL, NULL, NULL, NULL, 2, NULL, '2026-10-31', 360.00, '2026-11-05', 'EM ABERTO'),
(14, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-10-25', 280.00, '2026-11-04', 'EM ABERTO');

INSERT INTO despesa (id_despesa, categoria, periodo) VALUES
(1, 'ALUGUEL', '2026-10-01'),
(2, 'FOLHA DE PAGAMENTO', '2026-10-01'),
(3, 'TARIFAS FINANCEIRAS', '2026-10-01'),
(4, 'ENERGIA', '2026-10-01'),
(5, 'DESCONTOS DA FOLHA', '2026-10-01'),
(6, 'SERVIÇOS', '2026-10-01'),
(7, 'PRODUTOS', '2026-10-01');

INSERT INTO receita (id_receita, catergoria, periodo) VALUES
(1, 'TAXA DE ADESÃO', '2026-09-01'),
(2, 'MENSALIDADES', '2026-10-01');

-- pagamento 8: Beatriz paga violao e piano de outubro no cartao
-- pagamento 14: Beatriz paga violao e piano de novembro de uma vez
INSERT INTO pagamento (id_pagamento, id_cobranca, id_despesa, id_receita, id_taxa, forma_pagamento, valor, data_hora_pagamento) VALUES
(1, NULL, NULL, 1, 1, 'PIX', 90.00, '2026-09-20 10:00'),
(2, NULL, NULL, 1, 2, 'PIX', 90.00, '2026-09-20 10:05'),
(3, NULL, NULL, 1, 3, 'PIX', 90.00, '2026-09-01 15:00'),
(4, NULL, NULL, 2, NULL, 'PIX', 280.00, '2026-10-05 09:30'),
(5, 1, 1, NULL, NULL, 'TRANSFERÊNCIA', 4500.00, '2026-10-05 10:00'),
(6, 3, 2, NULL, NULL, 'TRANSFERÊNCIA', 2610.00, '2026-10-07 09:00'),
(7, 4, 2, NULL, NULL, 'TRANSFERÊNCIA', 3010.00, '2026-10-07 09:05'),
(8, NULL, NULL, 2, NULL, 'CARTÃO', 650.00, '2026-10-10 11:00'),
(9, 8, 3, NULL, NULL, 'CARTÃO', 16.25, '2026-10-10 23:00'),
(10, 7, 4, NULL, NULL, 'BOLETO', 312.40, '2026-10-15 08:30'),
(11, 6, 5, NULL, NULL, 'BOLETO', 880.00, '2026-10-20 10:00'),
(12, NULL, NULL, 2, NULL, 'PIX', 280.00, '2026-10-20 19:00'),
(13, 9, 6, NULL, NULL, 'TRANSFERÊNCIA', 600.00, '2026-10-16 11:00'),
(14, NULL, NULL, 2, NULL, 'PIX', 575.00, '2026-10-30 20:00'),
(15, 11, 7, NULL, NULL, 'PIX', 180.00, '2026-10-29 15:00');

-- conciliacao
INSERT INTO movimento_financeiro (id_movimento, tipo, fonte, data_movimento, valor, descricao) VALUES
(1, 'ENTRADA', 'BANCO', '2026-09-01', 90.00, 'Pix recebido - Eduardo Alves'),
(2, 'ENTRADA', 'BANCO', '2026-09-20', 90.00, 'Pix recebido - Beatriz Rocha'),
(3, 'ENTRADA', 'BANCO', '2026-09-20', 90.00, 'Pix recebido - Beatriz Rocha'),
(4, 'ENTRADA', 'BANCO', '2026-10-05', 280.00, 'Pix recebido - Eduardo Alves'),
(5, 'SAÍDA', 'BANCO', '2026-10-05', 4500.00, 'TED - Imobiliária Centro'),
(6, 'SAÍDA', 'BANCO', '2026-10-07', 2610.00, 'TED salário - Ana Souza'),
(7, 'SAÍDA', 'BANCO', '2026-10-07', 3010.00, 'TED salário - João Lima'),
(8, 'ENTRADA', 'OPERADORA', '2026-10-10', 650.00, 'Venda crédito à vista - valor bruto'),
(9, 'SAÍDA', 'OPERADORA', '2026-10-10', 16.25, 'Taxa de desconto da venda'),
(10, 'SAÍDA', 'BANCO', '2026-10-15', 321.40, 'Pagamento de boleto - Energia Paulista'),
(11, 'SAÍDA', 'BANCO', '2026-10-20', 880.00, 'Pagamento de guia - INSS'),
(12, 'ENTRADA', 'BANCO', '2026-10-20', 280.00, 'Pix recebido - Eduardo Alves'),
(13, 'SAÍDA', 'BANCO', '2026-10-16', 600.00, 'TED - Afina Pianos'),
(14, 'ENTRADA', 'BANCO', '2026-10-30', 575.00, 'Pix recebido - Beatriz Rocha'),
(15, 'SAÍDA', 'BANCO', '2026-10-31', 39.90, 'Tarifa de manutenção de conta');

INSERT INTO conciliacao (id_pagamento, id_movimento, id_funcionario, valor_conciliado, data_conciliacao) VALUES
(3, 1, 2, 90.00, '2026-10-01'),
(1, 2, 2, 90.00, '2026-10-01'),
(2, 3, 2, 90.00, '2026-10-01'),
(4, 4, 2, 280.00, '2026-10-31'),
(5, 5, 2, 4500.00, '2026-10-31'),
(6, 6, 2, 2610.00, '2026-10-31'),
(7, 7, 2, 3010.00, '2026-10-31'),
(8, 8, 2, 650.00, '2026-10-31'),
(9, 9, 2, 16.25, '2026-10-31'),
(11, 11, 2, 880.00, '2026-10-31'),
(12, 12, 2, 280.00, '2026-10-31'),
(13, 13, 2, 600.00, '2026-10-31'),
(14, 14, 2, 575.00, '2026-10-31');

-- divergencia 1: Pix da Casa das Cordas que nao aparece no extrato
INSERT INTO divergencia (id_divergencia, id_pagamento, id_movimento, id_funcionario, tipo_divergencia, data_abertura, data_resolucao, resolucao) VALUES
(1, 15, NULL, 2, 'PAGAMENTO SEM MOVIMENTO', '2026-10-31', NULL, NULL),
(2, 10, 10, 2, 'VALOR DIFERENTE', '2026-10-31', NULL, NULL),
(3, NULL, 15, 2, 'MOVIMENTO SEM PAGAMENTO', '2026-10-31', NULL, NULL);
