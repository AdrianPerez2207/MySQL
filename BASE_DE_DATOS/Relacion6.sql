drop database if exists Relacion6;
create database if not exists Relacion6;
use Relacion6;
show databases;

create table if not exists ciudad(
	id_ciudad char(3) primary key,
    nom_ciudad varchar(10)
)
engine=InnoDB;

create table if not exists tipoart(
	id_tipo char(3) primary key,
    nom_tipo varchar(11)
)
engine=InnoDB;

create table if not exists tienda(
	id_tienda char(3) primary key,
    nom_tienda varchar(15),
    id_ciudad char(3),
    foreign key (id_ciudad) references ciudad (id_ciudad)
    on update cascade
    on delete cascade
)
engine=InnoDB;

create table if not exists vendedores(
	id_vend varchar(3) primary key,
    nom_vend varchar(10),
    salario double,
    id_tienda varchar(3),
    foreign key (id_tienda) references tienda (id_tienda)
    on update cascade
    on delete cascade
)
engine=InnoDB;


create table if not exists articulos(
	id_art varchar(3) primary key,
    nom_art varchar(10),
    precio double,
    id_tipo varchar(3),
    foreign key (id_tipo) references tipoart (id_tipo)
    on update cascade
    on delete cascade
)
engine=InnoDB;

create table if not exists vendart(
	id_vend varchar(3),
    id_art char(3),
	fech_venta date,
    primary key (id_vend, id_art, fech_venta),
    foreign key (id_vend) references vendedores (id_vend)
    on update cascade
    on delete cascade,
    foreign key (id_art) references articulos (id_art)
    on update cascade
    on delete cascade
)
engine=InnoDB;
describe vendart;

insert into ciudad values
("CI1", "SEVILLA"),
("CI2", "ALMERIA"),
("CI3", "GRANADA");

insert into tipoart values
("TI1", "BAZAR"),
("TI2", "COMESTIBLES"),
("TI3", "PAPELERIA");

insert into tienda values
("TD1", "BAZARES S.A.", "CI1"),
("TD2", "CADENAS S.A.", "CI1"),
("TD3", "MIRROS S.L.", "CI2"),
("TD4", "LUNA", "CI3"),
("TD5", "MAS S.A.", "CI3"),
("TD6", "JOYMON", "CI2");

insert into vendedores values
("VN1", "JUAN", 1090, "TD1"),
("VN2", "PEPE", 1034, "TD1"),
("VN3", "LUCAS", 1100, "TD2"),
("VN4", "ANA", 890, "TD2"),
("VN5", "PEPA", 678, "TD3"),
("VN6", "MANUEL", 567, "TD2"),
("VN7", "LORENA", 1100, "TD3");

insert into articulos values
("AR1", "RADIO", 78, "TI1"),
("AR2", "CARNE", 15, "TI2"),
("AR3", "BLOC", 5, "TI3"),
("AR4", "DVD", 24, "TI1"),
("AR5", "PESCADO", 23, "TI2"),
("AR6", "LECHE", 2, "TI2"),
("AR7", "CAMARA", 157, "TI1"),
("AR8", "LAPIZ", 1, "TI3"),
("AR9", "BOMBILLA", 2, "TI1");

insert into vendart values
("VN1", "AR1", "2005-02-01"),
("VN1", "AR2", "2005-02-01"),
("VN2", "AR3", "2005-03-01"),
("VN1", "AR4", "2005-04-01"),
("VN1", "AR5", "2005-06-01"),
("VN3", "AR6", "2005-07-01"),
("VN3", "AR7", "2005-08-01"),
("VN3", "AR8", "2001-09-12"),
("VN4", "AR9", "2005-10-10"),
("VN4", "AR8", "2005-11-01"),
("VN5", "AR7", "2005-10-01"),
("VN5", "AR6", "2005-11-02"),
("VN6", "AR5", "2005-11-03"),
("VN6", "AR4", "2005-11-04"),
("VN7", "AR3", "2005-11-05"),
("VN7", "AR2", "2005-11-07"),
("VN1", "AR2", "2005-11-06"),
("VN2", "AR1", "2004-10-08"),
("VN3", "AR2", "1999-01-01"),
("VN4", "AR3", "2005-10-25"),
("VN5", "AR4", "2005-10-26"),
("VN5", "AR5", "2005-10-27"),
("VN6", "AR6", "2005-10-28"),
("VN5", "AR7", "2005-10-28"),
("VN4", "AR8", "2005-10-30"),
("VN3", "AR9", "2005-08-24"),
("VN7", "AR9", "2005-08-25");

