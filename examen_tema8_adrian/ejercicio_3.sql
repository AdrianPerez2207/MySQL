SET GLOBAL log_bin_trust_function_creators = 1;
use profesores;

/*3. Haz un procedimiento donde introduzcas el nombre de un profesor como
parámetro de entrada y que te devuelva como salida el nombre del instituto en
que trabaja. Usa la base de datos PROFESORES.*/
delimiter $$
drop procedure if exists insti_profe $$
create procedure insti_profe(in nom_profe varchar(30))
begin
	select i.nombre
    from instituto as i
    join profesores as p on i.Cdinsti=p.Cdinsti
    where p.nombre = nom_profe;
end $$
delimiter ;
call insti_profe("JAVIER GUILLEN BENAVENTE");