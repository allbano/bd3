-- Procedimento para alterar as tabelas, criando as foreign keys
DO
$$
BEGIN
    -- Tabela tb002_cidades
    ALTER TABLE tb002_cidades
        ADD CONSTRAINT CONST_UF_CIDADE FOREIGN KEY (tb001_sigla_uf) 
        REFERENCES tb001_uf(tb001_sigla_uf)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb003_enderecos
    ALTER TABLE tb003_enderecos
        ADD CONSTRAINT CONST_CIDADE_END FOREIGN KEY (tb002_cod_cidade, tb001_sigla_uf) 
        REFERENCES tb002_cidades(tb002_cod_cidade, tb001_sigla_uf)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;
    -- Tabela tb004_lojas
    ALTER TABLE tb004_lojas
        ADD CONSTRAINT CONST_END_LOJAS FOREIGN KEY (tb003_cod_endereco) 
        REFERENCES tb003_enderecos(tb003_cod_endereco)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb005_006_funcionarios_cargos - Vincula Funcionários
    ALTER TABLE tb005_006_funcionarios_cargos
        ADD CONSTRAINT CONST_FUNC_FUNCCARGO FOREIGN KEY (tb005_matricula) 
        REFERENCES tb005_funcionarios(tb005_matricula)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb005_006_funcionarios_cargos - Vincula Cargos
    ALTER TABLE tb005_006_funcionarios_cargos
        ADD CONSTRAINT CONST_CARGO_FUNCCARGO2 FOREIGN KEY (tb006_cod_cargo)
        REFERENCES tb006_cargos(tb006_cod_cargo)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb005_funcionarios - Vincula Endereços
    ALTER TABLE tb005_funcionarios
        ADD CONSTRAINT CONST_END_FUNC FOREIGN KEY (tb003_cod_endereco) 
        REFERENCES tb003_enderecos(tb003_cod_endereco)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb005_funcionarios - Vincula Lojas
    ALTER TABLE tb005_funcionarios
        ADD CONSTRAINT CONST_LOJAS_FUNC FOREIGN KEY (tb004_cod_loja) 
        REFERENCES tb004_lojas(tb004_cod_loja)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb010_012_vendas - Vincula Funcionários
    ALTER TABLE tb010_012_vendas
        ADD CONSTRAINT CONST_FUNC_VENDAS FOREIGN KEY (tb005_matricula) 
        REFERENCES tb005_funcionarios(tb005_matricula)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb010_012_vendas - Vincula Clientes
    ALTER TABLE tb010_012_vendas
        ADD CONSTRAINT CONST_CLI_VENDAS FOREIGN KEY (tb010_cpf) 
        REFERENCES tb010_clientes(tb010_cpf)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb010_012_vendas - Vincula Produtos
    ALTER TABLE tb010_012_vendas
        ADD CONSTRAINT CONST_PRD_VENDAS FOREIGN KEY (tb012_cod_produto) 
        REFERENCES tb012_produtos(tb012_cod_produto)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb011_logins - Vincula Clientes
    ALTER TABLE tb011_logins
        ADD CONSTRAINT CONST_CLI_LOGIN FOREIGN KEY (tb010_cpf) 
        REFERENCES tb010_clientes(tb010_cpf)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;
    -- Tabela tb012_produtos - Vincula Categorias
    ALTER TABLE tb012_produtos
        ADD CONSTRAINT CONST_CAT_PRD FOREIGN KEY (tb013_cod_categoria) 
        REFERENCES tb013_categorias(tb013_cod_categoria)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;
    -- Tabela tb012_017_compras - Vincula Produtos
    ALTER TABLE tb012_017_compras
        ADD CONSTRAINT CONST_PRD_COMPRAS FOREIGN KEY (tb012_cod_produto) 
        REFERENCES tb012_produtos(tb012_cod_produto)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb012_017_compras - Vincula Fornecedores
    ALTER TABLE tb012_017_compras
        ADD CONSTRAINT CONST_FORN_COMPRAS FOREIGN KEY (tb017_cod_fornecedor) 
        REFERENCES tb017_fornecedores(tb017_cod_fornecedor)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;



    -- Tabela tb014_prd_alimentos - Vincula Produtos
    ALTER TABLE tb014_prd_alimentos
        ADD CONSTRAINT CONST_PRD_ALIM FOREIGN KEY (tb012_cod_produto) 
        REFERENCES tb012_produtos(tb012_cod_produto)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb015_prd_eletros - Vincula Produtos
    ALTER TABLE tb015_prd_eletros
        ADD CONSTRAINT CONST_PRD_ELET FOREIGN KEY (tb012_cod_produto) 
        REFERENCES tb012_produtos(tb012_cod_produto)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb016_prd_vestuarios - Vincula Produtos
    ALTER TABLE tb016_prd_vestuarios
        ADD CONSTRAINT CONST_PRD_VEST FOREIGN KEY (tb012_cod_produto) 
        REFERENCES tb012_produtos(tb012_cod_produto)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

    -- Tabela tb017_fornecedores - Vincula Endereços
    ALTER TABLE tb017_fornecedores
        ADD CONSTRAINT CONST_END_FORN FOREIGN KEY (tb003_cod_endereco) 
        REFERENCES tb003_enderecos(tb003_cod_endereco)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION;

END
$$;
