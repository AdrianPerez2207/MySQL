create database if not exists agenda;
use agenda;
create table if not exists personas(
id int auto_increment primary key,
nombre varchar(40),
fecha date
);
create table if not exists telefonos(
numero char(12),
id int,
foreign key (id)references personas (id)
on delete cascade on update cascade
);

create table if not exists telefono3(
numero char (12),
id int,
foreign key (id) references personas (id)
on delete restrict on update cascade
);