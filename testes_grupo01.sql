-- testes de integridade: todo comando deste arquivo tem que dar ERRO
-- rodar depois do 04 e do 05, com: mysql -u root -p --force < 07_testes_integridade.sql
-- (o --force faz o mysql continuar depois de cada erro e mostrar todos)
USE murbach_music_school;
-- modo estrito (padrao do MySQL 8): recusa data invalida, texto em numero e texto grande demais
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE';

-- chave primaria repetida

-- T01: pessoa com CPF que ja existe
INSERT INTO pessoa (cpf, nome, data_nascimento, sobrenome) VALUES ('11111111111', 'Outra', '2000-01-01', 'Pessoa');

-- T02: mesmo telefone para a mesma pessoa
INSERT INTO telefone (ddd, ddl, numero_tel, cpf) VALUES ('11', '55', '912345678', '11111111111');

-- T03: mesma vaga (data + cargo) duas vezes
INSERT INTO vaga (data, id_cargo, qtde_vagas, status) VALUES ('2025-01-05', 1, 3, 'ABERTO');

-- T04: presenca repetida (mesma matricula e mesma aula)
INSERT INTO presenca (id_matricula, cod_aula, data_registro, status_presenca) VALUES (1, 101, '2026-10-07', 'PRESENTE');

-- T05: mesmo pagamento conciliado duas vezes
INSERT INTO conciliacao (id_pagamento, id_movimento, id_funcionario, valor_conciliado, data_conciliacao) VALUES (9, 8, 2, 650.00, '2026-11-01');

-- T06: segundo atestado na mesma data
INSERT INTO atestado_medico (data, id_funcionario, crm_medico, cid, data_emissão, dias_afastados) VALUES ('2026-10-19', 2, 'CRM-SP 999', NULL, '2026-10-19', 1);

-- T07: e-mail que ja existe
INSERT INTO email (endereco_email, cpf, provedor_email, tipo_email) VALUES ('ana.souza@murbach.com.br', '22222222222', 'murbach.com.br', 'PESSOAL');

-- campo obrigatorio vazio (NOT NULL)

-- T08: pessoa sem nome
INSERT INTO pessoa (cpf, nome, data_nascimento, sobrenome) VALUES ('77777777777', NULL, '2000-01-01', 'Silva');

-- T09: cobranca sem valor
INSERT INTO cobranca (id_produto, data_emissao, valor, vencimento_cobranca) VALUES (1, '2026-11-01', NULL, '2026-11-10');

-- T10: aula sem professor
INSERT INTO aula (id_matricula, rmsp, num_sala, rms, id_curso, data_aula, hora_inicio, hora_fim) VALUES (1, NULL, 1, 'A000000000001', 1, '2026-11-11', '14:00', '15:00');

-- T11: pagamento sem forma de pagamento
INSERT INTO pagamento (id_receita, forma_pagamento, valor, data_hora_pagamento) VALUES (2, NULL, 10.00, '2026-11-01 10:00');

-- T12: movimento sem descricao
INSERT INTO movimento_financeiro (tipo, fonte, data_movimento, valor, descricao) VALUES ('ENTRADA', 'BANCO', '2026-11-01', 10.00, NULL);

-- chave estrangeira

-- T13: endereco de pessoa que nao existe
INSERT INTO endereco (cep, cpf, logradouro, numero, bairro) VALUES ('99999999', '99999999999', 'Rua A', '10', 'Centro');

-- T14: matricula de aluno que nao existe
INSERT INTO matricula (rms, id_curso, data_matricula, valor_contratado, dia_combinado) VALUES ('A999999999999', 1, '2026-11-01', 300.00, 10);

-- T15: aula em sala que nao existe
INSERT INTO aula (id_matricula, rmsp, num_sala, rms, id_curso, data_aula, hora_inicio, hora_fim) VALUES (1, 'P000000000001', 9, 'A000000000001', 1, '2026-11-11', '14:00', '15:00');

-- T16: cobranca de folha que nao existe
INSERT INTO cobranca (mes_ano, id_funcionario, data_emissao, valor, vencimento_cobranca) VALUES ('2026-12-01', 1, '2026-11-01', 100.00, '2026-11-10');

