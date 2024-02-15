create database if not exists AgendaAlumno;
use AgendaAlumno
create table if not exists cliente(
id_cliente int auto_increment primary key,
nombre varchar (75),
direccion varchar (100),
telefono varchar (12),
ciudad varchar (25)
);

create table if not exists producto(
id_produto char (6),
descripcion varchar (50),
precio double
);

create table if not exists venta(
id_venta int auto_increment primary key,
cantidad int not null,
id_producto char(6),
id_cliente int,
foreign key(id_producto) references producto(id_producto)
on delete restrict on update cascade,
foreign key (cliente) references cliente(id_calumnosliente)
on delete restrict on update cascade;