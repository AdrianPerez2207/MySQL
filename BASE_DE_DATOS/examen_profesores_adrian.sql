drop database if exists profesores;
create database if not exists profesores;
use profesores;
show databases;

create table if not exists instituto(
	Cdinsti char(2) primary key,
    nombre varchar(30),
    ciudad varchar(20)
)
engine=InnoDB;

create table if not exists profesores(
	cdprofe char(3) primary key,
    nombre varchar(30),
    fech_ingreso date,
    Cddirector char(3),
    Cdinsti char(2),
    foreign key (Cddirector) references profesores (cdprofe)
    on update cascade on delete set null,
    foreign key (Cdinsti) references instituto (Cdinsti)
    on update cascade on delete restrict
)
engine=InnoDB;

create table if not exists proyecto(
	Cdpro char(3) primary key,
    nombre varchar(60),
    Cdinsti char(2),
    foreign key (Cdinsti) references instituto (Cdinsti)
    on update cascade on delete restrict
)
engine=InnoDB;

create table if not exists trabaja(
	Cdprofe char(3),
    Cdpro char(3),
    nhoras integer,
    foreign key (Cdprofe) references profesores (cdprofe)
    on update cascade on delete cascade,
    foreign key (Cdpro) references proyecto (Cdpro)
    on update cascade on delete cascade,
    primary key (Cdprofe, Cdpro)
)
engine=InnoDB;

insert into instituto values 
("01", "IES Jaroso","Cuevas del Almanzora"),
("02", "IES El Palmeral","Vera"),
("03", "IES Alyanub","Vera"),
("04", "IES Cura Valera","Huercal Overa"),
("05", "IES Albujaira","Huercal Overa"),
("06", "IES cardenal Cisneros","Albox");

insert into profesores values
("A04", "EDUARDO ROJO", "2006-09-01", NULL, "01"),
("A01", "ANA VICENTE BELMONTE", "2022-09-01", "A04", "01"),
("A02", "CATALINA FLORES CAZORLA", "2018-09-01", "A04", "01"),
("A03", "JAVIER GUILLEN BENAVENTE", "1997-09-01", "A04", "01"),
("A05", "ELOY VILLAR", "2016-09-01", "A04", "01"),
("A06", "FRANCISCO MATIAS PRADO", "2016-09-01", "A04", "01"),
("A07", "FRANCISCO CARMONA", "1996-09-01", NULL, "02"),
("A08", "MARI CARMEN SOLER", "1996-09-01", "A07", "02"),
("A09", "RICARDO MASIP", "1996-10-10", "A07", "02"),
("A10", "ESPERANZA MANZANERA", NULL, "A07", "02"),
("A11", "MARTIN FLORES", "2010-09-01", NULL, "05"),
("A12", "FRANCISCA MARTINEZ DE HARO", "2014-09-01", "A11", "05"),
("A14", "JUAN ANGEL SOLER", "1995-09-01", NULL, "03"),
("A13", "MANOLI DIAZ", "1995-09-01", "A14", "03"),
("A15", "PABLO FLORES DIAZ", "2021-09-01", "A11", NULL),
("A16", "PEDRO GARCIA GARCIA", "1996-09-01", NULL, "06"),
("A17", "JESUSS MELLADO GARCIA", "1997-09-01", "A16", NULL);

insert into proyecto values
("CAE", "CUIDADOS AUXILIARES DE ENFERMERIA", "05"),
("DAW", "DESARROLLO DE APLICACIONES WEB", "01"),
("GAM", "GESTION ADMINISTRATIVA GRADO MEDIO", "01"),
("GAS", "GESTION ADMINISTRATIVA GRADO SUPERIOR", "03"),
("SMR", "SISTEMAS MICROINFORMATICOS Y REDES", "04");

insert into trabaja values
("A01", "DAW", 5),
("A02", "DAW", 120),
("A02", "SMR", 80),
("A03", "DAW", 180),
("A03", "SMR", 40),
("A04", "DAW", 0),
("A04", "SMR", 100),
("A05", "GAM", 20),
("A06", "GAS", 0),
("A11", "CAE", 100),
("A13", "GAM", 10),
("A14", "GAS", 0),
("A16", "DAW", 20);