-- T17: pagamento em despesa que nao existe
INSERT INTO pagamento (id_cobranca, id_despesa, forma_pagamento, valor, data_hora_pagamento) VALUES (2, 99, 'PIX', 4500.00, '2026-11-05 10:00');

-- T18: funcionario com cargo que nao existe
UPDATE funcionarios SET id_cargo = 99 WHERE id_funcionario = 1;

-- T19: conciliacao feita por funcionario que nao existe
INSERT INTO conciliacao (id_pagamento, id_movimento, id_funcionario, valor_conciliado, data_conciliacao) VALUES (15, 15, 9, 39.90, '2026-11-01');

-- T20: apagar fornecedor que tem contas
DELETE FROM fornecedor WHERE cnpj = '10000000000101';

-- T21: apagar matricula que tem mensalidades e aulas
DELETE FROM matricula WHERE id_matricula = 1;

-- T22: trocar o codigo de um curso que tem matriculas
UPDATE curso SET id_curso = 99 WHERE id_curso = 1;

-- T23: apagar pessoa que e aluna
DELETE FROM pessoa WHERE cpf = '44444444444';

-- T24: reposicao de uma aula que nao existe
INSERT INTO reposicao (cod_aula, data_solicitacao, data_reposicao, hora_inicio, hora_fim, motivo) VALUES (999, '2026-11-01', '2026-11-05', '14:00', '15:00', 'Teste');

-- valor unico (UNIQUE)

-- T25: dois fornecedores com o mesmo nome
INSERT INTO fornecedor (cnpj, nome_empresa, tipo_empresa, data_cadastro) VALUES ('99999999000199', 'Imobiliária Centro Ltda', 'IMOBILIÁRIA', '2026-11-01');

-- T26: dois alunos com o mesmo CPF
INSERT INTO aluno (rms, cpf, data_matricula, status_aluno) VALUES ('A000000000009', '44444444444', '2026-11-01', 'ATIVO');

-- T27: duas folhas do mesmo funcionario no mesmo mes
INSERT INTO folha_pagamento (mes_ano, id_funcionario, id_contrato, total_beneficio, total_horas_trabalhadas, valor_total_bruto, valor_desconto, valor_liquido) VALUES ('2026-10-01', 1, 1, 924.00, 168, 3000.00, 390.00, 2610.00);

-- T28: segunda cobranca da mesma conta mensal
INSERT INTO cobranca (id_conta, data_emissao, valor, vencimento_cobranca) VALUES (2, '2026-11-01', 4500.00, '2026-11-05');

-- T29: segunda cobranca da mesma folha
INSERT INTO cobranca (mes_ano, id_funcionario, data_emissao, valor, vencimento_cobranca) VALUES ('2026-10-01', 1, '2026-11-01', 2610.00, '2026-11-09');

-- T30: segunda cobranca do mesmo registro de horas
INSERT INTO cobranca (id_registro_horas, data_emissao, valor, vencimento_cobranca) VALUES (1, '2026-11-01', 560.00, '2026-11-05');

-- T31: segunda desistencia da mesma matricula
INSERT INTO devolucao (id_matricula, data_desistencia, motivo) VALUES (3, '2026-11-01', 'Teste');

-- T32: segunda taxa de adesao da mesma matricula
INSERT INTO taxa_de_adesao (id_matricula, valor, vencimento) VALUES (1, 90.00, '2026-11-01');

-- T33: duas mensalidades da mesma matricula no mesmo mes
INSERT INTO mensalidade (id_matricula, mes_referencia, ano_referencia, vencimento) VALUES (1, 11, 2026, '2026-11-15');

-- T34: matricula repetida (mesmo aluno, curso e data)
INSERT INTO matricula (rms, id_curso, data_matricula, valor_contratado, dia_combinado) VALUES ('A000000000001', 1, '2026-09-20', 300.00, 10);

-- T35: duas despesas da mesma categoria no mesmo mes
INSERT INTO despesa (categoria, periodo) VALUES ('ALUGUEL', '2026-10-01');

-- T36: duas receitas da mesma categoria no mesmo mes
INSERT INTO receita (catergoria, periodo) VALUES ('MENSALIDADES', '2026-10-01');

