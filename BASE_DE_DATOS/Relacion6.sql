drop database if exists examen_adrian1;
create database if not exists examen_adrian1;
use examen_adrian1;
show databases;

create table if not exists cliente(
	id_cli char(3) primary key,
    nom_cli varchar(25),
    telf_cli varchar(9)
)
engine=InnoDB;
describe cliente;

create table if not exists alojamiento(
	id_aloj char(3) primary key,
    nom_aloj varchar(25),
    habitaciones integer,
    categoria varchar(5)
)
engine=InnoDB;
describe alojamiento;

create table if not exists cli_aloj(
	id_cli char(3),
    id_aloj char(3),
    fech_entrada date,
    fech_salida date,
    precio double,
    primary key (id_cli, id_aloj, fech_entrada),
    foreign key (id_cli) references cliente (id_cli)
    on update cascade on delete cascade,
    foreign key (id_aloj) references alojamiento (id_aloj)
    on update cascade on delete cascade
)
engine=InnoDB;
describe cli_aloj;

create table if not exists empleado(
	id_emp char(3) primary key,
    nom_emp varchar(25),
    sueldo double,
    id_aloj char(3),
    foreign key (id_aloj) references alojamiento (id_aloj)
    on update cascade on delete cascade
)
engine=InnoDB;
describe empleado;

insert into cliente values
("C01", "JUAN FERNÁNDEZ", 898765678),
("C02", "ANA GARCÍA", 678987567),
("C03", "PEPA FLORES", 432123456),
("C04", "JOSÉ LINARES", 950122145),
("C05", "LUIS JARCIA", 954678763),
("C06", "XAVI PÉREZ", 900873221),
("C07", "LUISA JUANES", 878909876),
("C08", "HILARIO PINO", 675121234),
("C09", "CARMEN CONSUEGRA", 123234789),
("C10", "VICENTA FERRER", 924866378),
("C11", "OLIVIA GINESA", 789123456),
("C12", "JUANJO DÍAZ", 911234321);

insert into alojamiento values
("A01", "TERRAZA CARMONA", 100, "***"),
("A02", "VALLE DEL ESTE", 250, "****"),
("A03", "HOSTAL LUCERO", 17, "**"),
("A04", "VERA PLAYA", 350, "****"),
("A05", "HOTEL MEXICO", 80, "****");

insert into cli_aloj values
("C01", "A01", "2013-03-01", "2013-03-10", 345),
("C02", "A01", "2013-04-01", "2013-04-02", 60),
("C03", "A01", "2013-03-02", "2013-03-11", 540),
("C04", "A02", "2013-04-03", "2013-04-10", 420),
("C05", "A02", "2013-05-04", "2013-05-10", 395),
("C06", "A02", "2013-06-05", "2013-06-10", 145),
("C07", "A02", "2013-07-06", "2013-07-10", 450),
("C08", "A03", "2013-08-07", "2013-08-10", 344),
("C09", "A03", "2013-08-08", "2013-08-10", 349),
("C10", "A03", "2013-10-09", "2013-10-10", 145),
("C11", "A03", "2013-11-11", "2013-11-15", 245),
("C12", "A03", "2013-12-21", "2013-12-30", 600),
("C01", "A04", "2013-09-05", "2013-09-07", 148),
("C02", "A03", "2013-10-07", "2013-10-14", 849),
("C03", "A03", "2013-03-11", "2013-03-15", 248),
("C04", "A03", "2013-03-21", "2013-03-30", 345),
("C05", "A01", "2013-03-11", "2013-03-19", 149),
("C06", "A02", "2013-06-21", "2013-06-30", 315),
("C01", "A01", "2013-01-11", "2013-01-20", 319),
("C04", "A05", "2014-02-14", "2014-02-16", 300),
("C09", "A05", "2014-03-07", "2014-03-09", 400);

insert into empleado values
("E01", "MANUEL MURCIA", 1400, "A01"),
("E02", "GINÉS ASENSIO FERNÁNDEZ", 1500, "A01"),
("E03", "BALTASAR PARRA GIMÉNEZ", 950, "A02"),
("E04", "ROSA PÉREZ GARCÍA", 1300, "A03"),
("E05", "JOSÉ MIGUEL MARTÍNEZ CANO", 1150, "A04"),
("E06", "ANTONIO FERNÁNDEZ SOTO", 1200, "A05"),
("E07", "ANA GARCÍA GIMÉNEZ", 1100, "A04"),
("E08", "MARÍA CAPARROS GÓMEZ", 1300, "A04"),
("E09", "ALICIA FLORES DÍAZ", 1500, "A05");

