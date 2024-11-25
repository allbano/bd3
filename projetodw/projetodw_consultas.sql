-- Consultas simples de usabilidade
select * from public.tb001_uf tu;
select * from public.tb002_cidades tc;
select * from public.tb003_enderecos te;
select * from public.tb004_lojas tl;
select * from public.tb006_cargos tc;
select * from public.tb005_funcionarios tf;
select * from public.tb005_006_funcionarios_cargos tfc;
select * from public.tb010_012_vendas tv;
select * from public.tb010_clientes c;
select * from public.tb010_clientes_antigos ct;
select * from public.tb011_logins tl;
select * from public.tb012_017_compras tc;
select * from public.tb012_produtos tp order by tb012_cod_produto asc;
select * from public.tb013_categorias tc;
select * from public.tb014_prd_alimentos tpa;
select * from public.tb015_prd_eletros tpe;
select * from public.tb016_prd_vestuarios tpv;
select * from public.tb017_fornecedores tf;
select * from public.tb999_log tl;

SELECT pg_size_pretty(pg_database_size('projetodw'));


select * from fat_lucro fl;
select * from fat_vendas fv;

-- 4.1. Quantidade de vendas agrupadas por tipo e categoria.
SELECT
	--sum(v.vd_quantidade_produto),
v.vd_quantidade_produto,
	t.tp_descricao as Tipo,
	c.ct_descricao as Categoria
FROM public.fat_vendas v 
INNER JOIN public.dim_tipo t ON t.tp_id = v.vd_tp_id_tipo 
INNER JOIN public.dim_categoria c ON c.ct_id = v.vd_ct_id_categoria 
WHERE 
	v.vd_pd_id_produto IS NULL
	AND v.vd_cl_cpf_cliente IS NULL
	AND v.vd_fn_matricula IS NULL
	AND v.vd_lj_id_lojas IS NULL
	AND v.vd_ct_id_categoria IS NOT NULL
	AND v.vd_tp_id_tipo IS NOT null
--group by Tipo, Categoria
ORDER BY Categoria;



-- 4.2. Valor das vendas por funcionário, permitindo uma visão hierárquica por tempo.
SELECT 
	sum(v.vd_valor_unitario) AS "Valor das Vendas", 
	f.fn_nome as "Nome do Funcionário",
	v.vd_tm_mes as Mes,
	v.vd_tm_ano as Ano
FROM 
	public.fat_vendas v 
INNER JOIN public.dim_lojas l ON l.lj_id = v.vd_lj_id_lojas 
INNER JOIN public.dim_funcionario f ON f.fn_matricula = v.vd_fn_matricula 
WHERE 
	v.vd_tp_id_tipo IS NULL
	AND v.vd_pd_id_produto IS NULL
	AND v.vd_cl_cpf_cliente IS NULL
	AND v.vd_ct_id_categoria IS NULL
	AND v.vd_fn_matricula IS NOT NULL
	AND v.vd_tm_mes IS NOT null
	AND v.vd_tm_ano IS NOT NULL
	AND v.vd_lj_id_lojas IS NOT null
GROUP BY f.fn_nome, v.vd_tm_mes, v.vd_tm_ano 
ORDER BY f.fn_nome;



-- 4.3. Volume das vendas por funcionário, permitindo uma visão por localidade.
SELECT
	f.fn_nome as "Nome do Funcionário",
	l.lj_rua as "Endereço",
	l.lj_cidade as "Cidade",
	v.vd_tm_mes as Mês,
	v.vd_tm_ano as Ano,
	sum(v.vd_quantidade_funcionario) as "Volume de Vendas" 
FROM 
	public.fat_vendas v
INNER JOIN public.dim_funcionario f ON f.fn_matricula = v.vd_fn_matricula
INNER JOIN public.dim_lojas l ON l.lj_id = v.vd_lj_id_lojas
WHERE 
	f.fn_nome IS NOT NULL
	AND l.lj_rua IS NOT NULL
	AND l.lj_cidade IS NOT NULL
	AND v.vd_tm_ano IS NOT NULL
	AND v.vd_tm_mes IS NOT NULL
GROUP BY
	f.fn_nome, l.lj_rua, l.lj_cidade, v.vd_tm_mes, v.vd_tm_ano
ORDER BY
	f.fn_nome, l.lj_rua, l.lj_cidade, v.vd_tm_mes, v.vd_tm_ano;




-- 4.4. Quantidade de atendimentos realizados por funcionário e localidade.
SELECT distinct 
	v.vd_quantidade_funcionario  "Atendimentos por Funcionário", 
	f.fn_nome,
	l.lj_cidade 
FROM 
	public.fat_vendas v 
INNER JOIN dim_lojas l ON l.lj_id = v.vd_lj_id_lojas 
INNER JOIN dim_funcionario f ON f.fn_matricula = v.vd_fn_matricula
WHERE 
	v.vd_tp_id_tipo IS NULL
	AND v.vd_tm_dia IS NULL
	AND v.vd_pd_id_produto IS NULL
	AND v.vd_cl_cpf_cliente IS NULL
	AND v.vd_tm_mes IS NULL
	AND v.vd_ct_id_categoria IS NULL
	AND v.vd_lj_id_lojas IS NOT NULL
	AND v.vd_fn_matricula IS NOT null
ORDER BY f.fn_nome, v.vd_quantidade_funcionario;



-- 4.5. Valor das últimas vendas realizadas por cliente.

SELECT 
    vd.vd_cl_cpf_cliente AS "CPF do Cliente",
    vd.vd_tm_dia AS "Dia da Venda",
    vd.vd_tm_mes AS "Mês da Venda",
    vd.vd_tm_ano AS "Ano da Venda",    
    SUM(vd.vd_quantidade_produto * vd.vd_valor_unitario) AS "Valor da Última Venda"
FROM 
    fat_Vendas vd
INNER JOIN (
    -- Subconsulta para pegar a última venda de cada cliente
    SELECT 	vd_cl_cpf_cliente, 
    		MAX(vd_tm_ano * 10000 + vd_tm_mes * 100 + vd_tm_dia) AS ultima_data
    FROM  fat_Vendas
    GROUP BY vd_cl_cpf_cliente
	) ult_vd 
	ON vd.vd_cl_cpf_cliente = ult_vd.vd_cl_cpf_cliente
	AND (vd.vd_tm_ano * 10000 + vd.vd_tm_mes * 100 + vd.vd_tm_dia) = ult_vd.ultima_data
GROUP BY 
    vd.vd_cl_cpf_cliente, vd.vd_tm_ano, vd.vd_tm_mes, vd.vd_tm_dia;



-- 4.6. Clientes que mais compraram na loja virtual com valor acumulado por período.

SELECT
	v.vd_cl_cpf_cliente as "CPF do Cliente",
	c.cl_nome as "Nome do Cliente",
	v.vd_tm_mes as Mês,
	v.vd_tm_ano as Ano,
	sum(v.vd_valor_unitario) as "Valor Gasto"
from
	public.fat_vendas v
INNER JOIN public.dim_cliente c ON c.cl_cpf = v.vd_cl_cpf_cliente 
WHERE 
	v.vd_cl_cpf_cliente IS NOT NULL
	AND v.vd_fn_matricula IS NULL 
	AND v.vd_tm_ano IS NOT NULL
	AND v.vd_tm_mes IS NOT NULL
GROUP BY  v.vd_cl_cpf_cliente, c.cl_nome, v.vd_tm_mes ,v.vd_tm_ano 
ORDER BY v.vd_cl_cpf_cliente, v.vd_tm_mes,v.vd_tm_ano

































