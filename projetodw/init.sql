-- Procedimento para deletas todas as tabelas caso existam
DO
$$
BEGIN
    DROP TABLE IF EXISTS tb010_clientes_antigos;
    DROP TABLE IF EXISTS tb016_prd_vestuarios;
    DROP TABLE IF EXISTS tb011_logins;
    DROP TABLE IF EXISTS tb015_prd_eletros;
    DROP TABLE IF EXISTS tb014_prd_alimentos;
    DROP TABLE IF EXISTS tb005_006_funcionarios_cargos;
    DROP TABLE IF EXISTS tb006_cargos;
    DROP TABLE IF EXISTS tb010_012_vendas;
    DROP TABLE IF EXISTS tb010_clientes;
    DROP TABLE IF EXISTS tb005_funcionarios;
    DROP TABLE IF EXISTS tb004_lojas;
    DROP TABLE IF EXISTS tb999_log;
    DROP TABLE IF EXISTS tb012_017_compras;
    DROP TABLE IF EXISTS tb017_fornecedores;
    DROP TABLE IF EXISTS tb003_enderecos;
    DROP TABLE IF EXISTS tb002_cidades;
    DROP TABLE IF EXISTS tb001_uf;
    DROP TABLE IF EXISTS tb012_produtos;
    DROP TABLE IF EXISTS tb013_categorias;

END
$$;

