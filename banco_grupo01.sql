DROP DATABASE IF EXISTS murbach_music_school;
CREATE DATABASE murbach_music_school COLLATE utf8mb4_0900_as_cs;
USE murbach_music_school;

CREATE TABLE pessoa (
cpf CHAR(11) NOT NULL PRIMARY KEY CHECK(CHAR_LENGTH(cpf) = 11),
nome VARCHAR(20) NOT NULL,
data_nascimento DATE NOT NULL,
sobrenome VARCHAR(80) NOT NULL);

CREATE TABLE endereco (
cep CHAR(8) NOT NULL PRIMARY KEY CHECK(CHAR_LENGTH(cep) = 8),
cpf CHAR(11) NOT NULL,
logradouro VARCHAR(100) NOT NULL,
numero VARCHAR(20) NOT NULL,
complemento VARCHAR(150) NULL,
bairro VARCHAR(60) NOT NULL,
FOREIGN KEY(cpf) REFERENCES pessoa(cpf));

CREATE TABLE telefone (
ddd VARCHAR(5) NOT NULL,
ddl VARCHAR(3) NOT NULL,
numero_tel VARCHAR(9) NOT NULL,
cpf CHAR(11) NOT NULL,
PRIMARY KEY(ddd, ddl, numero_tel, cpf),
FOREIGN KEY(cpf) REFERENCES pessoa(cpf));

CREATE TABLE email (
endereco_email VARCHAR(80) NOT NULL PRIMARY KEY,
cpf CHAR(11) NOT NULL,
provedor_email VARCHAR(15) NOT NULL,
tipo_email VARCHAR(12) NOT NULL CHECK(tipo_email IN('PESSOAL', 'PROFISSIONAL')),
FOREIGN KEY(cpf) REFERENCES pessoa(cpf));

CREATE TABLE fornecedor (
cnpj CHAR(14) NOT NULL PRIMARY KEY CHECK(CHAR_LENGTH(cnpj) = 14),
nome_empresa VARCHAR(150) NOT NULL UNIQUE,
tipo_empresa VARCHAR(30) NOT NULL,
data_cadastro DATE NOT NULL);

CREATE TABLE cargo (
id_cargo INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
nome_cargo VARCHAR(80) NOT NULL UNIQUE);

CREATE TABLE vaga (
data DATE NOT NULL,
id_cargo INTEGER NOT NULL,
qtde_vagas INTEGER NOT NULL CHECK(qtde_vagas > 0),
status VARCHAR(7) NOT NULL CHECK(status IN('ABERTO', 'FECHADO')),
PRIMARY KEY(data, id_cargo),
FOREIGN KEY(id_cargo) REFERENCES cargo(id_cargo));

CREATE TABLE recrutamento_selecao (
id_processo INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
data DATE NOT NULL,
cpf CHAR(11) NOT NULL,
id_cargo INTEGER NOT NULL,
data_entrevista DATE NOT NULL,
status VARCHAR(10) NOT NULL CHECK(status IN('EM ANÁLISE', 'APROVADO', 'REPROVADO')),
FOREIGN KEY(data, id_cargo) REFERENCES vaga(data, id_cargo),
FOREIGN KEY(cpf) REFERENCES pessoa(cpf));

CREATE TABLE contrato_trabalho (
id_contrato INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_processo INTEGER NOT NULL UNIQUE,
cpf CHAR(11) NOT NULL,
tipo_contrato VARCHAR(4) NOT NULL CHECK(tipo_contrato IN('CLT', 'CNPJ')),
cnpj_mei CHAR(14) NULL CHECK(CHAR_LENGTH(cnpj_mei) = 14),
dados_bancarios VARCHAR(255) NOT NULL,
documentacao VARCHAR(255) NOT NULL,
carga_horaria_mensal_clt INTEGER NULL CHECK(carga_horaria_mensal_clt > 0),
valor_hora_cnpj_mei DECIMAL(8,2) NULL CHECK(valor_hora_cnpj_mei > 0),
status VARCHAR(9) NOT NULL CHECK(status IN('ATIVO', 'ENCERRADO')),
data_admissao DATE NOT NULL,
data_desligamento DATE NULL,
CHECK((tipo_contrato = 'CLT' AND cnpj_mei IS NULL AND valor_hora_cnpj_mei IS NULL AND carga_horaria_mensal_clt IS NOT NULL)
   OR (tipo_contrato = 'CNPJ' AND cnpj_mei IS NOT NULL AND valor_hora_cnpj_mei IS NOT NULL AND carga_horaria_mensal_clt IS NULL)),
CHECK((status = 'ATIVO' AND data_desligamento IS NULL) OR (status = 'ENCERRADO' AND data_desligamento IS NOT NULL)),
CHECK(data_desligamento IS NULL OR data_desligamento >= data_admissao),
FOREIGN KEY(id_processo) REFERENCES recrutamento_selecao(id_processo),
FOREIGN KEY(cpf) REFERENCES pessoa(cpf));

