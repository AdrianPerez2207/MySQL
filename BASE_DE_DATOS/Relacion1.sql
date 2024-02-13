drop database if exists Relacion1;
create database if not exists Relacion1;
use Relacion1;
show databases;

create table if not exists Alumno(
Id_al char(3),
nom_al varchar(40),
fech_al date,
telf_al varchar(11),
primary key (Id_al)
)
engine = innoDB;
describe Alumno;

create table if not exists Profesor(
Id_prof char(3),
nom_prof varchar(40),
fech_prof date,
telf_prof varchar(11),
primary key (Id_prof)
)
engine = innoDB;
describe Profesor;

create table if not exists Relacion(
Id_al char(3),
Id_prof char(3),
nota double,
primary key (Id_al, Id_prof),
foreign key (Id_al) references Alumno (Id_al)
on update cascade on delete restrict, 
foreign key (Id_prof) references Profesor (Id_prof)
on update cascade on delete restrict
)
engine = innoDB; 
describe Relacion;

insert into Profesor (Id_prof, nom_prof, fech_prof, telf_prof) values
("P01", "CARMEN TORRES", "1996/09/08", "654-789-654"),
("P02", "FERNANDO GARCIA", "1961/07/09", "656-894-123");

insert into Alumno (Id_al, nom_al, fech_al, telf_al) values
("A01", "JUAN MUÑOZ", "1978/09/04", "676-543-456"),
("A02", "ANA TORRES", "1980/12/05", "654-786-756"),
("A03", "PEPE GARCIA", "1982/08/09", "950-441-234"),
("A04", "JULIO GOMEZ", "1983/12/23", "678-909-876"),
("A05", "KIKO ANDRADES", "1979/01/30", "666-123-456");

insert into Relacion values
("A01", "P01", 3.56),
("A01", "P02", 4.57),
("A02", "P01", 5.78),
("A02", "P02", 7.80),
("A03", "P01", 4.55),
("A03", "P02", 5),
("A04", "P02", 10),
("A05", "P01", 2.75),
("A05", "P02", 8.45);

/*Mostrar nombres de alumnos con sus teléfonos*/
select nom_al, telf_al
from Alumno;

/*Mostrar los nombres de los alumnos ordenados en orden creciente y decreciente*/
select nom_al
from Alumno
order by nom_al asc;
/*Descendente*/
select nom_al
from Alumno
order by nom_al desc;

/*Mostrar alumnos ordenados por edad*/
select * /*Seleccionamos todos los campos*/
from Alumno
order by fech_al asc;

/*Mostrar nombres de alumnos que contengan alguna 'A' en el nombre*/
select nom_al
from Alumno
where nom_al LIKE '%A%';

/*Mostra Id_al ordenado por nota*/
select Id_al
from Relacion
order by nota asc;

/*Mostrar nombre alumno y nombre de sus respectivos profesores.*/
/*Relacionamos las tablas con su foreign key*/
select nom_al, nom_prof
from Alumno, Profesor, Relacion
where Alumno.Id_al=Relacion.Id_al 
and Profesor.Id_prof=Relacion.Id_prof
order by nom_al;

/*Mostrar el nombre de los alumnos que les de clase el profesor P01*/
select nom_al, Id_prof
from Alumno, Relacion
where Alumno.Id_al=Relacion.Id_al
and Relacion.Id_prof = 'P01';

/*Mostrar el nombre y la nota de los alumnos que les de clase el profesor ‘FERNAND0 GARCIA’*/
select nom_al, nota
from Alumno, Relacion, Profesor
where Alumno.Id_al=Relacion.Id_al
and Profesor.Id_prof=Relacion.Id_prof 
and Profesor.nom_prof = 'FERNANDO GARCIA';

/*Mostrar todos los alumnos (codigo) que hayan aprobado con el profesor P01.*/
select Relacion.Id_al, nota, Id_prof /*Antes del campo ponemos a la tabla que se relaciona*/
from Alumno, Relacion
where Alumno.Id_al=Relacion.Id_al
and Relacion.nota >= 5
and Relacion.Id_prof LIKE 'P01';

/*Mostrar todos los alumnos (nombre) que hayan aprobado con el profesor P01.*/
select nom_al, nota, Id_prof
from Alumno, Relacion
where Alumno.Id_al=Relacion.Id_al
and Relacion.nota >= 5
and Relacion.Id_prof LIKE 'P01';

/*Mostrar todos los alumnos (nombre) que hayan aprobado con el profesor ‘CARMEN TORRES’*/
select nom_al, nota, nom_prof
from Alumno, Relacion, Profesor
where Alumno.Id_al=Relacion.Id_al
and Profesor.Id_prof=Relacion.Id_prof
and Relacion.nota >= 5
and Profesor.nom_prof LIKE 'CARMEN TORRES';

/*Mostrar el alumno/s que haya obtenido la nota más alta con ‘P01’*/
select distinct nom_al, nota, Id_prof
from Alumno, Relacion
where Alumno.Id_al=Relacion.Id_al
and nota = (select max(nota) from Relacion where Id_prof LIKE'P01')
and Relacion.Id_prof LIKE 'P01';

/*Mostrar los alumnos (nombre y codigo) que hayan aprobado todo*/
select nom_al, r.Id_al, nota
from Alumno, Relacion as r /*as = alias*/
where Alumno.Id_al=r.Id_al
and r.Id_al not in (select Id_al from Relacion where nota < 5 and Id_prof LIKE 'P01')
and r.Id_al not in (select Id_al from Relacion where nota < 5 and Id_prof LIKE 'P02');


/*Nº de alumnos por cada profesor*/
select count(*) as 'nº alumnos' , Id_prof
from Relacion
where nota >= 5
group by Id_prof;
/*Profesor que tiene mayor numero de alumno*/
select count(*) as 'nº alumnos' , Id_prof
from Relacion
group by Id_prof
having count(*)=(select count(*)
				from Relacion
				group by Id_prof
                order by 1 desc limit 1);
/*Media de nota que han sacado los alumnos con cada profesor*/
/*round = redondear, avg = media (redondear la media de las notas con 1 solo decimal.*/
select round(avg(nota),1) as media_notas, Relacion.Id_prof, Profesor.nom_prof
from Relacion, Profesor
where Relacion.Id_prof=Profesor.Id_prof
group by Profesor.Id_prof;

/*Nota media de cada alumno*/
select round(avg(nota),1) as media_notas, Relacion.Id_al, Alumno.nom_al
from Relacion, Alumno
where Relacion.Id_al=Alumno.Id_al
group by Alumno.Id_al;

/*Nota media de los alumnos que obtienen una media mayor que 7*/
select avg(nota) as media_notas, Relacion.Id_al, Alumno.nom_al
from Relacion, Alumno
where Relacion.Id_al=Alumno.Id_al
group by Alumno.Id_al
having avg(nota) >= 7;

/*Nombre del profesor que tiene a su cargo mas de 3 alumnos*/
select count(Id_al), nom_prof
from Profesor, Relacion as r
where Profesor.Id_prof=r.Id_prof
group by nom_prof
having count(r.Id_al) > 3;

/*Cual es el profesor o profesores que tienen más alumnos*/
select count(Id_al), Id_prof
from Relacion
group by Id_prof
having count(Id_al)=(select count(Id_al)  /*Donde la cuenta de los alumno sea igual a la primera seleccion, ordenador descendentemente*/
					from Relacion
					group by Id_prof
                    order by 1 desc limit 1);























