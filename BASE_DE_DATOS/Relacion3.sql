drop database if exists Relacion3;
create database if not exists Relacion3;
use Relacion3;
show databases;
show tables;

create table if not exists provincia(
id_prov char(3) primary key,
nom_prov varchar(15)
)
engine=InnoDB;
describe provincia;

create table if not exists ciudad(
id_ciud char(3) primary key,
nom_ciud varchar(20),
num_hab int,
id_prov char(3),
foreign key (id_prov) references provincia (id_prov)
on delete cascade
)
engine=InnoDB;
describe ciudad;

create table if not exists zona(
id_zona char(3) not null,
nom_zona varchar(10),
id_ciud char(3),
primary key (id_zona, id_ciud),
foreign key (id_ciud) references ciudad (id_ciud)
on delete cascade
)
engine=InnoDB;
describe zona;

create table if not exists cartero(
id_cart char(3) primary key,
nom_cart varchar(25),
sueldo int
)
engine=InnoDB;
describe cartero;

create table if not exists periodos(
id_per char(3) primary key,
fecha_ini date,
fecha_fin date
)
engine=InnoDB;
describe periodos;

create table if not exists relacion2(
id_zona char(3),
id_ciud char(3),
id_cart char(3),
id_per char(3),
foreign key (id_zona) references zona (id_zona)
on delete cascade,
foreign key (id_ciud) references ciudad (id_ciud)
on delete cascade,
foreign key (id_cart) references cartero (id_cart)
on delete cascade,
foreign key (id_per) references periodos (id_per)
on delete cascade
)
engine=InnoDB;
describe relacion2;

insert into provincia values
("P01", "SEVILLA"),
("P02", "GRANADA"),
("P03", "ALMERIA");

insert into ciudad values
("C01", "CIUDAD1", 890000, "P01"),
("C02", "CIUDAD2", 110000, "P02"),
("C03", "CIUDAD3", 98000, "P03"),
("C04", "CIUDAD4", 65000, "P01");

insert into zona values
("Z01", "CENTRO", "C01"),
("Z02", "ESTE", "C01"),
("Z03", "OESTE", "C01"),
("Z04", "NORTE", "C01"),
("Z05", "SUR", "C01"),
("Z01", "CENTRO", "C02"),
("Z02", "POLIGONO", "C02"),
("Z03", "OESTE", "C02"),
("Z04", "NORTE", "C02"),
("Z05", "SUR", "C02"),
("Z01", "CENTRO", "C03"),
("Z02", "ESTE", "C03"),
("Z03", "BARRIADAS", "C03"),
("Z04", "NORTE", "C03"),
("Z05", "SUR", "C03"),
("Z01", "CENTRO", "C04"),
("Z02", "BULEVARD", "C04"),
("Z03", "OESTE", "C04"),
("Z04", "NORTE", "C04"),
("Z05", "RIVERA", "C04");

insert into cartero values
("CT1", "JUAN PEREZ", 1100),
("CT2", "ANA TORRES", 1080),
("CT3", "PEPA FERNANDEZ", 1100),
("CT4", "VICENTE VALLES", 1790),
("CT5", "FERNANDO GINES", 1013),
("CT6", "LISA TORRES", 897),
("CT7", "WALDO PEREZ", 899),
("CT8", "KIKA GARCIA", 987),
("CT9", "LOLA JIMENEZ", 1123);

insert into periodos values
("PE1", "2000-05-01", "2000-03-30"),
("PE2", "2000-03-30", "2000-08-15"),
("PE3", "2000-08-15", "2000-11-20"),
("PE4", "2000-11-20", "2000-12-25"),
("PE5", "2000-12-25", "2001-03-03");

insert into relacion2 values
("Z01", "C01", "CT1", "PE1"),
("Z01", "C02", "CT2", "PE1"),
("Z01", "C03", "CT3", "PE1"),
("Z01", "C04", "CT4", "PE1"),
("Z02", "C01", "CT5", "PE1"),
("Z02", "C02", "CT6", "PE1"),
("Z02", "C03", "CT7", "PE1"),
("Z02", "C04", "CT8", "PE1"),
("Z03", "C01", "CT9", "PE1"),
("Z03", "C02", "CT1", "PE2"),
("Z03", "C03", "CT2", "PE2"),
("Z03", "C04", "CT3", "PE2"),
("Z04", "C01", "CT4", "PE2"),
("Z04", "C02", "CT5", "PE2"),
("Z04", "C03", "CT6", "PE2"),
("Z04", "C04", "CT7", "PE2"),
("Z05", "C01", "CT8", "PE2"),
("Z05", "C02", "CT9", "PE2"),
("Z05", "C03", "CT1", "PE3"),
("Z05", "C04", "CT2", "PE3"),
("Z01", "C01", "CT3", "PE3"),
("Z02", "C02", "CT4", "PE3"),
("Z03", "C01", "CT5", "PE3"),
("Z04", "C01", "CT6", "PE3"),
("Z05", "C01", "CT7", "PE3"),
("Z01", "C01", "CT8", "PE4"),
("Z02", "C03", "CT9", "PE3"),
("Z03", "C04", "CT1", "PE4"),
("Z04", "C01", "CT2", "PE4"),
("Z05", "C01", "CT3", "PE4");

