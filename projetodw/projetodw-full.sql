-- Habilitar a extensão FDW
DO 
$$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'postgres_fdw') THEN
    CREATE EXTENSION postgres_fdw;
  END IF;
END 
$$;

-- Criar o servidor para o contêiner lojadevarejo
DO 
$$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_foreign_server WHERE srvname = 'lojadevarejo') THEN
    CREATE SERVER lojadevarejo
    FOREIGN DATA WRAPPER postgres_fdw
    --OPTIONS (host 'lojadevarejo', dbname 'lojadevarejo', port '5432');
    OPTIONS (host 'lojadevarejo', dbname 'lojadevarejo', port '5432');
  END IF;
END 
$$;

-- Criar o mapeamento de usuário
DO 
$$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_user_mappings 
      WHERE srvname = 'lojadevarejo' 
      AND umuser = (SELECT usesysid FROM pg_user WHERE usename = 'equipefoda')) THEN
    CREATE USER MAPPING FOR equipefoda
    SERVER lojadevarejo
    OPTIONS (user 'equipefoda', password 'equipefoda');
  END IF;
END 
$$;

-- Importar o esquema public
DO 
$$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'public') THEN
    IMPORT FOREIGN SCHEMA public
    FROM SERVER lojadevarejo
    INTO public;
  END IF;
END 
$$;

-- Criação das Tabelas do Data Warehouse(DW)
DO
$$
BEGIN
-- CREATE TABLE
CREATE TABLE dim_Tipo (
    tp_id INTEGER,
    tp_descricao VARCHAR(50),
    fk_Tipo_tp_id INTEGER,
    CONSTRAINT pk_dim_tipo PRIMARY KEY (tp_id)
);

CREATE TABLE dim_Categoria (
    ct_id INTEGER,
    ct_descricao VARCHAR(100),
    CONSTRAINT pd_dim_categoria PRIMARY KEY (ct_id)
);

CREATE TABLE dim_Cliente (
    cl_cpf CHARACTER(15),
    cl_nome VARCHAR(100),
    CONSTRAINT pk_dim_clientes PRIMARY KEY (cl_cpf)
);

CREATE TABLE dim_Funcionario (
    fn_matricula INTEGER,
    fn_nome VARCHAR(100),
    CONSTRAINT pk_dim_funcionario PRIMARY KEY (fn_matricula)
);

CREATE TABLE dim_Lojas (
    lj_id INTEGER,
    lj_rua VARCHAR(255),
    lj_cidade VARCHAR(50),
    CONSTRAINT pk_dim_loja PRIMARY KEY (lj_id)
);

CREATE TABLE dim_Produto (
    pd_id INTEGER,
    pd_descricao VARCHAR(60),
    CONSTRAINT pk_dim_produto PRIMARY KEY (pd_id)
);

CREATE TABLE fat_Lucro (
    lc_lucro NUMERIC(10,2),
    lc_pd_id_produto INTEGER
);

CREATE TABLE fat_Vendas (
    vd_quantidade_produto INTEGER,
    vd_valor_unitario NUMERIC(10,2),
    vd_quantidade_funcionario INTEGER,
    vd_pd_id_produto INTEGER,
    vd_fn_matricula INTEGER,
    vd_ct_id_categoria INTEGER,
    vd_cl_cpf_cliente CHARACTER(15),
    vd_tp_id_tipo INTEGER,
    vd_lj_id_lojas INTEGER,
    vd_tm_ano INTEGER,
    vd_tm_mes INTEGER,
    vd_tm_dia INTEGER
);
END
$$;

