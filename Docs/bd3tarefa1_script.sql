create table public.produto (
	pro_id serial,
	pro_nome varchar(100),
	pro_fabricante varchar(50),
	pro_quantidade integer,
	pro_vlunitario numeric(10,2),
	pro_tipo varchar(30)
);

drop table produto;


insert into public.produto (pro_id,pro_nome,pro_fabricante,pro_quantidade,pro_vlunitario,pro_tipo) values (1,'Playstation 3','Sony',100,1999.00,'Console');
insert into public.produto (pro_id,pro_nome,pro_fabricante,pro_quantidade,pro_vlunitario,pro_tipo) values (2,'Core 2 Duo 4GB Ram 500GB HD','Dell',200,1899.00,'Notebook');
insert into public.produto (pro_id,pro_nome,pro_fabricante,pro_quantidade,pro_vlunitario,pro_tipo) values (3,'Xbox 360 120GB','Microsoft',350,1299.00,'Console');
insert into public.produto (pro_id,pro_nome,pro_fabricante,pro_quantidade,pro_vlunitario,pro_tipo) values (4,'GT-I6220 Quad Band','Samsung',300,499.00,'Celular');
insert into public.produto (pro_id,pro_nome,pro_fabricante,pro_quantidade,pro_vlunitario,pro_tipo) values (5,'IPhone 4 32GB','Apple',50,1499.00,'Smartphone'); 
insert into public.produto (pro_id,pro_nome,pro_fabricante,pro_quantidade,pro_vlunitario,pro_tipo) values (6,'Playstation 2','Sony',100,399.00,'Console'); 
insert into public.produto (pro_id,pro_nome,pro_fabricante,pro_quantidade,pro_vlunitario,pro_tipo) values (7,'Sofa Estofado','Coréia',200,499.00,'Sofa');
insert into public.produto (pro_id,pro_nome,pro_fabricante,pro_quantidade,pro_vlunitario,pro_tipo) values (8,'Armario de Serviço','Aracaju',50,129.00,'Armario'); 
insert into public.produto (pro_id,pro_nome,pro_fabricante,pro_quantidade,pro_vlunitario,pro_tipo) values (9,'Refrigerador 420L','CCE',200,1499.00,'Refrigerador');
insert into public.produto (pro_id,pro_nome,pro_fabricante,pro_quantidade,pro_vlunitario,pro_tipo) values (10,'Wii 120GB','Nintendo',250,999.00,'Console');


ALTER TABLE public.produto
ADD CONSTRAINT pk_produto_id
PRIMARY KEY (pro_id);


create table public.tipo(
	tp_id serial,
	tp_nome varchar(30),
	CONSTRAINT pk_tipo_id PRIMARY KEY (tp_id)
);


ALTER TABLE public.produto 
ADD COLUMN pro_tipoid integer;









































