USE murbach_music_school;

-- 1. aluguel de outubro: quanto, para quem, quando e situacao
SELECT f.nome_empresa, c.valor, c.vencimento_cobranca, c.status_cobranca, p.data_hora_pagamento, p.forma_pagamento
FROM cobranca c
JOIN conta_mensais cm ON cm.id_conta = c.id_conta
JOIN fornecedor f ON f.cnpj = cm.cnpj
JOIN pagamento p ON p.id_cobranca = c.id_cobranca
WHERE cm.tipo_conta = 'ALUGUEL'
AND c.vencimento_cobranca BETWEEN '2026-10-01' AND '2026-10-31';

-- 2. o que a escola precisa pagar de 02/11 a 09/11
SELECT id_cobranca, valor, vencimento_cobranca, status_cobranca
FROM cobranca
WHERE status_cobranca IN('EM ABERTO', 'EM ATRASO')
AND vencimento_cobranca BETWEEN '2026-11-02' AND '2026-11-09'
ORDER BY vencimento_cobranca;

-- 3. folha de setembro: bruto, liquido, descontos e pagamento do liquido
SELECT pe.nome, pe.sobrenome, ca.nome_cargo, fo.valor_total_bruto, fo.valor_liquido,
fo.valor_desconto,
c.vencimento_cobranca, c.status_cobranca, p.data_hora_pagamento
FROM folha_pagamento fo
JOIN funcionarios fu ON fu.id_funcionario = fo.id_funcionario
JOIN pessoa pe ON pe.cpf = fu.cpf
JOIN cargo ca ON ca.id_cargo = fu.id_cargo
JOIN cobranca c ON c.mes_ano = fo.mes_ano AND c.id_funcionario = fo.id_funcionario
JOIN pagamento p ON p.id_cobranca = c.id_cobranca
WHERE fo.mes_ano = '2026-09-01';

-- 3b. descontos da folha de setembro pagos ao orgao publico
SELECT f.nome_empresa, c.valor, c.vencimento_cobranca, c.status_cobranca
FROM cobranca c
JOIN conta_mensais cm ON cm.id_conta = c.id_conta
JOIN fornecedor f ON f.cnpj = cm.cnpj
WHERE cm.tipo_conta = 'DESCONTO';

SELECT SUM(valor_desconto) AS total_descontos
FROM folha_pagamento
WHERE mes_ano = '2026-09-01';

-- 4. professor PJ em outubro: horas das aulas dadas e valor da hora do contrato
SELECT pe.nome, ct.cnpj_mei, ct.valor_hora_cnpj_mei,
SUM(TIME_TO_SEC(TIMEDIFF(a.hora_fim, a.hora_inicio))) / 3600 AS horas_aulas
FROM aula a
JOIN professor pr ON pr.rmsp = a.rmsp
JOIN pessoa pe ON pe.cpf = pr.cpf
JOIN contrato_trabalho ct ON ct.cpf = pr.cpf
WHERE a.rmsp = 'P000000000001'
AND ct.tipo_contrato = 'CNPJ'
AND a.situacao_aula = 'REALIZADA'
AND a.data_aula BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY pe.nome, ct.cnpj_mei, ct.valor_hora_cnpj_mei;

-- 4a. horas das reposicoes dadas no mes (somadas as da consulta 4: 6 + 1 = 7)
SELECT SUM(TIME_TO_SEC(TIMEDIFF(r.hora_fim, r.hora_inicio))) / 3600 AS horas_reposicao
FROM reposicao r
JOIN aula a ON a.cod_aula = r.cod_aula
WHERE a.rmsp = 'P000000000001'
AND r.status_reposicao = 'REALIZADA'
AND r.data_reposicao BETWEEN '2026-10-01' AND '2026-10-31';