DO
$$
BEGIN
-- ALTER TABLE
ALTER TABLE public.fat_lucro 
	ADD CONSTRAINT fk_pd_id_fat_lucro FOREIGN KEY (lc_pd_id_produto) 
    REFERENCES dim_produto(pd_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE public.fat_vendas 
	ADD CONSTRAINT fk_pd_id_fat_venda FOREIGN KEY (vd_pd_id_produto) 
    REFERENCES dim_produto(pd_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE public.fat_vendas 
	ADD CONSTRAINT fk_fn_matricula_fat_venda FOREIGN KEY (vd_fn_matricula) 
    REFERENCES dim_funcionario(fn_matricula)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE public.fat_vendas
	ADD CONSTRAINT fk_ct_id_fat_venda FOREIGN KEY (vd_ct_id_categoria) 
    REFERENCES dim_categoria(ct_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE public.fat_vendas
	ADD CONSTRAINT fk_cl_cpf_fat_venda FOREIGN KEY (vd_cl_cpf_cliente) 
    REFERENCES dim_cliente(cl_cpf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE public.fat_vendas
	ADD CONSTRAINT fk_tp_id_fat_venda FOREIGN KEY (vd_tp_id_tipo) 
    REFERENCES dim_tipo(tp_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE public.fat_vendas
	ADD CONSTRAINT fk_lj_id_fat_venda FOREIGN KEY (vd_lj_id_lojas) 
    REFERENCES dim_lojas(lj_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
END
$$;

DO
$$
BEGIN
-- SIMPLE INSERTs 
INSERT INTO public.dim_cliente(cl_cpf,cl_nome)
	SELECT tb010_cpf, tb010_nome
	FROM tb010_clientes;

INSERT INTO public.dim_funcionario(fn_matricula,fn_nome)
	SELECT tb005_matricula, tb005_nome_completo
	FROM tb005_funcionarios;

INSERT INTO public.dim_categoria(ct_id,ct_descricao)
	SELECT tb013_cod_categoria, tb013_descricao
	FROM tb013_categorias;

INSERT INTO public.dim_produto(pd_id,pd_descricao)
	SELECT tb012_cod_produto, tb012_descricao
	FROM tb012_produtos;

INSERT INTO public.dim_lojas(lj_id,lj_rua,lj_cidade)
	SELECT l.tb004_cod_loja,t.tb003_nome_rua, c.tb002_nome_cidade
	FROM tb002_cidades c
	INNER JOIN tb003_enderecos t ON t.tb002_cod_cidade = c.tb002_cod_cidade
	INNER JOIN tb004_lojas l ON l.tb003_cod_endereco = t.tb003_cod_endereco
	ORDER BY l.tb004_cod_loja;

INSERT INTO public.dim_tipo 
	VALUES (1,'Alimentos'), (2,'Eletros'), (3,'Vestuários');
END
$$;

DO
$$
BEGIN
-- COMPLEX INSERTs
INSERT INTO public.fat_vendas(
		vd_quantidade_produto,
		vd_valor_unitario,
		vd_quantidade_funcionario,
		vd_pd_id_produto,
		vd_fn_matricula,
		vd_ct_id_categoria,
		vd_cl_cpf_cliente,
		vd_tp_id_tipo,
		vd_lj_id_lojas,
		vd_tm_dia,
		vd_tm_mes,
		vd_tm_ano)
SELECT
	COUNT(v.tb010_012_quantidade) as vd_quantidade_produto,
	SUM(v.tb010_012_valor_unitario) as valor_unitario,
	SUM(v.tb010_012_quantidade) as quantidade_funcionario,
	v.tb012_cod_produto,
	v.tb005_matricula,
	p.tb013_cod_categoria,
	cl.tb010_cpf,
	CASE
		WHEN v.tb012_cod_produto = a.tb012_cod_produto  THEN 1
		WHEN v.tb012_cod_produto = e.tb012_cod_produto  THEN 2
		WHEN v.tb012_cod_produto = ve.tb012_cod_produto THEN 3
	END AS vd_tp_id_tipo,
	l.tb004_cod_loja,
	EXTRACT(DAY FROM v.tb010_012_data) as dia,	
	EXTRACT(MONTH FROM v.tb010_012_data) as mes,
	EXTRACT(YEAR FROM v.tb010_012_data) as ano
FROM 
	tb010_012_vendas v
	INNER JOIN tb012_produtos p ON v.tb012_cod_produto = p.tb012_cod_produto
	INNER JOIN tb005_funcionarios f ON v.tb005_matricula = f.tb005_matricula
	INNER JOIN tb013_categorias c ON c.tb013_cod_categoria = p.tb013_cod_categoria
	INNER JOIN tb004_lojas l ON l.tb004_cod_loja = f.tb004_cod_loja
	LEFT JOIN tb014_prd_alimentos a ON v.tb012_cod_produto = a.tb012_cod_produto
	LEFT JOIN tb015_prd_eletros e ON v.tb012_cod_produto = e.tb012_cod_produto
	LEFT JOIN tb016_prd_vestuarios ve ON v.tb012_cod_produto = ve.tb012_cod_produto
	INNER JOIN tb010_clientes cl ON cl.tb010_cpf = v.tb010_cpf
GROUP BY CUBE (
	v.tb012_cod_produto,
	v.tb005_matricula,
	p.tb013_cod_categoria,
	l.tb004_cod_loja,
	EXTRACT(DAY FROM v.tb010_012_data),
	EXTRACT(MONTH FROM v.tb010_012_data),
	EXTRACT(YEAR FROM v.tb010_012_data),
	cl.tb010_cpf,
	vd_tp_id_tipo);
END
$$;

DO
$$
BEGIN
-- COMPLEX INSERTs
INSERT INTO public.fat_lucro(lc_lucro,lc_pd_id_produto)
SELECT
	SUM(tb010_012_valor_unitario - tb012_017_valor_unitario) AS lucro,
	p.tb012_cod_produto AS produto
FROM
	tb012_produtos p
INNER JOIN tb010_012_vendas v ON p.tb012_cod_produto = v.tb012_cod_produto
INNER JOIN tb012_017_compras c ON p.tb012_cod_produto = c.tb012_cod_produto
GROUP by GROUPING SETS (
	(p.tb012_cod_produto,(tb010_012_valor_unitario - tb012_017_valor_unitario)),
	(p.tb012_cod_produto), 
	());
END
$$;