CREATE TABLE beneficio (
id_beneficio INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_contrato INTEGER NOT NULL,
tipo_beneficio VARCHAR(60) NOT NULL,
valor_diario DECIMAL(10,2) NOT NULL CHECK(valor_diario > 0),
FOREIGN KEY(id_contrato) REFERENCES contrato_trabalho(id_contrato));

CREATE TABLE funcionarios (
id_funcionario INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_cargo INTEGER NOT NULL,
id_contrato INTEGER NOT NULL UNIQUE,
cpf CHAR(11) NOT NULL UNIQUE,
status VARCHAR(9) NOT NULL CHECK(status IN('ATIVO', 'AFASTADO', 'DESLIGADO')),
FOREIGN KEY(id_cargo) REFERENCES cargo(id_cargo),
FOREIGN KEY(id_contrato) REFERENCES contrato_trabalho(id_contrato),
FOREIGN KEY(cpf) REFERENCES pessoa(cpf));

CREATE TABLE atestado_medico (
data DATE NOT NULL PRIMARY KEY,
id_funcionario INTEGER NOT NULL,
crm_medico VARCHAR(20) NOT NULL,
cid VARCHAR(10) NULL,
data_emissão DATE NOT NULL,
dias_afastados INTEGER NOT NULL CHECK(dias_afastados > 0),
FOREIGN KEY(id_funcionario) REFERENCES funcionarios(id_funcionario));

CREATE TABLE registro_ponto (
id_ponto INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_funcionario INTEGER NOT NULL,
data_hora_entrada DATETIME NOT NULL,
data_hora_saida DATETIME NULL,
total_horas INTEGER NULL CHECK(total_horas >= 0),
CHECK(data_hora_saida IS NULL OR data_hora_saida > data_hora_entrada),
FOREIGN KEY(id_funcionario) REFERENCES funcionarios(id_funcionario));

CREATE TABLE folha_pagamento (
mes_ano DATE NOT NULL CHECK(DAY(mes_ano) = 1),
id_funcionario INTEGER NOT NULL,
id_contrato INTEGER NOT NULL,
id_ponto INTEGER NULL,
id_beneficio INTEGER NULL,
total_beneficio DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK(total_beneficio >= 0),
total_horas_trabalhadas INTEGER NULL CHECK(total_horas_trabalhadas >= 0),
valor_total_bruto DECIMAL(10,2) NOT NULL CHECK(valor_total_bruto > 0),
valor_desconto DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK(valor_desconto >= 0),
valor_liquido DECIMAL(10,2) NOT NULL CHECK(valor_liquido > 0),
CHECK(valor_liquido = valor_total_bruto - valor_desconto),
PRIMARY KEY(mes_ano, id_funcionario),
FOREIGN KEY(id_funcionario) REFERENCES funcionarios(id_funcionario),
FOREIGN KEY(id_contrato) REFERENCES contrato_trabalho(id_contrato),
FOREIGN KEY(id_ponto) REFERENCES registro_ponto(id_ponto),
FOREIGN KEY(id_beneficio) REFERENCES beneficio(id_beneficio));

CREATE TABLE professor (
rmsp CHAR(13) NOT NULL PRIMARY KEY,
cpf CHAR(11) NOT NULL UNIQUE,
data_contratacao DATE NOT NULL,
especialidade VARCHAR(80) NOT NULL,
status_professor VARCHAR(8) NOT NULL CHECK(status_professor IN('ATIVO', 'INATIVO', 'AFASTADO')),
FOREIGN KEY(cpf) REFERENCES pessoa(cpf));

