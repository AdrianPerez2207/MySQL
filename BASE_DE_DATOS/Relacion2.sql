drop database if exists Tienda;
create database if not exists Tienda;

use Tienda;

show databases;

create table if not exists Farbricantes(
Clave_fabricante int primary key,
Nombre varchar(30)
);
describe Fabricantes;

create table if not exists Articulos(
Clave_articulo int auto_increment primary key,
Nombre varchar(30),
Precio int,
Clave_fabricante int,
foreign key (Clave_fabricante) references Fabricantes (Clave_fabricante)
on update cascade on delete cascade
);
describe Articulos;

insert into Fabricantes (Clave_fabricante, Nombre) values
(1,"Kingstom"),
(2,"Adata"),
(3,"Logitech"),
(4,"Lexar"),
(5,"Seagate");

insert into Articulos (Nombre, Precio, Clave_fabricante) values
("Teclado", 100, 3),
("Disco duro 300 Gb", 500, 5),
("Mouse", 80, 3),
("Memoria USB", 140, 4),
("Memoria RAM", 290, 1),
("Disco duro extraible 250 Gb", 650, 5),
("Memoria USB", 279, 1),
("DVD Rom", 450, 2),
("CD Rom", 200, 2),
("Tarjeta de red", 180, 3);









