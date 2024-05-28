SET GLOBAL log_bin_trust_function_creators = 1;
use profesores;

/*7. Haz una función que introduzcas el nombre de un profesor y te devuelva el
número de años que lleva trabajando. Usa la base de datos PROFESORES. */
delimiter $$
drop function if exists tiempo_trabajado $$
create function tiempo_trabajado(nombre_profesor varchar(30))
returns double
begin
	set @anios = (select round(datediff(now(), fech_ingreso)/365, 0)
    from profesores
    where nombre = nombre_profesor);
    return @anios;
end $$
delimiter ;
select tiempo_trabajado("JAVIER GUILLEN BENAVENTE");