/*1.- CIUDAD DONDE MAS SE VENDIO*/
select c.nom_ciudad, count(ven.id_art)
from ciudad as c
inner join tienda as t on c.id_ciudad=t.id_ciudad
inner join vendedores as v on t.id_tienda=v.id_tienda
inner join vendart as ven on v.id_vend=ven.id_vend
group by c.nom_ciudad
having count(ven.id_art) = (select count(id_art)
							from vendart as ven
							inner join vendedores as v on v.id_vend=ven.id_vend
							inner join tienda as t on t.id_tienda=v.id_tienda
                            inner join ciudad as c on c.id_ciudad=t.id_ciudad
                            group by c.nom_ciudad
                            order by 1 desc limit 1);
							


/*2.- TIENDA DONDE MAS SE VENDIO*/
select t.nom_tienda as "Tienda", count(ven.id_art) as "Ventas"
from tienda as t
inner join vendedores as v on t.id_tienda=v.id_tienda
inner join vendart as ven on v.id_vend=ven.id_vend
group by t.nom_tienda
having count(ven.id_art)=(select count(id_art)
							from vendart as ven
							inner join vendedores as v on v.id_vend=ven.id_vend
							inner join tienda as t on t.id_tienda=v.id_tienda
                            group by t.nom_tienda
                            order by 1 desc limit 1);




/*3.- VENDEDOR QUE MAS VENDIO*/
select nom_vend as "Vendedores", count(ven.id_art) as "Ventas"
from vendedores as v 
inner join vendart as ven on v.id_vend=ven.id_vend
group by v.id_vend
having count(ven.id_art)=(select count(ven.id_art)
							from vendart as ven
                            inner join vendedores as v on ven.id_vend=v.id_vend
                            group by v.id_vend
                            order by 1 desc limit 1);


/*4.-NOMBRE DE CIUDAD, VENDEDOR, ARTICULO, TIENDA, TIPO Y PRECIO DE TODO LO VENDIDO*/
select nom_ciudad as "Ciudad", nom_vend as "Vendedor", nom_art as "Artículo", nom_tienda as "Tienda", 
		nom_tipo as "Tipo artículo", precio as "Vendido"
from ciudad as c
inner join tienda as t on c.id_ciudad=t.id_ciudad
inner join vendedores as v on t.id_tienda=v.id_tienda
inner join vendart as ven on v.id_vend=ven.id_vend
inner join articulos as a on ven.id_art=a.id_art
inner join tipoart as tipo on a.id_tipo=tipo.id_tipo;



/*5.- NOMBRE DEL TIPO DE ARTICULO MAS CARO*/
select t.nom_tipo as "Tipo artículo", a.precio as "Precio"
from tipoart as t
inner join articulos as a on t.id_tipo=a.id_tipo
where a.precio=(select max(precio)
						from articulos);

/*6.- DATOS DEL VENDEDOR QUE MAS GANA*/
select v.*
from vendedores as v
where salario=(select max(salario)
				from vendedores);

/*7.- MONTANTE DE TODOS LOS ARTICULOS DE TIPO BAZAR*/
select sum(a.precio) as "MONTANTE"
from articulos as a
inner join tipoart as t on a.id_tipo=t.id_tipo
inner join vendart as ven on a.id_art=ven.id_art
where nom_tipo like "BAZAR";