CREATE TABLE aluno (
rms CHAR(13) NOT NULL PRIMARY KEY,
cpf CHAR(11) NOT NULL UNIQUE,
data_matricula DATE NOT NULL,
status_aluno VARCHAR(8) NOT NULL CHECK(status_aluno IN('ATIVO', 'INATIVO', 'TRANCADO')),
FOREIGN KEY(cpf) REFERENCES pessoa(cpf));

CREATE TABLE instrumento (
id_instrumento INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
nome_instrumento VARCHAR(40) NOT NULL,
marca VARCHAR(40) NOT NULL,
modelo VARCHAR(60) NOT NULL,
estado_conservacao VARCHAR(7) NOT NULL CHECK(estado_conservacao IN('NOVO', 'BOM', 'REGULAR', 'RUIM')),
disponibilidade VARCHAR(10) NOT NULL CHECK(disponibilidade IN('DISPONÍVEL', 'EMPRESTADO', 'MANUTENÇÃO')),
descricao VARCHAR(255) NULL,
porte_instrumento VARCHAR(7) NOT NULL CHECK(porte_instrumento IN('PEQUENO', 'MÉDIO', 'GRANDE')),
tipo_instrumento VARCHAR(10) NOT NULL CHECK(tipo_instrumento IN('CORDAS', 'TECLAS', 'SOPRO', 'PERCUSSÃO')));

CREATE TABLE aluno_instrumento (
rms CHAR(13) NOT NULL,
id_instrumento INTEGER NOT NULL,
data_inicio DATE NOT NULL,
data_fim DATE NULL,
nivel_pratico VARCHAR(13) NOT NULL CHECK(nivel_pratico IN('INICIANTE', 'INTERMEDIÁRIO', 'AVANÇADO')),
status_devolucao VARCHAR(9) NOT NULL DEFAULT 'PENDENTE' CHECK(status_devolucao IN('PENDENTE', 'DEVOLVIDO')),
CHECK(data_fim IS NULL OR data_fim >= data_inicio),
PRIMARY KEY(rms, id_instrumento),
FOREIGN KEY(rms) REFERENCES aluno(rms),
FOREIGN KEY(id_instrumento) REFERENCES instrumento(id_instrumento));

CREATE TABLE ocorrencia (
id_ocorrencia INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_instrumento INTEGER NOT NULL,
rms CHAR(13) NULL,
data_ocorrencia DATE NOT NULL,
status_ocorrencia VARCHAR(9) NOT NULL CHECK(status_ocorrencia IN('ABERTA', 'RESOLVIDA')),
descricao VARCHAR(255) NOT NULL,
FOREIGN KEY(id_instrumento) REFERENCES instrumento(id_instrumento),
FOREIGN KEY(rms) REFERENCES aluno(rms));

CREATE TABLE sala (
num_sala INTEGER NOT NULL PRIMARY KEY,
capacidade INTEGER NOT NULL CHECK(capacidade > 0),
tipo_sala VARCHAR(30) NOT NULL,
status_sala VARCHAR(10) NOT NULL CHECK(status_sala IN('DISPONÍVEL', 'MANUTENÇÃO')));

CREATE TABLE curso (
id_curso INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
nome_curso VARCHAR(80) NOT NULL UNIQUE,
descricao VARCHAR(255) NULL,
carga_horaria INTEGER NOT NULL CHECK(carga_horaria > 0),
mensalidade DECIMAL(10,2) NOT NULL CHECK(mensalidade > 0),
nivel VARCHAR(13) NOT NULL CHECK(nivel IN('BÁSICO', 'INTERMEDIÁRIO', 'AVANÇADO')),
status_curso VARCHAR(7) NOT NULL CHECK(status_curso IN('ATIVO', 'INATIVO')));

CREATE TABLE matricula (
id_matricula INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
rms CHAR(13) NOT NULL,
id_curso INTEGER NOT NULL,
data_matricula DATE NOT NULL,
valor_contratado DECIMAL(10,2) NOT NULL CHECK(valor_contratado > 0),
dia_combinado INTEGER NOT NULL CHECK(dia_combinado BETWEEN 1 AND 28),
status_matricula VARCHAR(9) NOT NULL DEFAULT 'ATIVO' CHECK(status_matricula IN('ATIVO', 'INATIVO', 'BLOQUEADO')),
UNIQUE(rms, id_curso, data_matricula),
FOREIGN KEY(rms) REFERENCES aluno(rms),
FOREIGN KEY(id_curso) REFERENCES curso(id_curso));

