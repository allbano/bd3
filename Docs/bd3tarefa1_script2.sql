select *
from public.produto p

select p.pro_tipo,sum(p.pro_quantidade) as 'Quantidade em Estoque'
from produto p
group by p.pro_tipo


select p.pro_fabricante,sum(p.pro_quantidade) as "Quantidade em Estoque"
from produto p
group by p.pro_fabricante
order by p.pro_fabricante asc;



select p.pro_tipo as "Tipo",p.pro_fabricante as "Fabricante",sum(p.pro_quantidade) as "Quantidade em Estoque"
from produto p
group by p.pro_tipo,p.pro_fabricante
order by "Quantidade em Estoque" asc;



select p.pro_tipo as "Tipo",sum(p.pro_quantidade*p.pro_vlunitario) as "Valor em Estoque"
from produto p
group by p.pro_tipo
order by p.pro_tipo asc


select p.pro_tipo as "Tipo",sum(p.pro_quantidade) as "Quantidade em Estoque"
from produto p
group by p.pro_tipo
having sum(p.pro_quantidade) > 200





INSERT INTO public.tipo (tp_nome)
SELECT p.pro_tipo AS "tp_nome"
FROM public.produto p 
GROUP BY p.pro_tipo
HAVING count(p.pro_tipo) = 1 OR count(p.pro_tipo) > 1 




SELECT *
FROM public.tipo t 

SELECT *
FROM public.produto p

SELECT p.pro_id,p.pro_nome,p.pro_fabricante,p.pro_quantidade,p.pro_vlunitario,t.tp_nome AS "Tipo" 
FROM public.produto p INNER JOIN public.tipo t ON p.pro_tipoid = t.tp_id

SELECT p.pro_tipoid, t.tp_id,t. tp_nome 
FROM public.produto p INNER JOIN public.tipo t ON p.pro_tipoid = t.tp_id 


UPDATE public.produto
SET pro_tipoid = t.tp_id
FROM public.tipo t
WHERE pro_tipo = t.tp_nome


ALTER TABLE public.produto
DROP COLUMN pro_tipo


-- Selects com duas tabelas!!!



SELECT t.tp_nome,sum(p.pro_quantidade) AS "Quantidade em Estoque"
FROM public.produto p,public.tipo t
WHERE p.pro_tipoid = t.tp_id 
group by t.tp_nome 



SELECT p.pro_fabricante,sum(p.pro_quantidade) as "Quantidade em Estoque"
FROM public.produto p 
GROUP BY p.pro_fabricante
ORDER BY p.pro_fabricante asc;



SELECT t.tp_nome as "Tipo",p.pro_fabricante AS "Fabricante",sum(p.pro_quantidade) AS "Quantidade em Estoque"
FROM public.produto p INNER JOIN public.tipo t ON p.pro_tipoid = t.tp_id 
GROUP BY t.tp_nome,p.pro_fabricante
ORDER BY "Quantidade em Estoque" ASC;





SELECT  t.tp_nome as "Tipo",sum(p.pro_quantidade*p.pro_vlunitario) as "Valor em Estoque"
FROM public.produto p INNER JOIN public.tipo t ON p.pro_tipoid = t.tp_id 
GROUP BY t.tp_nome
ORDER BY t.tp_nome ASC;




select t.tp_nome AS "Tipo",sum(p.pro_quantidade) AS "Quantidade em Estoque"
FROM public.produto p INNER JOIN public.tipo t ON p.pro_tipoid = t.tp_id
GROUP BY t.tp_nome
having sum(p.pro_quantidade) > 200













































