-- 4b. horas perdidas (desmarcou sem aviso ou avisou depois do inicio)
SELECT SUM(TIME_TO_SEC(TIMEDIFF(hora_fim, hora_inicio))) / 3600 AS horas_perdidas
FROM aula
WHERE rmsp = 'P000000000001'
AND situacao_aula = 'CANCELADA'
AND cancelada_por = 'PROFESSOR'
AND data_aula BETWEEN '2026-10-01' AND '2026-10-31'
AND (data_hora_aviso IS NULL OR data_hora_aviso > CONCAT(data_aula, ' ', hora_inicio));

-- 4c. cobranca gerada pelo registro de horas
SELECT rh.mes_referencia, rh.ano_referencia, c.valor, c.vencimento_cobranca, c.status_cobranca
FROM registro_hora_professor rh
JOIN cobranca c ON c.id_registro_horas = rh.id_registro_horas
WHERE rh.rmsp = 'P000000000001';

-- 5. aluna com violao e piano: mensalidades e situacao
SELECT cu.nome_curso, me.mes_referencia, me.vencimento, m.valor_contratado, me.valor_final, me.forma_pagamento_prevista, me.status
FROM mensalidade me
JOIN matricula m ON m.id_matricula = me.id_matricula
JOIN curso cu ON cu.id_curso = m.id_curso
WHERE m.rms = 'A000000000001'
ORDER BY me.mes_referencia, cu.nome_curso;

-- 5b. pagamentos de mensalidades recebidos em outubro (o de 575,00 quita violao 225,00 + piano 350,00)
SELECT p.id_pagamento, p.forma_pagamento, p.valor, p.data_hora_pagamento
FROM pagamento p
JOIN receita r ON r.id_receita = p.id_receita
WHERE r.catergoria = 'MENSALIDADES' AND r.periodo = '2026-10-01'
ORDER BY p.data_hora_pagamento;

-- 5c. faltas do professor em outubro sem reposicao (descontadas em novembro)
SELECT a.cod_aula, a.data_aula, a.cancelada_por
FROM aula a
LEFT JOIN reposicao r ON r.cod_aula = a.cod_aula
WHERE a.id_matricula = 1
AND a.cancelada_por = 'PROFESSOR'
AND a.data_aula BETWEEN '2026-10-01' AND '2026-10-31'
AND r.id_reposicao IS NULL;

-- valor da falta = valor contratado / aulas programadas em outubro
SELECT m.valor_contratado / COUNT(a.cod_aula) AS valor_da_falta
FROM aula a
JOIN matricula m ON m.id_matricula = a.id_matricula
WHERE a.id_matricula = 1
AND a.data_aula BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY m.valor_contratado;

-- 5d. presencas da aluna em outubro
SELECT cu.nome_curso, a.data_aula, pr.status_presenca
FROM presenca pr
JOIN aula a ON a.cod_aula = pr.cod_aula
JOIN matricula m ON m.id_matricula = pr.id_matricula
JOIN curso cu ON cu.id_curso = m.id_curso
WHERE m.rms = 'A000000000001'
ORDER BY a.data_aula;

-- 6. desistencia: matricula, motivo e valor a devolver
SELECT pe.nome, pe.sobrenome, cu.nome_curso, d.data_desistencia, d.motivo, m.status_matricula,
c.valor AS valor_a_devolver, c.vencimento_cobranca, c.status_cobranca
FROM devolucao d
JOIN matricula m ON m.id_matricula = d.id_matricula
JOIN aluno al ON al.rms = m.rms
JOIN pessoa pe ON pe.cpf = al.cpf
JOIN curso cu ON cu.id_curso = m.id_curso
JOIN cobranca c ON c.id_devolucao = d.id_devolucao;

-- 6b. mensalidades da matricula que desistiu (o recebido na cancelada e devolvido)
SELECT me.mes_referencia, me.status, me.valor_final
FROM mensalidade me
WHERE me.id_matricula = 3;

