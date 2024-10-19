SELECT  
	vd.tb010_012_cod_venda AS "Código da Venda",
	vd.tb010_cpf AS "CPF",
	pd.tb012_descricao AS "Nome do Produto",
	fc.tb005_nome_completo AS "Nome do Funcionário",
	vd.tb010_012_data AS "Data da Venda",
	vd.tb010_012_quantidade AS "Quantidade",
	vd.tb010_012_valor_unitario AS "Valor Unitário"	
FROM 
	tb010_012_vendas vd
INNER JOIN
	tb012_produtos pd ON vd.tb012_cod_produto = pd.tb012_cod_produto
INNER JOIN	
	tb005_funcionarios fc ON vd.tb005_matricula = fc.tb005_matricula;


SELECT  
	pd.tb012_descricao AS "Nome do Produto",
	COUNT(vd.tb010_012_cod_venda) AS "Quantidade de Vendas",
	SUM(vd.tb010_012_quantidade) AS "Quantidade Total",
	SUM(vd.tb010_012_quantidade * vd.tb010_012_valor_unitario) AS "Valor Total"
FROM 
	tb010_012_vendas vd
INNER JOIN
	tb012_produtos pd ON vd.tb012_cod_produto = pd.tb012_cod_produto
INNER JOIN	
	tb005_funcionarios fc ON vd.tb005_matricula = fc.tb005_matricula
GROUP BY 
	pd.tb012_descricao;


SELECT  
	fc.tb005_nome_completo AS "Nome do Funcionário",
	COUNT(vd.tb010_012_cod_venda) AS "Quantidade de Vendas",
	SUM(vd.tb010_012_quantidade) AS "Total de Produtos Vendidos",
	SUM(vd.tb010_012_quantidade * vd.tb010_012_valor_unitario) AS "Valor Total"
FROM 
	tb010_012_vendas vd
INNER JOIN
	tb012_produtos pd ON vd.tb012_cod_produto = pd.tb012_cod_produto
INNER JOIN	
	tb005_funcionarios fc ON vd.tb005_matricula = fc.tb005_matricula
GROUP BY 
	fc.tb005_nome_completo
ORDER BY fc.tb005_nome_completo asc;
