SET GLOBAL log_bin_trust_function_creators = 1;
/*6. Crea una base de datos llamada ExamenTema8 que contenga una tabla llamada
divisores, la tabla tendrá una única columna llamada número y el tipo de dato de
esta columna debe ser INT UNSIGNED. (1 punto)
Crear un procedimiento llamado Calculardivisores con las siguientes
características. El procedimiento recibe un parámetro de entrada llamado
número y deberá almacenar en la tabla divisores sus divisores. Ej. 16 -> sus
divisores son: 1, 2, 4, 6,16
Ten en cuenta que el procedimiento deberá eliminar el contenido actual de la
tabla antes de insertar los nuevos valores que va a calcular.
Utiliza un bucle WHILE para resolver el procedimiento. */
drop database if exists ExamenTema8;
create database if not exists ExamenTema8;
use ExamenTema8;

create table if not exists divisores(
	numero int unsigned
);

delimiter $$
drop procedure if exists CalcularDivisores $$
create procedure CalcularDivisores(in numero int)
begin
	delete from divisores;
    set @divisores = 1;
    while numero >= @divisores do
		if numero % @divisores = 0  then
			insert into divisores values 
			(@divisores);
		end if;
        set @divisores = @divisores + 1;
	end while;
end $$
delimiter ;

call CalcularDivisores(16);
select * from divisores;