/*8.- MONTANTE DE TODO LO QUE SE VENDIO EN ALMERIA*/
select sum(a.precio) as "MONTANTE"
from articulos as a
inner join vendart as ven on a.id_art=ven.id_art
inner join vendedores as v on ven.id_vend=v.id_vend
inner join tienda as t on v.id_tienda=t.id_tienda
inner join ciudad as c on t.id_ciudad=c.id_ciudad
where nom_ciudad like "ALMERIA";


/*9.- MONTANTE DE TODO LO QUE SE VENDIO EN LUNA*/
select ifnull(sum(a.precio), "NO SE HA VENDIDO NADA") as "MONTANTE"
from articulos as a
inner join vendart as ven on a.id_art=ven.id_art
inner join vendedores as v on ven.id_vend=v.id_vend
inner join tienda as t on v.id_tienda=t.id_tienda
where nom_tienda like "LUNA";

/*10.- NOMBRE DE ARTICULO, TIPO, PRECIO, TIENDA, CIUDAD Y FECHA DE LO QUE VENDIO MANUEL*/
select a.nom_art as Articulo, a.precio as Precio, tipo.nom_tipo as Tipo,
 t.nom_tienda as Tienda, c.nom_ciudad as Ciudad, ven.fech_venta as Fecha
from tipoart as tipo
inner join articulos as a on tipo.id_tipo=a.id_tipo
inner join vendart as ven on a.id_art=ven.id_art
inner join vendedores as v on ven.id_vend=v.id_vend
inner join tienda as t on v.id_tienda=t.id_tienda
inner join ciudad as c on t.id_ciudad=c.id_ciudad
where nom_vend like "MANUEL";

/*11.- TOTAL DEL SALARIO DE TODOS LOS TRABAJADORES DE ALMERIA*/
select sum(v.salario) as "Salario total"
from vendedores as v
inner join tienda as t on v.id_tienda=t.id_tienda
inner join ciudad as c on t.id_ciudad=c.id_ciudad
where nom_ciudad like "ALMERIA";

/*12.- NOMBRE DE LOS QUE VENDIERON LECHE*/
select v.nom_vend as "Nombre vendedores"
from vendedores as v
inner join vendart as ven on ven.id_vend=v.id_vend
inner join articulos as a on ven.id_art=a.id_art
where nom_art like "LECHE";

/*13.- NOMBRE DE LOS QUE VENDIERON ARTICULOS DE TIPO BAZAR.*/
select distinct v.nom_vend as "Nombre vendedores"
from vendedores as v
inner join vendart as ven on ven.id_vend=v.id_vend
inner join articulos as a on ven.id_art=a.id_art
inner join tipoart as t on a.id_tipo=t.id_tipo
where nom_tipo like "BAZAR";

/*14.- ARTICULOS DE TIPO BAZAR MAS VENDIDOS*/
select a.nom_art as "Artículo", count(ven.id_art) as "Ventas"
from articulos as a
inner join vendart as ven on a.id_art=ven.id_art
inner join tipoart as t on a.id_tipo=t.id_tipo
group by t.nom_tipo, a.nom_art
having nom_tipo like "BAZAR"
and count(ven.id_art)=(select count(ven.id_art)
						from articulos as a
						inner join tipoart as t on a.id_tipo=t.id_tipo
						inner join vendart as ven on a.id_art=ven.id_art
						group by a.nom_art, t.nom_tipo
						having nom_tipo like "BAZAR"
						order by 1 desc limit 1);


/*15.- NOMBRE DEL TIPO CON QUE MAS SE GANA*/
select sum(precio)
from tipoart as t 
inner join articulos as a on t.id_tipo=a.id_tipo
inner join vendart as ven on a.id_art=ven.id_art
group by a.id_tipo
order by 1 desc;


/*16.- SALARIO Y NOMBRE DE TODOS LOS QUE VENDIERON BOMBILLAS.*/
select distinct v.salario, v.nom_vend as "Empleado"
from vendedores as v
inner join vendart as ven on v.id_vend=ven.id_vend
inner join articulos as a on ven.id_art=a.id_art
where nom_art like "BOMBILLA"
order by 1;

