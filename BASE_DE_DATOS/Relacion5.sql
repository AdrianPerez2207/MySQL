drop database if exists relacion5;
create database if not exists relacion5;
use relacion5;
show databases;

create table if not exists departamento(
	cod_dep char(2) primary key,
    nom_dep varchar(30),
    ciudad varchar(20)
)
engine=InnoDB;
describe departamento;

create table if not exists empleado(
	cod_emp char(3) primary key,
    nom_emp varchar(30),
    fecha_ingreso date,
    cod_jefe char(3),
    cod_dep char(2),
    foreign key (cod_jefe) references empleado (cod_emp)
    on update cascade on delete set null,
    foreign key (cod_dep) references departamento (cod_dep)
    on update cascade on delete restrict
)
engine=InnoDB;
describe empleado;

create table if not exists proyecto(
	cod_pro char(3) primary key,
    nom_pro varchar(30),
    cod_dep char(2),
    foreign key (cod_dep) references departamento (cod_dep)
    on update cascade on delete restrict
)
engine=InnoDB;
describe proyecto;

create table if not exists trabaja(
	cod_emp char(3),
    cod_pro char(3),
    nhoras integer,
    primary key (cod_emp, cod_pro),
    foreign key (cod_emp) references empleado (cod_emp)
    on update cascade on delete cascade,
    foreign key (cod_pro) references proyecto (cod_pro)
    on update cascade on delete cascade
)
engine=InnoDB;
describe trabaja;


insert into departamento values
("01", "Contabilidad-1", "Almería"),
("02", "Ventas", "Almería"),
("03", "I+D", "Málaga"),
("04", "Gerencia", "Córdoba"),
("05", "Administración", "Córdoba"),
("06", "Contabilidad-2", "Córdoba");

insert into empleado values
("A11", "Esperanza Amarillo", "1993-09-23", NULL, "04"),
("A03", "Pedro Rojo", "1995-03-07", "A11", "01"),
("C01", "Juan Rojo", "1997-02-03", "A03", "01"),
("B02", "María Azul", "1996-01-09", "A03", "01"),
("A07", "Elena Blanco", "1994-04-09", "A11", "02"),
("B06", "Carmen Violeta", "1997-02-03", "A07", "02"),
("C05", "Alfonso Amarillo", "1998-12-03", "B06", "02"),
("C04", "Ana Verde", NULL, "A07", "02"),
("B09", "Pablo Verde", "1998-10-12", "A11", "03"),
("C08", "Javier Naranja", NULL, "B09", "03"),
("A10", "Dolores Blanco", "1998-11-15", "A11", "04"),
("B12", "Juan Negro", "1997-02-03", "A11", "05"),
("A13", "Jesús Marrón", "1999-02-21", "A11", "05"),
("A14", "Manuel Amarillo", "2000-09-01", "A11", NULL);

insert into proyecto values
("GRE", "Gestión residuos", "03"),
("DAG", "Depuración de aguas", "03"),
("AEE", "Análisis económico energías", "04"),
("MES", "Marketing de energía solar", "02");

insert into trabaja values
("C01", "GRE", 10),
("C08", "GRE", 54),
("C01", "DAG", 5),
("C08", "DAG", 150),
("B09", "DAG", 100),
("A14", "DAG", 10),
("A11", "AEE", 15),
("C04", "AEE", 20),
("A11", "MES", 0),
("A03", "MES", 0);

/*Nombre de los empleados que han trabajado más de 50 horas en proyectos.*/
select nom_emp, sum(nhoras)
from empleado
join trabaja on trabaja.cod_emp like empleado.cod_emp
join proyecto on trabaja.cod_pro like proyecto.cod_pro
group by nom_emp
having sum(nhoras) > 50;

/*Nombre de los departamentos que tienen empleados con apellido “Verde”.*/
select nom_dep
from departamento as de
join empleado as em on em.cod_dep like de.cod_dep
where nom_emp like "% VERDE";

/*Nombre de los proyectos en los que trabajan más de dos empleados*/
select nom_pro, count(e.cod_emp)
from proyecto as p
join trabaja as t on p.cod_pro like t.cod_pro
join empleado as e on t.cod_emp like e.cod_emp
group by p.nom_pro
having count(e.cod_emp) > 2;

/*Lista de los empleados y el departamento al que pertenecen, con indicación del dinero total que
deben percibir, a razón de 35 euros la hora. La lista se presentará ordenada por orden alfabético
de nombre de empleado, y en caso de que no pertenezcan a ningún departamento (NULL) debe
aparecer la palabra “DESCONOCIDO”.*/

/*Lista de los nombres de todos los empleados, y el número de proyectos en los que está
trabajando (ten en cuenta que algunos empleados no trabajan en ningúb proyecto).*/
select nom_emp, count(p.cod_pro)
from empleado as e
left join trabaja as t on e.cod_emp like t.cod_emp
left join proyecto as p on t.cod_pro like p.cod_pro
group by nom_emp
order by 2 asc;





