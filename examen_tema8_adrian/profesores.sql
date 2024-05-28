drop database if exists profesores;
create database if not exists profesores;
use profesores;

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

select * from profesores;
select * from instituto;
select *from trabaja;
select * from proyecto;

select p.nombre, count(pro.Cdpro)
    from profesores as p
    left join trabaja as t on p.Cdprofe=t.Cdprofe
    left join proyecto as pro on t.Cdpro=pro.Cdpro
    group by p.nombre;

delimiter $$
drop procedure if exists actualizar_fecha $$
create procedure actualizar_fecha(in profesor varchar(30), in nueva_fecha date)
begin
	update profesores set fecha_ingreso = nueva_fecha
    where nom_prof = profesor;
end $$
delimiter ;