CREATE TABLE conta_mensais (
id_conta INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
cnpj CHAR(14) NOT NULL,
tipo_conta VARCHAR(10) NOT NULL CHECK(tipo_conta IN('ALUGUEL', 'ENERGIA', 'ÁGUA', 'DESCONTO', 'BENEFÍCIO', 'TARIFA', 'OUTROS')),
emissão_conta DATE NOT NULL,
FOREIGN KEY(cnpj) REFERENCES fornecedor(cnpj));

CREATE TABLE servicos (
id_servicos INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
cnpj CHAR(14) NOT NULL,
tipo_servico VARCHAR(80) NOT NULL,
data_hora_realizada DATETIME NOT NULL,
FOREIGN KEY(cnpj) REFERENCES fornecedor(cnpj));

CREATE TABLE produto (
id_produto INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
cnpj CHAR(14) NOT NULL,
tipo_produto VARCHAR(80) NOT NULL,
qtde INTEGER NOT NULL CHECK(qtde > 0),
data_hora_entrega DATETIME NOT NULL,
FOREIGN KEY(cnpj) REFERENCES fornecedor(cnpj));

CREATE TABLE registro_hora_professor (
id_registro_horas INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
rmsp CHAR(13) NOT NULL,
mes_referencia INTEGER NOT NULL CHECK(mes_referencia BETWEEN 1 AND 12),
ano_referencia INTEGER NOT NULL,
UNIQUE(rmsp, ano_referencia, mes_referencia),
FOREIGN KEY(rmsp) REFERENCES professor(rmsp));

CREATE TABLE devolucao (
id_devolucao INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_matricula INTEGER NOT NULL UNIQUE,
data_desistencia DATE NOT NULL,
motivo VARCHAR(255) NOT NULL,
FOREIGN KEY(id_matricula) REFERENCES matricula(id_matricula));

CREATE TABLE cobranca (
id_cobranca INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
mes_ano DATE NULL,
id_funcionario INTEGER NULL,
id_produto INTEGER NULL,
id_servicos INTEGER NULL,
id_conta INTEGER NULL UNIQUE,
id_registro_horas INTEGER NULL UNIQUE,
id_devolucao INTEGER NULL UNIQUE,
data_emissao DATE NOT NULL,
valor DECIMAL(10,2) NOT NULL CHECK(valor > 0),
vencimento_cobranca DATE NOT NULL,
status_cobranca VARCHAR(9) NOT NULL DEFAULT 'EM ABERTO' CHECK(status_cobranca IN('EM ABERTO', 'EM ATRASO', 'PAGO')),
CHECK(vencimento_cobranca >= data_emissao),
CHECK((mes_ano IS NULL AND id_funcionario IS NULL) OR (mes_ano IS NOT NULL AND id_funcionario IS NOT NULL)),
CHECK((mes_ano IS NOT NULL) + (id_produto IS NOT NULL) + (id_servicos IS NOT NULL) + (id_conta IS NOT NULL) + (id_registro_horas IS NOT NULL) + (id_devolucao IS NOT NULL) = 1),
UNIQUE(mes_ano, id_funcionario),
FOREIGN KEY(id_funcionario) REFERENCES funcionarios(id_funcionario),
FOREIGN KEY(mes_ano, id_funcionario) REFERENCES folha_pagamento(mes_ano, id_funcionario),
FOREIGN KEY(id_produto) REFERENCES produto(id_produto),
FOREIGN KEY(id_servicos) REFERENCES servicos(id_servicos),
FOREIGN KEY(id_conta) REFERENCES conta_mensais(id_conta),
FOREIGN KEY(id_registro_horas) REFERENCES registro_hora_professor(id_registro_horas),
FOREIGN KEY(id_devolucao) REFERENCES devolucao(id_devolucao));

CREATE TABLE despesa (
id_despesa INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
categoria VARCHAR(30) NOT NULL CHECK(categoria IN('FOLHA DE PAGAMENTO', 'REMUNERAÇÃO DE PROFESSORES', 'DESCONTOS DA FOLHA', 'ALUGUEL', 'ENERGIA', 'ÁGUA', 'SERVIÇOS', 'PRODUTOS', 'BENEFÍCIOS', 'DEVOLUÇÕES', 'TARIFAS FINANCEIRAS', 'OUTRAS DESPESAS')),
periodo DATE NOT NULL CHECK(DAY(periodo) = 1),
UNIQUE(categoria, periodo));

