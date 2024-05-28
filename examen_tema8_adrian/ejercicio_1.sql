SET GLOBAL log_bin_trust_function_creators = 1;
use profesores;
/*1. Crea un procedimiento que actualice la fecha de ingreso del profesor que le
pasaremos como parámetro de entrada. Para ello le pasaremos dos parámetros
de entrada una será el nombre del profesor y el otro será la nueva fecha de
ingreso. Usa la base de datos PROFESORES.*/
delimiter $$
drop procedure if exists actualizar_fecha $$
create procedure actualizar_fecha(in profesor varchar(30), in nueva_fecha date)
begin
	update profesores set fech_ingreso = nueva_fecha
    where nombre = profesor;
end $$
delimiter ;
call actualizar_fecha("JAVIER GUILLEN BENAVENTE", "1999-09-01");
select * from profesores;