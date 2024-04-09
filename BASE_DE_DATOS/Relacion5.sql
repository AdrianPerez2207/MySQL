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
join trabaja on trabaja.cod_emp = empleado.cod_emp
group by nom_emp
having sum(nhoras) > 50;

/*Nombre de los empleados que han trabajado menos de 50 horas en proyectos.*/
select nom_emp, ifnull(sum(nhoras), 0) as "horas trabajadas"
from empleado
left join trabaja on trabaja.cod_emp = empleado.cod_emp
group by nom_emp
having sum(nhoras) < 50
order by 2 asc;

/*Nombre de los departamentos que tienen empleados con apellido “Verde”.*/
select nom_dep
from departamento as de
join empleado as em on em.cod_dep = de.cod_dep
where nom_emp like "% VERDE";

/*Nombre de los proyectos en los que trabajan más de dos empleados*/
select nom_pro, count(t.cod_emp) as "nº empleados"
from proyecto as p
join trabaja as t on p.cod_pro = t.cod_pro
group by t.cod_pro
having count(t.cod_emp) > 2;


/*Lista de los empleados y el departamento al que pertenecen, con indicación del dinero total que
deben percibir, a razón de 35 euros la hora. La lista se presentará ordenada por orden alfabético
de nombre de empleado, y en caso de que no pertenezcan a ningún departamento (NULL) debe
aparecer la palabra “DESCONOCIDO”.*/
select e.nom_emp as "EMPLEADO", ifnull(nom_dep, "DESCONOCIDO") as "DEPARTAMENTO", ifnull((sum(nhoras) * 35), "No ha trabajado") as dinero 
from empleado as e
left join trabaja as t on e.cod_emp = t.cod_emp
left join departamento as d on e.cod_dep = d.cod_dep
group by e.cod_emp
order by 1 asc; 



/*Lista de los nombres de todos los empleados, y el número de proyectos en los que está
trabajando (ten en cuenta que algunos empleados no trabajan en ningún proyecto).*/
select nom_emp, count(p.cod_pro)
from empleado as e
left join trabaja as t on e.cod_emp = t.cod_emp
left join proyecto as p on t.cod_pro = p.cod_pro
group by e.cod_emp
order by 1 asc;

/*6. Lista de empleados que trabajan en Málaga o en Almería.*/
select *
from empleado as e
join departamento as d on e.cod_dep = d.cod_dep
where ciudad in ("MÁLAGA", "ALMERIA")
order by e.nom_emp;

select *
from empleado as e
join departamento as d on e.cod_dep = d.cod_dep
where (ciudad like "MÁLAGA"
or ciudad like "ALMERIA")
order by e.nom_emp;

/*7. Lista alfabética de los nombres de empleado y los nombres de sus jefes. Si el empleado no tiene
jefe debe aparecer la cadena “Sin Jefe”.*/
select e.nom_emp as "Empleado", ifnull(jefe.nom_emp, "Sin jefe") as "Jefe"
from empleado as e
left join empleado as jefe on jefe.cod_emp = e.cod_jefe
order by jefe.nom_emp asc;

/*8. Fechas de ingreso mínima. y máxima, por cada departamento.*/
select nom_dep as "Departamento", min(fecha_ingreso) as "Fecha mínima", max(fecha_ingreso) as "Fecha máxima"
from empleado as e
right join departamento as d on e.cod_dep = d.cod_dep
group by d.cod_dep
order by 1 asc;

/*9. Nombres de empleados que trabajan en el mismo departamento que Carmen Violeta.*/
select nom_emp
from empleado as e
join departamento as d on e.cod_dep = d.cod_dep
where d.cod_dep = (select cod_dep
					from empleado as e
                    where nom_emp like "CARMEN VIOLETA")
and nom_emp not like "CARMEN VIOLETA";

/*10. Media del año de ingreso en la empresa de los empleados que trabjan en algún proyecto.*/
select distinct round(avg(year(fecha_ingreso))) as "Media año ingreso"
from empleado as e
join trabaja as t on e.cod_emp = t.cod_emp;


/*11. Nombre de los empleados que tienen de apellido Verde o Rojo, y simultáneamente su jefa es
Esperanza Amarillo.*/
select e.nom_emp
from empleado as e
join empleado as jefe on jefe.cod_emp = e.cod_jefe
where jefe.nom_emp like "ESPERANZA AMARILLO"
and (e.nom_emp like "% ROJO" or e.nom_emp like "% VERDE");


/*12. Suponiendo que la letra que forma parte del código de empleado es la categoría laboral, listar los
empleados de categoría B que trabajan en algún proyecto.*/
select e.nom_emp as "Empleados", e.cod_emp as "Código"
from empleado as e
join trabaja as t on e.cod_emp = t.cod_emp
where e.cod_emp like "B%";


/*13. Listado de nombres de departamento, ciudad del departamento y número de empleados del
departamento. Ordenada por nombre de ciudad y a igualdad de esta por el nombre del
departamento.*/
select nom_dep as "Departamento", ciudad, count(e.cod_emp) as "Cuenta empleados"
from departamento as d
left join empleado as e on d.cod_dep = e.cod_dep
group by d.cod_dep
order by 2 desc, 1; /*ordenamos por nombre de ciudad y despartamento*/



/*14. Lista de nombres de proyecto y suma de horas trabajadas en él, de los proyectos en los que se ha
trabajado más horas de la media de horas trabajadas en todos los proyectos.*/
select p.nom_pro, sum(t.nhoras)
from proyecto as p
join trabaja as t on p.cod_pro = t.cod_pro
group by t.cod_pro
having sum(t.nhoras) >= (select avg(nhoras)
						from trabaja);