/*CONSULAS*/
/*NOMBRE DE CIUDAD CON MÁS HABITANTES*/
select nom_ciud
from ciudad
where num_hab = (select max(num_hab)
				 from ciudad);
                 
/*NOMBRE DEL CARTERO CON MAYOR SUELDO*/
select nom_cart
from cartero
where sueldo = (select max(sueldo)
				 from cartero);
                 
/*NOMBRE CIUDADES, Nº HABITANTES DE LA PROVINCIA DE SEVILLA*/
select nom_ciud, num_hab
from ciudad, provincia
where ciudad.id_prov=provincia.id_prov
and nom_prov="SEVILLA";

/*Usamos JOIN para relacionar las tablas*/
select nom_ciud, num_hab
from ciudad
inner join provincia
on ciudad.id_prov=provincia.id_prov
and nom_prov like "SEVILLA";

/* CARTEROS ORDENADOS POR SULEDO.*/
select nom_cart
from cartero
order by sueldo;

/*NOMBRE DE CIUDAD Y NOMBRE DE ZONA*/
select nom_ciud, nom_zona
from ciudad, zona
where ciudad.id_ciud=zona.id_ciud;

/*ZONAS DE LA C02*/
select *
from zona
where id_ciud="C02";

/*ZONAS DE LA CIUDAD “CIUDAD3”.*/
select *
from zona, ciudad
where zona.id_ciud=ciudad.id_ciud
and nom_ciud="CIUDAD3";

/*NOMBRE DE LOS CARTEROS QUE HAN TRABAJADO EN LA ZONA “Z01,C02”*/
select nom_cart
from cartero, zona, relacion2
where cartero.id_cart=relacion2.id_cart
and zona.id_zona=relacion2.id_zona
and zona.id_zona="Z01" and zona.id_ciud="C02";

/*NOMBRE DE LOS CARTEROS QUE HAN TRABAJADO EN LA ZONA CENTRO DE LA CIUDAD1*/
select distinct nom_cart
from cartero, zona, relacion2, ciudad
where cartero.id_cart=relacion2.id_cart
and zona.id_zona=relacion2.id_zona
and relacion2.id_ciud=ciudad.id_ciud
and zona.nom_zona="CENTRO" and ciudad.nom_ciud="CIUDAD1";

/*Con JOIN*/
select distinct nom_cart
from cartero
join relacion2
on cartero.id_cart=relacion2.id_cart
join zona
on zona.id_zona=relacion2.id_zona
join ciudad
on relacion2.id_ciud=ciudad.id_ciud
and zona.nom_zona like "CENTRO" and ciudad.nom_ciud like "CIUDAD1";

/* NOMBRE DE LOS CARTEROS (Y FECHAS DE INICIO Y FIN) QUE HAN TRABAJADO EN LA RIVERA
DE LA CIUDAD 4.*/
select cartero.nom_cart, periodos.fecha_ini, periodos.fecha_fin
from cartero, zona, ciudad, periodos, relacion2
where cartero.id_cart=relacion2.id_cart
and zona.id_zona=relacion2.id_zona
and relacion2.id_ciud=ciudad.id_ciud
and relacion2.id_per=periodos.id_per
and zona.nom_zona="RIVERA" and ciudad.nom_ciud="CIUDAD4";

/* NOMBRE DE LOS CARTEROS QUE HAN TRABAJADO EN LA PROVINCIA DE SEVILLA*/
select distinct car.nom_cart
from cartero as car, provincia as prov, relacion2 as rel, ciudad as ciu
where car.id_cart=rel.id_cart
and rel.id_ciud=ciu.id_ciud
and ciu.id_prov=prov.id_prov
and prov.nom_prov not like "SEVILLA";

/* NOMBRE Y SUELDO DE LOS CARTEROS QUE NO HAN TRABAJADO EN LA RIVERA DE LA
CIUDAD4.*/
select distinct car.nom_cart, sueldo
from cartero as car
where car.id_cart not in (select r.id_cart
							from relacion2 as r
							join ciudad as c on r.id_ciud like c.id_ciud
                            join zona as z on z.id_zona like r.id_zona
                            where z.nom_zona like "RIVERA"
                            and c.nom_ciud like "CIUDAD4");


/*FECHA DE INICIO Y FIN DE LOS PERIODOS EN QUE MAS CARTEROS HAN TRABAJADO*/
select per.fecha_ini, per.fecha_fin
from periodos as per, cartero as car, relacion2 as rel
where per.id_per=rel.id_per
and rel.id_cart=car.id_cart
group by per.fecha_ini, per.fecha_fin
having count(car.id_cart)=(select count(car2.id_cart)
							from periodos as per2, cartero as car2, relacion2 as rel2
                            where per2.id_per=rel2.id_per
							and rel2.id_cart=car2.id_cart
							group by per2.id_per
                            order by count(car2.id_cart) desc limit 1);
                            
/*Número de habitantes por cada provincia*/
select sum(num_hab), id_prov
from ciudad
group by id_prov;

/*Nombre de la zona que más carteros ha tenido (y nº de carteros)*/
select distinct z.nom_zona, count(r.id_cart)
from zona as z
join relacion2 as r on z.id_zona=r.id_zona
group by z.nom_zona, r.id_ciud
having count(r.id_cart)=(select count(id_cart)
						from relacion2
                        group by id_zona, id_ciud
                        order by 1 desc limit 1);









										






