/*1. Nombre del profesor o profesores/as que han trabajado más número de horas en
proyectos. La consulta debe mostrar el nombre del profesor y el número de horas.*/
select p.nombre, sum(t.nhoras)
from profesores as p
inner join trabaja as t on p.cdprofe=t.Cdprofe
group by t.Cdprofe
having sum(t.nhoras)=(select sum(t.nhoras)
						from trabaja as t
                        inner join profesores as p on t.Cdprofe=p.cdprofe
                        group by t.Cdprofe
                        order by 1 desc limit 1);


/*2. Listado de la máxima fecha y mínima fecha de ingreso de los profesores por cada
instituto (en el listado debe de aparecer la máxima fecha, mínima fecha y el nombre
del instituto).*/
select distinct i.nombre as Instituto, min(fech_ingreso) as "Fecha mínima", max(fech_ingreso) as "Fecha máxima"
from instituto as i
inner join profesores as p on i.Cdinsti=p.Cdinsti
group by i.Cdinsti
order by 1;

/*3. Nombre de los proyectos en los que trabajan menos de dos profesores.*/
select pro.nombre, count(t.Cdprofe) as Profesores
from proyecto as pro
inner join trabaja as t on t.Cdpro=pro.Cdpro
inner join profesores as p on t.Cdprofe=p.cdprofe
group by t.Cdpro
having count(t.Cdprofe) < 2;

/*4. Listado de los nombres de todos los profesores y el nombre del instituto al que
pertenecen, con indicación del dinero total que deben percibir, a razón de 20 euros la
hora de los proyectos en que trabajan.
La lista se presentará ordenada por orden alfabético de nombre del profesor, y en caso
de que no pertenezcan a ningún instituto debe aparecer la palabra “Sin instituto de
Referencia”.*/
select p.nombre as Profesor, ifnull(i.nombre, "Sin instituto de Referencia") as Instituto, sum(t.nhoras) * 20 as "Salario"
from profesores as p
right join instituto as i on p.Cdinsti=i.Cdinsti
right join trabaja as t on p.cdprofe=t.Cdprofe
group by t.Cdprofe
order by 1;

/*5. Lista de los nombres de todos los profesores, y el número de proyectos en los que está
trabajando (ten en cuenta que algunos profesores no trabajan en ningún proyecto)
ordenados por número de proyectos de menor a mayor.*/
select p.nombre as Profesores, count(t.Cdpro) as Proyectos
from profesores as p
right join trabaja as t on p.cdprofe=t.Cdprofe
right join proyecto on t.Cdpro=proyecto.Cdpro
group by t.Cdprofe
order by 2;

/*6. Listado de profesores que trabajan en Cuevas del Almanzora o en Huercal Overa.*/
select distinct p.nombre, i.ciudad
from profesores as p
inner join instituto as i on p.Cdinsti=i.Cdinsti
where i.ciudad like "CUEVAS DEL ALMANZORA"
or i.ciudad like "HUERCAL OVERA";

/*7. Lista alfabética de los nombres de profesores y los nombres de sus directores. Si el
profesor no tiene director debe aparecer la cadena “Es el director”.*/
select p.nombre, ifnull(d.nombre, "No tiene director")
from profesores as p
left join profesores as d on p.Cddirector=d.cdprofe
order by 1;

/*8. Media del año de ingreso de los profesores que trabajan en algún proyecto.*/
select round(avg(year(p.fech_ingreso))) as "Media ingreso"
from profesores as p 
inner join trabaja as t on t.Cdprofe=p.cdprofe
inner join proyecto on t.Cdpro=proyecto.Cdpro
order by 1; 

/*9. Nombre de los profesores que tienen de apellido Flores o Guillen, y simultáneamente
su director es Eduardo Rojo.*/
select p.nombre
from profesores as p
inner join profesores as d on p.Cddirector=d.cdprofe
where d.nombre like "EDUARDO ROJO" 
and (p.nombre like "%GUILLEN%" or p.nombre like "%FLORES%");