-- T37: dois registros de horas do mesmo professor no mesmo mes
INSERT INTO registro_hora_professor (rmsp, mes_referencia, ano_referencia) VALUES ('P000000000001', 10, 2026);

-- T38: segunda reposicao da mesma aula cancelada
INSERT INTO reposicao (cod_aula, data_solicitacao, data_reposicao, hora_inicio, hora_fim, motivo) VALUES (103, '2026-10-21', '2026-10-30', '14:00', '15:00', 'Teste');

-- T39: segundo contrato para o mesmo processo seletivo
INSERT INTO contrato_trabalho (id_processo, cpf, tipo_contrato, cnpj_mei, dados_bancarios, documentacao, carga_horaria_mensal_clt, valor_hora_cnpj_mei, status, data_admissao) VALUES (1, '11111111111', 'CLT', NULL, 'x', 'x', 220, NULL, 'ATIVO', '2026-11-01');

-- T40: dois funcionarios com o mesmo contrato
INSERT INTO funcionarios (id_cargo, id_contrato, cpf, status) VALUES (1, 1, '33333333333', 'ATIVO');

-- T41: dois professores com o mesmo CPF
INSERT INTO professor (rmsp, cpf, data_contratacao, especialidade, status_professor) VALUES ('P000000000009', '33333333333', '2026-11-01', 'Violão', 'ATIVO');

-- T42: dois cursos com o mesmo nome
INSERT INTO curso (nome_curso, carga_horaria, mensalidade, nivel, status_curso) VALUES ('Violão', 48, 300.00, 'BÁSICO', 'ATIVO');

-- valor fora da lista (CHECK IN)

-- T43: tipo de instrumento fora da lista
UPDATE instrumento SET tipo_instrumento = 'ELETRÔNICO' WHERE id_instrumento = 1;

-- T44: situacao de cobranca fora da lista
UPDATE cobranca SET status_cobranca = 'QUITADO' WHERE id_cobranca = 2;

-- T45: forma de pagamento fora da lista
UPDATE pagamento SET forma_pagamento = 'CHEQUE' WHERE id_pagamento = 15;

-- T46: categoria de despesa fora da lista
INSERT INTO despesa (categoria, periodo) VALUES ('ALUGUEL DO MÊS', '2026-11-01');

-- T47: tipo de divergencia fora da lista
UPDATE divergencia SET tipo_divergencia = 'OUTRO' WHERE id_divergencia = 2;

-- T48: situacao do aluno usada na matricula
UPDATE matricula SET status_matricula = 'TRANCADO' WHERE id_matricula = 1;

-- T49: situacao em letra minuscula
UPDATE mensalidade SET status = 'pago' WHERE id_mensalidade = 1;

-- T50: tipo de conta sem acento
INSERT INTO conta_mensais (cnpj, tipo_conta, emissão_conta) VALUES ('10000000000202', 'AGUA', '2026-11-01');

-- T51: fonte de movimento fora da lista
UPDATE movimento_financeiro SET fonte = 'CARTEIRA' WHERE id_movimento = 1;

-- T52: situacao de aula fora da lista
UPDATE aula SET situacao_aula = 'ADIADA' WHERE cod_aula = 115;

-- valor fora da faixa (CHECK)

-- T53: cobranca com valor negativo
UPDATE cobranca SET valor = -10.00 WHERE id_cobranca = 2;

-- T54: presenca com situacao fora da lista
UPDATE presenca SET status_presenca = 'ATRASADO' WHERE id_matricula = 1 AND cod_aula = 101;

-- T55: dia combinado 31
UPDATE matricula SET dia_combinado = 31 WHERE id_matricula = 1;

-- T56: mes de referencia 13
INSERT INTO mensalidade (id_matricula, mes_referencia, ano_referencia, vencimento) VALUES (1, 13, 2026, '2026-12-10');

-- T57: produto com quantidade zero
UPDATE produto SET qtde = 0 WHERE id_produto = 1;

-- T58: folha com mes_ano que nao e o primeiro dia do mes
INSERT INTO folha_pagamento (mes_ano, id_funcionario, id_contrato, total_beneficio, total_horas_trabalhadas, valor_total_bruto, valor_desconto, valor_liquido) VALUES ('2026-11-15', 2, 2, 660.00, 176, 3500.00, 490.00, 3010.00);