CREATE TABLE mensalidade (
id_mensalidade INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_matricula INTEGER NOT NULL,
mes_referencia INTEGER NOT NULL CHECK(mes_referencia BETWEEN 1 AND 12),
ano_referencia INTEGER NOT NULL,
vencimento DATE NOT NULL,
valor_final DECIMAL(10,2) NULL CHECK(valor_final >= 0),
forma_pagamento_prevista VARCHAR(13) NULL CHECK(forma_pagamento_prevista IN('DINHEIRO', 'PIX', 'CARTÃO', 'BOLETO', 'TRANSFERÊNCIA')),
status VARCHAR(9) NOT NULL DEFAULT 'EM ABERTO' CHECK(status IN('EM ABERTO', 'EM ATRASO', 'PAGO', 'CANCELADA')),
UNIQUE(id_matricula, ano_referencia, mes_referencia),
FOREIGN KEY(id_matricula) REFERENCES matricula(id_matricula));

CREATE TABLE taxa_de_adesao (
id_taxa INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_matricula INTEGER NOT NULL UNIQUE,
valor DECIMAL(10,2) NOT NULL CHECK(valor > 0),
vencimento DATE NOT NULL,
situacao VARCHAR(9) NOT NULL DEFAULT 'EM ABERTO' CHECK(situacao IN('EM ABERTO', 'EM ATRASO', 'PAGO')),
FOREIGN KEY(id_matricula) REFERENCES matricula(id_matricula));

CREATE TABLE receita (
id_receita INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
catergoria VARCHAR(15) NOT NULL CHECK(catergoria IN('MENSALIDADES', 'TAXA DE ADESÃO')),
periodo DATE NOT NULL CHECK(DAY(periodo) = 1),
UNIQUE(catergoria, periodo));

CREATE TABLE pagamento (
id_pagamento INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_cobranca INTEGER NULL,
id_despesa INTEGER NULL,
id_receita INTEGER NULL,
id_taxa INTEGER NULL,
forma_pagamento VARCHAR(13) NOT NULL CHECK(forma_pagamento IN('DINHEIRO', 'PIX', 'CARTÃO', 'BOLETO', 'TRANSFERÊNCIA')),
valor DECIMAL(10,2) NOT NULL CHECK(valor > 0),
data_hora_pagamento DATETIME NOT NULL,
tipo VARCHAR(7) AS (IF(id_despesa IS NULL, 'ENTRADA', 'SAÍDA')),
CHECK((id_despesa IS NOT NULL AND id_receita IS NULL) OR (id_despesa IS NULL AND id_receita IS NOT NULL)),
CHECK((id_cobranca IS NOT NULL AND id_despesa IS NOT NULL) OR (id_cobranca IS NULL AND id_despesa IS NULL)),
CHECK(id_taxa IS NULL OR id_receita IS NOT NULL),
FOREIGN KEY(id_cobranca) REFERENCES cobranca(id_cobranca),
FOREIGN KEY(id_despesa) REFERENCES despesa(id_despesa),
FOREIGN KEY(id_receita) REFERENCES receita(id_receita),
FOREIGN KEY(id_taxa) REFERENCES taxa_de_adesao(id_taxa));

CREATE TABLE aula (
cod_aula INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_matricula INTEGER NOT NULL,
rmsp CHAR(13) NOT NULL,
num_sala INTEGER NOT NULL,
rms CHAR(13) NOT NULL,
id_curso INTEGER NOT NULL,
data_aula DATE NOT NULL,
hora_inicio TIME NOT NULL,
hora_fim TIME NOT NULL,
conteudo VARCHAR(255) NULL,
situacao_aula VARCHAR(9) NOT NULL DEFAULT 'PREVISTA' CHECK(situacao_aula IN('PREVISTA', 'REALIZADA', 'CANCELADA')),
cancelada_por VARCHAR(9) NULL CHECK(cancelada_por IN('PROFESSOR', 'ALUNO')),
data_hora_aviso DATETIME NULL,
CHECK(hora_fim > hora_inicio),
CHECK((situacao_aula = 'CANCELADA' AND cancelada_por IS NOT NULL) OR (situacao_aula <> 'CANCELADA' AND cancelada_por IS NULL)),
CHECK(data_hora_aviso IS NULL OR situacao_aula = 'CANCELADA'),
FOREIGN KEY(id_matricula) REFERENCES matricula(id_matricula),
FOREIGN KEY(rmsp) REFERENCES professor(rmsp),
FOREIGN KEY(num_sala) REFERENCES sala(num_sala),
FOREIGN KEY(rms) REFERENCES aluno(rms),
FOREIGN KEY(id_curso) REFERENCES curso(id_curso));