/*17.- TIENDAS Y CIUDAD DONDE SE VENDIO ALGUNA RADIO.*/
select distinct t.nom_tienda, c.nom_ciudad
from tienda as t
inner join ciudad as c on t.id_ciudad=c.id_ciudad
inner join vendedores as v on t.id_tienda=v.id_tienda
inner join vendart as ven on v.id_vend=ven.id_vend
inner join articulos as a on ven.id_art=a.id_art
where nom_art like "RADIO";

/*18.- SUBIR EL SUELDO UN 2% A LOS EMPLEADOS DE SEVILLA*/
update vendedores set salario=(salario * 1.02)
where id_tienda in (select t.id_tienda
				from tienda as t
                inner join ciudad as c on t.id_ciudad=c.id_ciudad
                where nom_ciudad like "SEVILLA");
select *
from vendedores;

/*19.- BAJA EL SUELDO UN 1% A LOS QUE NO HAYAN VENDIDO LECHE*/
update vendedores set salario=(salario * 0.99)
where id_vend not in (select id_vend
						from vendart as ven
                        inner join articulos
                        where nom_art like "LECHE");

/*20.- SUBIR EL PRECIO UN 3% AL ARTICULO MAS VENDIDO*/
update articulos set precio=(precio * 1.03)
where id_art in (select id_art
				from vendart as ven
                group by id_art
                having id_art=(select id_art
								from vendart as ven
                                group by id_art
								order by 1 limit 1));
select *
from articulos;

/*21.- SUBIR EL SUELDO UN 2% A LOS ARTICULOS DE TIPO MAS VENDIDO*/
create view masVendido as (select a.id_tipo
								from vendart as ven
								inner join articulos as a
								on ven.id_art=a.id_art
								group by a.id_tipo
								having count(ven.id_art)=(select count(ven.id_art)
															from vendart as ven
															inner join articulos as a
															on ven.id_art=a.id_art
															group by a.id_tipo
															order by 1 limit 1));

update articulos set precio=(precio * 1.02)
where id_tipo in (select id_tipo
				from masVendido);
                
select * from articulos;


/*22.- BAJAR UN 3% TODOS LOS ARTICULOS DE PAPELERIA*/
/*23.- SUBIR EL PRECIO UN 1% A TODOS LOS ARTICULOS VENDIDOS EN ALMERIA*/
/*24.- BAJAR EL PRECIO UN 5% AL ARTICULO QUE MAS HACE QUE NO SE VENDE*/
/*25.- CERRAR LA TIENDA QUE MENOS HA VENDIDO*/
/*26.- LA TIENDA LUNA PASA A LLAMARSE SOL Y LUNA*/
/*27.- DESPEDIR AL TRABAJADOR QUE MAS VENDIO*/
/*28.- LAS TIENDAS QUE NO VENDIERON LAPICES PASAN TODAS A SEVILLA*/
/*29.- DESPEDIR AL QUE MENOS DINERO HA HECHO VENDIENDO.*/
/*30.- EL ARTICULO QUE MENOS SE HA VENDIDO DEJAR DE ESTAR EN STOCK*/
/*31.- EL ARTICULO QUE MENOS DINERO HA GENERADO DEJA DE ESTAR EN STOCK*/
/*32.- EL TIPO DE ARTICULO MENOS VENDIDO DEJA DE ESTAR EN STOCK*/
/*33.- EL TIPO DE ARTICULO CON EL QUE MENOS SE HA GANADO DEJA DE ESTAR EN STOCK*/
/*34.- SE DESPIDEN A TODOS LOS TRABAJADORES QUE NO HAN VENDIDO ARTICULOS DE BAZAR*/
/*35.- SE CIERRA LA TIENDA QUE MENOS DINERO HA GANADO.*/
/*36.- TODOS LOS TRABAJADORES DE SEVILLA PASAN A LA TIENDA JOYMON*/