/*15. Nombre de proyecto y horas trabajadas, del proyecto en el que más horas se ha trabajado.*/
select p.nom_pro, sum(t.nhoras)
from proyecto as p
join trabaja as t on p.cod_pro = t.cod_pro
group by t.cod_pro
having sum(t.nhoras) = (select sum(nhoras)
						from trabaja
                        group by cod_pro
						order by 1 desc limit 1);

/*16. Lista de nombres de empleado que hayan trabajado entre 15 y 100 horas, entre todos los
proyectos en los que trabajan.*/
select nom_emp, sum(nhoras)
from empleado as e
join trabaja as t on e.cod_emp = t.cod_emp
join proyecto as p on t.cod_pro = p.cod_pro
group by e.cod_emp
having sum(nhoras) between 15 and 100
order by 2 asc;


/*17. Lista de empleados que no son jefes de ningún otro empleado.*/
select e.nom_emp
from empleado as e
where not exists (select nom_emp
					from empleado as e2
                    where e2.cod_jefe = e.cod_emp);


/*18. Se quiere premiar a los empleados del departamento que mejor productividad tenga. Para ello se
decide que una medida de la productividad puede ser el número de horas trabajadas por
empleados del departamento en proyectos, dividida por los empleados de ese departamento.
¿Qué departamento es el más productivo?*/
select nom_dep, sum(nhoras)
from departamento as d
join empleado as e on d.cod_dep = e.cod_dep
join trabaja as t on e.cod_emp = t.cod_emp
group by d.cod_dep
having sum(nhoras)/count(e.cod_emp) = (select sum(nhoras)/count(e.cod_emp)
										from trabaja as t
                                        join empleado as e on t.cod_emp = e.cod_emp
                                        join departamento as d on e.cod_dep = d.cod_dep
										group by d.cod_dep
                                        order by 1 desc limit 1);




/*19. Lista donde aparezcan los nombres de empleados, nombres de sus departamentos y nombres de
proyectos en los que trabajan. Los empleados sin departamento, o que no trabajen en proyectos
aparecerán en la lista y en lugar del departamento o el proyecto aparecerá “*****”.*/
select nom_emp, ifnull(nom_dep, "*****"), ifnull(nom_pro, "*****")
from empleado as e
left join trabaja as t on e.cod_emp = t.cod_emp
left join departamento as d on e.cod_dep = d.cod_dep
left join proyecto as p on d.cod_dep = p.cod_dep
order by 3 asc;




/*20. Lista de los empleados indicando el número de días que llevan trabajando en la empresa.*/
select nom_emp, datediff(now(), fecha_ingreso) /*Función para calcular los dias entre fechas*/
from empleado
order by 2;


/*21. Número de proyectos en los que trabajan empleados de la ciudad de Córdoba.*/
select count(p.cod_pro)
from proyecto as p
join trabaja as t on p.cod_pro = t.cod_pro
join empleado as e on t.cod_emp = e.cod_emp
join departamento as d on e.cod_dep = d.cod_dep
where d.ciudad like "CÓRDOBA";


/*22. Lista de los empleados que son jefes de más de un empleado, junto con el número de empleados
que están a su cargo.*/                                
select count(e.cod_emp), jefe.nom_emp
from empleado as e
join empleado as jefe on jefe.cod_emp=e.cod_jefe
group by jefe.cod_emp
having count(e.cod_emp) > 1;


/*23. Listado que indique años y número de empleados contratados cada año, todo ordenado por orden
ascendente de año.*/
select year(fecha_ingreso), count(e.cod_emp)
from empleado as e
group by year(fecha_ingreso)
order by 1 asc;


/*24. Listar los nombres de proyectos en los que aparezca la palabra “energía”, indicando también el
nombre del departamento que lo gestiona.*/
select p.nom_pro, d.nom_dep
from proyecto as p
join departamento as d on p.cod_dep=d.cod_dep
where p.nom_pro like "%ENERGÍA%";

/*25. Lista de departamentos que están en la misma ciudad que el departamento “Gerencia”.*/
select d.nom_dep, d.ciudad
from departamento as d
where d.ciudad=(select ciudad
				from departamento as d
				where d.nom_dep like "GERENCIA");

/*26. Lista de departamentos donde exista algún trabajador con apellido “Amarillo”.*/
select d.nom_dep, e.nom_emp
from departamento as d
join empleado as e on d.cod_dep=e.cod_dep
where e.nom_emp like "%AMARILLO";

/*27. Lista de los nombres de proyecto y departamento que los gestiona, de los proyectos que tienen 0
horas de trabajo realizadas.*/
select distinct nom_pro, nom_dep
from proyecto as p
join departamento as d on p.cod_dep=d.cod_dep
join trabaja as t on p.cod_pro=t.cod_pro
where nhoras = 0;


/*28. Asignar el empleado “Manuel Amarillo” al departamento “05”*/
set sql_safe_updates=0; /*Se utiliza para poder hacer actualizaciones inseguras*/
update empleado set cod_dep = "05"
where nom_emp like "MANUEL AMARILLO";


/*29. Borrar los departamentos que no tienen empleados.*/
delete from departamento
where cod_dep not in (select cod_dep
						from empleado
                        where cod_dep is not null);


/*30. Añadir todos los empleados del departamento 02 al proyecto MES.*/
insert into trabaja
/*cod_emp(consulta), cod_pro, nhoras*/
select cod_emp, "MES", 0
	from empleado
    where cod_dep like "02";
    
select *
from trabaja
order by nhoras desc;