CREATE TABLE presenca (
id_matricula INTEGER NOT NULL,
cod_aula INTEGER NOT NULL,
data_registro DATE NOT NULL,
status_presenca VARCHAR(8) NOT NULL CHECK(status_presenca IN('PRESENTE', 'AUSENTE')),
observacao VARCHAR(255) NULL,
PRIMARY KEY(id_matricula, cod_aula),
FOREIGN KEY(id_matricula) REFERENCES matricula(id_matricula),
FOREIGN KEY(cod_aula) REFERENCES aula(cod_aula));

CREATE TABLE reposicao (
id_reposicao INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
cod_aula INTEGER NOT NULL UNIQUE,
data_solicitacao DATE NOT NULL,
data_reposicao DATE NOT NULL,
hora_inicio TIME NOT NULL,
hora_fim TIME NOT NULL,
motivo VARCHAR(255) NOT NULL,
status_reposicao VARCHAR(9) NOT NULL DEFAULT 'AGENDADA' CHECK(status_reposicao IN('AGENDADA', 'REALIZADA', 'CANCELADA')),
CHECK(hora_fim > hora_inicio),
CHECK(data_reposicao >= data_solicitacao),
FOREIGN KEY(cod_aula) REFERENCES aula(cod_aula));

CREATE TABLE movimento_financeiro (
id_movimento INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
tipo VARCHAR(7) NOT NULL CHECK(tipo IN('ENTRADA', 'SAÍDA')),
fonte VARCHAR(9) NOT NULL CHECK(fonte IN('CAIXA', 'BANCO', 'OPERADORA')),
data_movimento DATE NOT NULL,
valor DECIMAL(10,2) NOT NULL CHECK(valor > 0),
descricao VARCHAR(255) NOT NULL);

CREATE TABLE conciliacao (
id_pagamento INTEGER NOT NULL PRIMARY KEY,
id_movimento INTEGER NOT NULL,
id_funcionario INTEGER NOT NULL,
valor_conciliado DECIMAL(10,2) NOT NULL CHECK(valor_conciliado > 0),
data_conciliacao DATE NOT NULL,
FOREIGN KEY(id_pagamento) REFERENCES pagamento(id_pagamento),
FOREIGN KEY(id_movimento) REFERENCES movimento_financeiro(id_movimento),
FOREIGN KEY(id_funcionario) REFERENCES funcionarios(id_funcionario));

CREATE TABLE divergencia (
id_divergencia INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_pagamento INTEGER NULL,
id_movimento INTEGER NULL,
id_funcionario INTEGER NOT NULL,
tipo_divergencia VARCHAR(23) NOT NULL CHECK(tipo_divergencia IN('VALOR DIFERENTE', 'DATA DIFERENTE', 'PAGAMENTO SEM MOVIMENTO', 'MOVIMENTO SEM PAGAMENTO')),
data_abertura DATE NOT NULL,
data_resolucao DATE NULL,
resolucao VARCHAR(255) NULL,
CHECK((tipo_divergencia IN('VALOR DIFERENTE', 'DATA DIFERENTE') AND id_pagamento IS NOT NULL AND id_movimento IS NOT NULL)
   OR (tipo_divergencia = 'PAGAMENTO SEM MOVIMENTO' AND id_pagamento IS NOT NULL AND id_movimento IS NULL)
   OR (tipo_divergencia = 'MOVIMENTO SEM PAGAMENTO' AND id_pagamento IS NULL AND id_movimento IS NOT NULL)),
CHECK((data_resolucao IS NULL AND resolucao IS NULL) OR (data_resolucao IS NOT NULL AND resolucao IS NOT NULL)),
CHECK(data_resolucao IS NULL OR data_resolucao >= data_abertura),
FOREIGN KEY(id_pagamento) REFERENCES pagamento(id_pagamento),
FOREIGN KEY(id_movimento) REFERENCES movimento_financeiro(id_movimento),
FOREIGN KEY(id_funcionario) REFERENCES funcionarios(id_funcionario));
