drop database if exists Meteo;
create database if not exists Meteo;
use Meteo;
show databases;
create table if not exists Estacion(
Identificador Integer auto_increment primary key,
Latitud double,
Longitud double,
Altitud double
);
describe Estacion;
create table if not exists Muestra(
IdentificadorEstacion Integer auto_increment,
Fecha date,
TemperaturaMinima double,
TemperaturaMaxima double,
Precipitaciones double,
HumedadMinima double,
HumedadMaxima double,
VelocidadVientoMinima double,
VelocidadVientoMaxima double,
primary key (IdentificadorEstacion),
foreign key (IdentificadorEstacion) references Estacion (Identificador)
);
describe Muestra;