-- T59: despesa com periodo que nao e o primeiro dia do mes
INSERT INTO despesa (categoria, periodo) VALUES ('ALUGUEL', '2026-11-10');

-- T60: valor liquido diferente do bruto menos o desconto
UPDATE folha_pagamento SET valor_liquido = 5000.00 WHERE mes_ano = '2026-09-01' AND id_funcionario = 1;

-- T61: aula que termina na mesma hora em que comeca
UPDATE aula SET hora_fim = '14:00' WHERE cod_aula = 115;

-- T62: cobranca que vence antes de ser emitida
UPDATE cobranca SET vencimento_cobranca = '2026-10-01' WHERE id_cobranca = 2;

-- T63: desligamento antes da admissao
UPDATE contrato_trabalho SET data_desligamento = '2024-01-01' WHERE id_contrato = 1;

-- T64: saida do ponto antes da entrada
UPDATE registro_ponto SET data_hora_saida = '2026-10-01 07:00' WHERE id_ponto = 1;

-- T65: instrumento devolvido antes de ser emprestado
UPDATE aluno_instrumento SET data_fim = '2026-09-01' WHERE rms = 'A000000000001' AND id_instrumento = 1;

-- T66: divergencia resolvida antes de ser aberta
UPDATE divergencia SET data_resolucao = '2026-10-01', resolucao = 'x' WHERE id_divergencia = 2;

-- T67: atestado com zero dias
UPDATE atestado_medico SET dias_afastados = 0 WHERE id_funcionario = 1;

-- T68: sala com capacidade zero
UPDATE sala SET capacidade = 0 WHERE num_sala = 1;

-- regras entre colunas (CHECK)

-- T69: cobranca com duas origens
INSERT INTO cobranca (id_produto, id_servicos, data_emissao, valor, vencimento_cobranca) VALUES (1, 1, '2026-11-01', 100.00, '2026-11-10');

-- T70: cobranca sem origem
INSERT INTO cobranca (data_emissao, valor, vencimento_cobranca) VALUES ('2026-11-01', 100.00, '2026-11-10');

-- T71: pagamento com despesa e receita
INSERT INTO pagamento (id_cobranca, id_despesa, id_receita, forma_pagamento, valor, data_hora_pagamento) VALUES (2, 1, 2, 'PIX', 10.00, '2026-11-01 10:00');

-- T72: pagamento sem despesa e sem receita
INSERT INTO pagamento (forma_pagamento, valor, data_hora_pagamento) VALUES ('PIX', 10.00, '2026-11-01 10:00');

-- T73: pagamento de saida sem cobranca
INSERT INTO pagamento (id_despesa, forma_pagamento, valor, data_hora_pagamento) VALUES (1, 'PIX', 10.00, '2026-11-01 10:00');

-- T74: pagamento de entrada com cobranca
INSERT INTO pagamento (id_cobranca, id_receita, forma_pagamento, valor, data_hora_pagamento) VALUES (2, 2, 'PIX', 10.00, '2026-11-01 10:00');

-- T75: taxa de adesao em pagamento de saida
INSERT INTO pagamento (id_cobranca, id_despesa, id_taxa, forma_pagamento, valor, data_hora_pagamento) VALUES (2, 1, 1, 'PIX', 90.00, '2026-11-01 10:00');

-- T76: trocar uma saida para entrada sem tirar a cobranca
UPDATE pagamento SET id_despesa = NULL, id_receita = 2 WHERE id_pagamento = 5;

-- T77: mudar a coluna gerada tipo na mao
UPDATE pagamento SET tipo = 'SAÍDA' WHERE id_pagamento = 1;

-- T78: contrato CLT com valor de hora de PJ
UPDATE contrato_trabalho SET valor_hora_cnpj_mei = 50.00 WHERE id_contrato = 1;

-- T79: contrato CNPJ sem CNPJ
UPDATE contrato_trabalho SET cnpj_mei = NULL WHERE id_contrato = 3;