/*Nombre de los alojamientos de cuatro estrellas que tienen mayor número de 
habitaciones.*/
select nom_aloj, habitaciones
from alojamiento
where categoria like "****"
group by habitaciones, nom_aloj
having habitaciones=(select habitaciones
					from alojamiento
					order by 1 desc limit 1);

/*Datos de los empleados cuyo sueldo está comprendido entre 900 y 1200 euros
ordenados de mayor a menor sueldo.*/
select *
from empleado
where sueldo > 900
and sueldo < 1200
order by sueldo desc;

/*Datos de los empleados cuyo sueldo es mayor que la media de todos los 
empleados*/
select *
from empleado
group by id_emp
having sueldo>(select avg(sueldo)
				from empleado);

/*Nombre de los clientes que se han hospedado en el Alojamiento Vera Playa.*/
select nom_cli
from cliente
join cli_aloj on cliente.id_cli like cli_aloj.id_cli
join alojamiento as aloj on aloj.id_aloj like cli_aloj.id_aloj
where aloj.nom_aloj like "VERA PLAYA"; 


/*Nombres de los clientes y dinero total que se han gastado en alojarse*/
select nom_cli, sum(cli_aloj.precio)
from cliente 
join cli_aloj on cliente.id_cli like cli_aloj.id_cli
group by nom_cli
order by sum(cli_aloj.precio) desc;


/*Nombre de los alojamientos y fechas en los que ha estado hospedado el cliente 
XAVI PÉREZ, ordenado por el nombre del hotel*/
select nom_aloj, fech_entrada, fech_salida
from alojamiento as alo
join cli_aloj on alo.id_aloj like cli_aloj.id_aloj
join cliente as cli on cli.id_cli like cli_aloj.id_cli
where cli.nom_cli like "XAVI PÉREZ"
order by alo.nom_aloj;


/*Datos del cliente/s que más establecimientos ha visitado.*/
select cliente.*, count(cli_aloj.id_aloj)
from cliente
join cli_aloj on cliente.id_cli like cli_aloj.id_cli
group by cliente.id_cli
having count(cli_aloj.id_aloj)=(select count(cli_aloj.id_aloj)
							from cli_aloj
                            group by cli_aloj.id_cli
							order by 1 desc limit 1);


/*Listado de alojamientos, donde aparezca el nombre de cada alojamiento y el 
dinero que ha ganado en los hospedajes ordenados por nombre del alojamiento.*/
select nom_aloj, sum(cli_aloj.precio)
from alojamiento as aloj
join cli_aloj on cli_aloj.id_aloj like aloj.id_aloj
group by nom_aloj
order by 1 asc;

/*El nombre del empleado y nombre del alojamiento en que trabaja el empleado 
que menor sueldo tiene.*/
select nom_emp, nom_aloj, sueldo
from empleado as emp
join alojamiento as aloj on emp.id_aloj like aloj.id_aloj
where sueldo=(select sueldo
				from empleado
				order by sueldo asc limit 1);


/* Nombre del alojamiento o alojamientos con mayor número de empleados.*/
select nom_aloj, count(id_emp)
from alojamiento as aloj
join empleado as emp on emp.id_aloj like aloj.id_aloj
group by aloj.id_aloj
having count(id_emp)=(select count(id_emp)
					from empleado
                    group by id_aloj
                    order by 1 desc limit 1);


/*Listado que contenga la media del sueldo de los empleados por cada 
alojamiento. Donde aparezca la media del sueldo y el nombre del alojamiento*/
select nom_aloj, avg(sueldo)
from alojamiento as aloj
join empleado as emp on emp.id_aloj like aloj.id_aloj
group by nom_aloj
order by 2 desc;


/*El sueldo de los empleados que trabajan en el alojamiento HOSTAL LUCERO 
se incrementa en un 20% (es decir se actualiza la tabla empleados)*/
update empleado
set sueldo=(sueldo * 1.20)
where id_aloj=(select id_aloj
				from alojamiento 
                where nom_aloj like "HOSTAL LUCERO");

SET SQL_SAFE_UPDATES=0;
/*El alojamiento Terraza Carmona reduce el número de habitaciones a 75.*/
update alojamiento
set habitaciones=75
where nom_aloj like "TERRAZA CARMONA";


/*Añade un nuevo empleado con los datos que tu quieras menos el sueldo que 
será la media de todos empleados que ya tenemos y el número de empleado que 
será ‘E10’.*/
set @sueldo=(select avg(sueldo)
				from empleado);
insert into empleado values
("E10", "MARTIN EL FILOSO", @sueldo, "A04");

/* Borra los empleados que trabajen en Terraza Carmona*/
delete from empleado
where id_aloj=(select id_aloj
				from alojamiento
                where nom_aloj like "TERRAZA CARMONA");



