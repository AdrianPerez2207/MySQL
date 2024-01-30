drop database if exists Relacion1;
create database if not exists Relacion1;
use Relacion1;
show databases;

create table if not exists Alumno(
Id_al char(3),
nom_al varchar(40),
fech_al date,
telf_al varchar(9),
primary key (Id_al)
);
describe Alumno;

create table if not exists Profesor(
Id_prof char(3),
nom_prof varchar(40),
fech_prof date,
telf_prof varchar(9),
primary key (Id_prof)
);
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
); 
describe Relacion;

insert into Profesor (Id_prof, nom_prof, fech_prof, telf_prof) values
(P01, "CARMEN TORRES", "1996/09/08", "654-789-654"),
(P02, "FERNANDO GARCIA", "1961/07/09", "656-894-123");

insert into Alumno (Id_al, nom_al, fech_al, telf_al) values
(A01, "JUAN MUÑOZ", "1978/09/04", "676-543-456"),
(A02, "ANA TORRES", "1980/12/05", "654-786-756"),
(A03, "PEPE GARCIA", "1982/08/09", "950-441-234"),
(A04, "JULIO GOMEZ", "1983/12/23", "678-909-876"),
(A05, "KIKO ANDRADES", "1979/01/30", "666-123-456");

insert into Relacion values
(A01, P01, 3.56),
(A01, P02, 4.57),
(A02, P01, 5.78),
(A02, P02, 7.80),
(A03, P01, 4.55),
(A03, P02, 5),
(A04, P02, 10),
(A05, P01, 2.75),
(A05, P02, 8.45);