-- 7. conciliacao: cada pagamento com o movimento que o comprova
SELECT p.id_pagamento, p.tipo, p.forma_pagamento, p.valor, mv.fonte, mv.data_movimento, mv.descricao, co.valor_conciliado, pe.nome AS conferido_por
FROM conciliacao co
JOIN pagamento p ON p.id_pagamento = co.id_pagamento
JOIN movimento_financeiro mv ON mv.id_movimento = co.id_movimento
JOIN funcionarios fu ON fu.id_funcionario = co.id_funcionario
JOIN pessoa pe ON pe.cpf = fu.cpf
ORDER BY mv.data_movimento;

-- 7b. conferencia das regras: tipo igual e fonte certa pela forma (deve voltar vazio)
SELECT co.id_pagamento, co.id_movimento, p.tipo, mv.tipo, p.forma_pagamento, mv.fonte
FROM conciliacao co
JOIN pagamento p ON p.id_pagamento = co.id_pagamento
JOIN movimento_financeiro mv ON mv.id_movimento = co.id_movimento
WHERE p.tipo <> mv.tipo
OR (p.forma_pagamento = 'DINHEIRO' AND mv.fonte <> 'CAIXA')
OR (p.forma_pagamento = 'CARTÃO' AND mv.fonte <> 'OPERADORA')
OR (p.forma_pagamento IN('PIX', 'BOLETO', 'TRANSFERÊNCIA') AND mv.fonte <> 'BANCO');

-- 7c. pagamentos que ainda faltam conferir
SELECT p.id_pagamento, p.tipo, p.valor, p.data_hora_pagamento
FROM pagamento p
LEFT JOIN conciliacao co ON co.id_pagamento = p.id_pagamento
LEFT JOIN divergencia dv ON dv.id_pagamento = p.id_pagamento
WHERE co.id_pagamento IS NULL AND dv.id_divergencia IS NULL;

-- 7d. movimentos que ainda faltam conferir
SELECT mv.id_movimento, mv.tipo, mv.valor, mv.data_movimento
FROM movimento_financeiro mv
LEFT JOIN conciliacao co ON co.id_movimento = mv.id_movimento
LEFT JOIN divergencia dv ON dv.id_movimento = mv.id_movimento
WHERE co.id_movimento IS NULL AND dv.id_divergencia IS NULL;

-- 7e. divergencias abertas e responsavel
SELECT pe.nome AS responsavel, dv.id_divergencia, dv.tipo_divergencia, dv.data_abertura, dv.id_pagamento, dv.id_movimento
FROM divergencia dv
JOIN funcionarios fu ON fu.id_funcionario = dv.id_funcionario
JOIN pessoa pe ON pe.cpf = fu.cpf
WHERE dv.data_resolucao IS NULL;

-- 8. quanto a escola gastou e recebeu em outubro
SELECT d.categoria, SUM(p.valor) AS total
FROM despesa d
JOIN pagamento p ON p.id_despesa = d.id_despesa
WHERE d.periodo = '2026-10-01'
GROUP BY d.categoria;

SELECT r.catergoria, SUM(p.valor) AS total
FROM receita r
JOIN pagamento p ON p.id_receita = r.id_receita
WHERE r.periodo = '2026-10-01'
GROUP BY r.catergoria;

-- 9. ligacao entre as areas: aluno, curso, preco atual e preco contratado
SELECT pe.nome AS aluno, cu.nome_curso, cu.mensalidade AS preco_atual, m.valor_contratado, m.status_matricula
FROM matricula m
JOIN aluno al ON al.rms = m.rms
JOIN pessoa pe ON pe.cpf = al.cpf
JOIN curso cu ON cu.id_curso = m.id_curso;

-- 9b. instrumentos emprestados que ainda nao voltaram
SELECT pe.nome AS aluno, i.nome_instrumento, i.marca, i.modelo, ai.data_inicio, ai.data_fim, ai.nivel_pratico
FROM aluno_instrumento ai
JOIN aluno al ON al.rms = ai.rms
JOIN pessoa pe ON pe.cpf = al.cpf
JOIN instrumento i ON i.id_instrumento = ai.id_instrumento
WHERE ai.status_devolucao = 'PENDENTE';