/*10. Listado de nombres de todos los instituto, ciudad del instituto y número de profesores
del instituto. Ordenada por nombre de ciudad y a igualdad de esta por el nombre del
instituto.*/
select i.nombre as "Institutos", i.ciudad as "Ciudad", count(p.cdprofe) as "nº de profesores"
from instituto as i
left join profesores as p on i.Cdinsti=p.Cdinsti
group by i.Cdinsti
order by 2, 1;

/*11. Lista de nombres de profesor que hayan trabajado entre 20 y 100 horas, entre todos
los proyectos en los que trabajan.*/
select p.nombre, sum(nhoras)
from profesores as p 
inner join trabaja as t on p.cdprofe=t.Cdprofe
inner join proyecto on t.Cdpro=proyecto.Cdpro
group by t.Cdprofe
having (sum(nhoras) >= 20  and sum(nhoras) <= 100);


/*12. Listado de profesores que son directores.*/
select distinct d.nombre
from profesores as d
inner join profesores as p on d.Cdprofe=p.Cddirector;

/*13. Se quiere premiar a los profesores del instituto que mejor productividad tenga. Para
ello se decide que una medida de la productividad puede ser el número de horas
trabajadas por el profesor del instituto en proyectos, dividida por los profesores de ese
instituto.
¿Qué instituto es el más productivo (nombre del instituto)? El IES Albujaira.*/
select i.nombre , round(sum(nhoras)/count(p.cdprofe))
from instituto as i
inner join profesores as p on i.Cdinsti=p.Cdinsti
inner join trabaja as t on p.cdprofe=t.Cdprofe
inner join proyecto on t.Cdpro=proyecto.Cdpro
group by i.Cdinsti
order by 2 desc;

/*14. Listado de todos los profesores, donde aparezcan los nombres de profesores, nombres
de sus institutos y nombres de proyectos en los que trabajan. Los profesores sin
instituto aparecerá “Sin Instituto de referencia”, y los que no trabajen en proyectos
aparecerán “Sin Proyecto”.*/
select distinct p.nombre, ifnull(i.nombre, "Sin instituto de referencia"), ifnull(proyecto.nombre, "Sin proyectos")
from profesores as p
left join trabaja as t on t.Cdprofe=p.cdprofe
left join instituto as i on p.Cdinsti=i.Cdinsti
left join proyecto on i.Cdinsti=proyecto.Cdinsti;

/*15. Lista de todos los profesores indicando el número de días que llevan trabajando en el
Instituto, en el caso de que no tengan fecha de ingreso que aparezca “Sin datos fecha
de ingreso”. Ordenados por nombre de profesor y luego por los días trabajados*/
select p.nombre, ifnull( datediff(now(), fech_ingreso) , "Sin datos de fecha de ingreso")
from profesores as p
order by 1, 2;

/*16. Lista de los profesores que son directores de más de 2 profesores, junto con el número
de profesores que están a su cargo.*/
select d.nombre as directores, count(p.cdprofe) as "nº de profesores"
from profesores as d
inner join profesores as p on d.cdprofe=p.Cddirector
group by d.cdprofe
having count(p.nombre) > 2;

/*17. Listar los nombres de proyectos en los que aparezca la palabra “Aplicaciones”,
indicando también el nombre del instituto que lo gestiona.*/
select proyecto.nombre, i.nombre
from proyecto 
inner join instituto as i on proyecto.Cdinsti=i.Cdinsti
where proyecto.nombre like "%APLICACIONES%";

/*18. Asignar a la profesora “Catalina Flores Cazorla” al instituto del Profesor Martin Flores.*/
/*19. Borrar los institutos que no tienen profesores.*/
create view InstitutoSinProfesores as (select i.Cdinsti
								from instituto as i
								left join profesores as p on i.Cdinsti=p.Cdinsti
								group by i.Cdinsti
								having count(p.cdprofe)=(select count(p.cdprofe)
															from profesores as p 
															right join instituto as i on p.Cdinsti=i.Cdinsti
															group by i.Cdinsti
															order by 1 limit 1));

delete from instituto
where Cdinsti = (select Cdinsti
				  from InstitutoSinProfesores);

/*20. Añadir todos los profesores del instituto 05 al proyecto “GAS”.*/










