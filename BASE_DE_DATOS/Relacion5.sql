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