-- T80: aula realizada com quem cancelou preenchido
INSERT INTO aula (id_matricula, rmsp, num_sala, rms, id_curso, data_aula, hora_inicio, hora_fim, situacao_aula, cancelada_por) VALUES (1, 'P000000000001', 1, 'A000000000001', 1, '2026-11-11', '14:00', '15:00', 'REALIZADA', 'ALUNO');

-- T81: aula cancelada sem dizer quem cancelou
UPDATE aula SET situacao_aula = 'CANCELADA' WHERE cod_aula = 115;

-- T82: aviso de cancelamento em aula que nao foi cancelada
UPDATE aula SET data_hora_aviso = '2026-11-03 10:00' WHERE cod_aula = 114;

-- T83: cobranca com o mes da folha mas sem o funcionario
INSERT INTO cobranca (mes_ano, data_emissao, valor, vencimento_cobranca) VALUES ('2026-10-01', '2026-11-01', 2610.00, '2026-11-09');

-- T84: contrato encerrado sem data de desligamento
UPDATE contrato_trabalho SET status = 'ENCERRADO' WHERE id_contrato = 1;

-- T85: divergencia de valor sem o movimento
INSERT INTO divergencia (id_pagamento, id_funcionario, tipo_divergencia, data_abertura) VALUES (14, 2, 'VALOR DIFERENTE', '2026-11-01');

-- T86: "pagamento sem movimento" com movimento preenchido
UPDATE divergencia SET id_movimento = 10 WHERE id_divergencia = 1;

-- T87: "movimento sem pagamento" com pagamento preenchido
UPDATE divergencia SET id_pagamento = 15 WHERE id_divergencia = 3;

-- T88: resolucao escrita sem data de resolucao
UPDATE divergencia SET resolucao = 'Corrigido' WHERE id_divergencia = 2;

-- T89: data de resolucao sem dizer como foi resolvida
UPDATE divergencia SET data_resolucao = '2026-11-01' WHERE id_divergencia = 3;

-- tipo de dado

-- T90: data que nao existe
INSERT INTO movimento_financeiro (tipo, fonte, data_movimento, valor, descricao) VALUES ('ENTRADA', 'BANCO', '2026-02-30', 10.00, 'teste');

-- T91: texto em campo numerico
INSERT INTO sala (num_sala, capacidade, tipo_sala, status_sala) VALUES (3, 'duas', 'Aula individual', 'DISPONÍVEL');

-- T92: nome maior que o tamanho da coluna
INSERT INTO pessoa (cpf, nome, data_nascimento, sobrenome) VALUES ('77777777777', 'Maria Eduarda Cristina', '2000-01-01', 'Silva');

-- T93: CPF com 12 digitos
INSERT INTO pessoa (cpf, nome, data_nascimento, sobrenome) VALUES ('777777777777', 'Maria', '2000-01-01', 'Silva');

-- tamanho exato de documentos

-- T94: CPF com 10 digitos
INSERT INTO pessoa (cpf, nome, data_nascimento, sobrenome) VALUES ('7777777777', 'Maria', '2000-01-01', 'Silva');

-- T95: CEP com 7 digitos
INSERT INTO endereco (cep, cpf, logradouro, numero, bairro) VALUES ('1234567', '11111111111', 'Rua A', '10', 'Centro');

-- T96: CNPJ com 13 digitos
INSERT INTO fornecedor (cnpj, nome_empresa, tipo_empresa, data_cadastro) VALUES ('1234567890123', 'Empresa Teste Ltda', 'PRESTADOR DE SERVIÇO', '2026-11-01');

-- T97: CNPJ do MEI com 13 digitos
UPDATE contrato_trabalho SET cnpj_mei = '2000000000010' WHERE id_contrato = 3;

-- outras regras

-- T98: contrato ativo com data de desligamento
UPDATE contrato_trabalho SET data_desligamento = '2026-10-31' WHERE id_contrato = 1;

-- T99: reposicao que termina antes de comecar
UPDATE reposicao SET hora_fim = '14:00' WHERE id_reposicao = 1;

-- T100: situacao de devolucao fora da lista
UPDATE aluno_instrumento SET status_devolucao = 'ATRASADO' WHERE rms = 'A000000000001' AND id_instrumento = 1;
