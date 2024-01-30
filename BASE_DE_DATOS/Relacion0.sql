drop database if exists Ejecicio1;
create database if not exists Ejercicio1;
use Ejercicio1;
show databases;

create table if not exists Cliente(
NIF char(9),
Nombre varchar(25) not null,
Domicilio varchar(100),
TLF varchar(25),
Ciudad varchar(50),
primary key (NIF)
);
describe Cliente;

create table if not exists Producto(
Codigo char(4),
Decripcion varchar(100) not null,
Precio float,
Stock float,
Minimo float,
Check (precio > 0),
primary key (Codigo)
);
describe Producto;

create table if not exists Factura(
Numero int,
Fecha date,
Pagado boolean,
TotalPrecio float,
NIF char(9),
primary key (Numero),
foreign key (NIF) references Cliente (NIF)
on update cascade on delete restrict
);
describe Factura;

create table if not exists Detalle(
Numero int,
Codigo char(4),
Unidades int,
primary key (Numero, Codigo),
foreign key (Numero) references Factura (Numero)
on update cascade on delete restrict, #Modificar en cascada y borrado restringido
foreign key (Codigo) references Producto (Codigo)
on update cascade on delete restrict
);
describe Detalle;

insert into Cliente values
("43434343A", "DELGADO PEREZ MARISA", "C/MIRAMAR, 84 3ºA", "925-200-967", "TOLEDO"),
("51592939K", "LOPEZ VAL SOLEDAD", "C/PEZ, 54 4ºC", "915-829-394", "MADRID"),
("51639989K", "DELGADO ROBLES MIGUEL", "C/OCA, 54 5ºC", "913-859-293", "MADRID"),
("51664372R", "GUTIERREZ PEREZ ROSA", "C/CASTILLA, 4 4ºA", "919-592-932", "MADRID");

insert into Producto values
("CAJ1", "CAJA DE HERRAMIENTAS DE PLASTICO", 8.50, 4.00, 3),
("CAJ2", "CAJA DE HERRAMIENTAS DE METAL", 12.30, 3.00, 2),
("MAR1", "MARTILLO PEQUEÑO", 3.50, 5, 10),
("MAR2", "MARTILLO GRANDE", 6.50, 12, 10),
("TOR7", "CAJA 100 TORNILLOS DEL 7", 0.80, 20, 100),
("TOR8", "CAJA 100 TORNILLOS DEL 9", 0.80, 25, 100),
("TUE1", "CAJA 100 TUERCAS DEL 7", 0.50, 40, 100),
("TUE2", "CAJA 100 TUERCAS DEL 9", 0.50, 54, 100),
("TUE3", "CAJA 100 TUERCAS DEL 12", 0.50, 60, 100);

insert into Factura (Numero, Fecha, Pagado, TotalPrecio, NIF) values
(5440, "2017-09-05", TRUE, "51664372R", 345),
(5441, "2017-09-06", FALSE, "51592939K", 1000),
(5442, "2017-09-07", FALSE, "43434343A ", 789),
(5443, "2017-09-08", TRUE, "51639989K", 123.78),
(5444, "2017-09-09", TRUE, "51639989K", 567),
(5445, "2017-09-10", TRUE, "51592939K ", 100);

insert into Detalle values
(5440, "CAJ2", 2),
(5440, "2TOR7", 2),
(5440, "TOR8", 2),
(5441, "CAJ1", 1),
(5442, "CAJ1", 1),
(5442, "MAR1", 2),
(5443, "TOR7", 1),
(5443, "TUE1", 1),
(5444, "MAR2", 1),
(5445, "TOR7", 5),
(5445, "TOR8", 5),
(5445, "TUE2", 5),
(5445, "TUE3", 5);