-- Procedimento para criar as tabelas
DO
$$
BEGIN
 
    -- Create Tables

    -- Tabela tb001_uf
    CREATE TABLE tb001_uf ( 
	    tb001_sigla_uf       VARCHAR(2)  NOT NULL ,
	    tb001_nome_estado    VARCHAR(255)  NOT NULL, 
        CONSTRAINT XPKtb001_uf PRIMARY KEY (tb001_sigla_uf)
    );

    -- Tabela tb002_cidades
    CREATE TABLE tb002_cidades (
        tb002_cod_cidade SERIAL,
        tb001_sigla_uf VARCHAR(2) NOT NULL,
        tb002_nome_cidade VARCHAR(255) NOT NULL,
        CONSTRAINT XPKtb002_cidades PRIMARY KEY (tb002_cod_cidade, tb001_sigla_uf)
    );

    -- Tabela tb003_enderecos
    CREATE TABLE tb003_enderecos (
        tb003_cod_endereco SERIAL,
        tb001_sigla_uf VARCHAR(2) NOT NULL,
        tb002_cod_cidade INTEGER     NOT NULL,
        tb003_nome_rua VARCHAR(255) NOT NULL,
        tb003_numero_rua VARCHAR(10) NOT NULL,
        tb003_complemento VARCHAR(255),
        tb003_ponto_referencia VARCHAR(255),
        tb003_bairro VARCHAR(255) NOT NULL,
        tb003_CEP VARCHAR(15) NOT NULL,
        CONSTRAINT XPKtb003_enderecos PRIMARY KEY (tb003_cod_endereco)
    );

    -- Tabela tb004_lojas 
    CREATE TABLE tb004_lojas (
        tb004_cod_loja SERIAL,
        tb003_cod_endereco INTEGER,
        tb004_matriz NUMERIC(10),
        tb004_cnpj_loja VARCHAR(20) NOT NULL,
        tb004_inscricao_estadual VARCHAR(20),
        CONSTRAINT XPKtb004_lojas PRIMARY KEY (tb004_cod_loja)
    );

    -- Tabela tb005_006_funcionarios_cargos
    CREATE TABLE tb005_006_funcionarios_cargos (
        tb005_matricula NUMERIC(10) NOT NULL,
        tb006_cod_cargo NUMERIC(10) NOT NULL,
        tb005_006_valor_cargo NUMERIC(10,2) NOT NULL,
        tb005_006_perc_comissao_cargo NUMERIC(5,2) NOT NULL,
        tb005_006_data_promocao TIMESTAMP NOT NULL,
        CONSTRAINT XPKtb005_006_funcionarios_cargos PRIMARY KEY (tb005_matricula, tb006_cod_cargo)
    );

    -- Tabela tb005_funcionarios
    CREATE TABLE tb005_funcionarios (
        tb005_matricula SERIAL,
        tb004_cod_loja NUMERIC(10) NOT NULL,
        tb003_cod_endereco NUMERIC(10) NOT NULL,
        tb005_nome_completo VARCHAR(255) NOT NULL,
        tb005_data_nascimento TIMESTAMP NOT NULL,
        tb005_CPF VARCHAR(17) NOT NULL,
        tb005_RG VARCHAR(15) NOT NULL,
        tb005_status VARCHAR(20) NOT NULL,
        tb005_data_contratacao TIMESTAMP NOT NULL,
        tb005_data_demissao TIMESTAMP,
    CONSTRAINT XPKtb005_funcionarios PRIMARY KEY (tb005_matricula)
    );

    -- Tabela tb006_cargos
    CREATE TABLE tb006_cargos (
        tb006_cod_cargo SERIAL,
        tb006_nome_cargo VARCHAR(255) NOT NULL,
        CONSTRAINT XPKtb006_cargos PRIMARY KEY (tb006_cod_cargo)
    );

    -- Tabela tb0_012_vendas
    CREATE TABLE tb010_012_vendas (
        tb010_012_cod_venda SERIAL,
        tb010_cpf NUMERIC(15) NOT NULL,
        tb012_cod_produto NUMERIC(10) NOT NULL,
        tb005_matricula NUMERIC(10) NOT NULL,
        tb010_012_data TIMESTAMP NOT NULL,
        tb010_012_quantidade NUMERIC(10) NOT NULL,
        tb010_012_valor_unitario NUMERIC(12,4) NOT NULL,
        CONSTRAINT XPKtb010_012_vendas PRIMARY KEY (tb010_012_cod_venda, tb005_matricula, tb010_cpf, tb012_cod_produto)
    );

    -- Tabela tb010_clientes
    CREATE TABLE tb010_clientes (
        tb010_cpf NUMERIC(15) NOT NULL,
        tb010_nome VARCHAR(255) NOT NULL,
        tb010_fone_residencial VARCHAR(255) NOT NULL,
        tb010_fone_celular VARCHAR(255),
        CONSTRAINT XPKtb010_clientes PRIMARY KEY (tb010_cpf)
    );

    -- Tabela tb010_clientes_antigos
    CREATE TABLE tb010_clientes_antigos (
        tb010_cpf NUMERIC(15) NOT NULL,
        tb010_nome VARCHAR(255),
        CONSTRAINT XPKtb010_clientes_antigos PRIMARY KEY (tb010_cpf)
    );

    -- Tabela tb011_logins
    CREATE TABLE tb011_logins (
        tb011_logins VARCHAR(255) NOT NULL,
        tb010_cpf NUMERIC(15) NOT NULL,
        tb011_senha VARCHAR(255) NOT NULL,
        tb011_data_cadastro TIMESTAMP,
        CONSTRAINT XPKtb011_logins PRIMARY KEY (tb011_logins)
    );

    -- Tabela tb012_017_compras
    CREATE TABLE tb012_017_compras (
        tb012_017_cod_compra SERIAL,
        tb012_cod_produto NUMERIC(10) NOT NULL,
        tb017_cod_fornecedor NUMERIC(10) NOT NULL,
        tb012_017_data TIMESTAMP,
        tb012_017_quantidade NUMERIC(10),
        tb012_017_valor_unitario NUMERIC(12,2),
        CONSTRAINT XPKtb017_compras PRIMARY KEY (tb012_017_cod_compra, tb012_cod_produto, tb017_cod_fornecedor)
    );

    -- Tabela tb012_produtos
    CREATE TABLE tb012_produtos (
        tb012_cod_produto NUMERIC(10) NOT NULL,
        tb013_cod_categoria NUMERIC(10) NOT NULL,
        tb012_descricao VARCHAR(255) NOT NULL,
        CONSTRAINT XPKtb012_produtos PRIMARY KEY (tb012_cod_produto)
    );

    -- Tabela tb013_categorias
    CREATE TABLE tb013_categorias (
        tb013_cod_categoria SERIAL,
        tb013_descricao VARCHAR(255) NOT NULL,
        CONSTRAINT XPKtb013_categorias PRIMARY KEY (tb013_cod_categoria)
    );

    -- Tabela tb014_prd_alimentos
    CREATE TABLE tb014_prd_alimentos (
        tb014_cod_prd_alimentos SERIAL,
        tb012_cod_produto NUMERIC(10) NOT NULL,
        tb014_detalhamento VARCHAR(255) NOT NULL,
        tb014_unidade_medida VARCHAR(255) NOT NULL,
        tb014_num_lote VARCHAR(255),
        tb014_data_vencimento TIMESTAMP,
        tb014_valor_sugerido NUMERIC(10,2),
        CONSTRAINT XPKtb014_prd_alimentos PRIMARY KEY (tb014_cod_prd_alimentos, tb012_cod_produto)
    );

    -- Tabela tb015_prd_eletros
    CREATE TABLE tb015_prd_eletros (
        tb015_cod_prd_eletro SERIAL,
        tb012_cod_produto NUMERIC(10) NOT NULL,
        tb015_detalhamento VARCHAR(255) NOT NULL,
        tb015_tensao VARCHAR(255),
        tb015_nivel_consumo_procel CHAR(1),
        tb015_valor_sugerido NUMERIC(10,2),
        CONSTRAINT XPKtb015_prd_tvs PRIMARY KEY (tb015_cod_prd_eletro, tb012_cod_produto)
    );

    -- Tabela tb016_prd_vestuarios
    CREATE TABLE tb016_prd_vestuarios (
        tb016_cod_prd_vestuario SERIAL,
        tb012_cod_produto NUMERIC(10) NOT NULL,
        tb016_detalhamento VARCHAR(255) NOT NULL,
        tb016_sexo CHAR(1) NOT NULL,
        tb016_tamanho VARCHAR(255),
        tb016_numeracao NUMERIC(3),
        tb016_valor_sugerido NUMERIC(10,2),
        CONSTRAINT XPKtb016_refrigeradores PRIMARY KEY (tb016_cod_prd_vestuario, tb012_cod_produto)
    );

    -- Tabela tb017_fornecedores
    CREATE TABLE tb017_fornecedores (
        tb017_cod_fornecedor SERIAL,
        tb017_razao_social VARCHAR(255),
        tb017_nome_fantasia VARCHAR(255),
        tb017_fone VARCHAR(15),
        tb003_cod_endereco NUMERIC(10),
        CONSTRAINT XPKtb017_fornecedor PRIMARY KEY (tb017_cod_fornecedor)
    );

    -- Tabela tb999_log
    CREATE TABLE tb999_log (
        tb999_cod_log SERIAL,
        tb099_objeto VARCHAR(100) NOT NULL,
        tb999_dml VARCHAR(25) NOT NULL,
        tb999_data TIMESTAMP NOT NULL,
        CONSTRAINT XPKtb999_log PRIMARY KEY (tb999_cod_log)
    );

END
$$;
