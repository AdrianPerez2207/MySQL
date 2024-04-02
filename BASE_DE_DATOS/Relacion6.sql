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
("VN2", "AR3", "2005-02-01"),
("VN1", "AR4", "2005-02-01"),
("VN1", "AR5", "2005-02-01"),
("VN3", "AR6", "2005-02-01"),
("VN3", "AR7", "2005-02-01"),
("VN3", "AR8", "2005-02-01"),
("VN4", "AR9", "2005-02-01"),
("VN4", "AR8", "2005-02-01"),
("VN5", "AR7", "2005-02-01"),
("VN5", "AR6", "2005-02-01"),
("VN6", "AR5", "2005-02-01"),
("VN6", "AR4", "2005-02-01"),
("VN7", "AR3", "2005-02-01"),
("VN7", "AR2", "2005-02-01"),
("VN1", "AR2", "2005-02-01"),
("VN2", "AR1", "2005-02-01"),
("VN3", "AR2", "2005-02-01"),
("VN4", "AR3", "2005-02-01"),
("VN5", "AR4", "2005-02-01"),
("VN5", "AR5", "2005-02-01"),
("VN6", "AR6", "2005-02-01"),
("VN5", "AR7", "2005-02-01"),
("VN4", "AR8", "2005-02-01"),
("VN3", "AR9", "2005-02-01"),
("VN7", "AR9", "2005-02-01");

/*SOLO FALTAN TERMINAR DE INSERTAR LAS FECHAS*/











