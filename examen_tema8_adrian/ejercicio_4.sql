SET GLOBAL log_bin_trust_function_creators = 1;
use profesores;
/*4. Haz un procedimiento donde te muestre un listado de todos los nombres de los
profesores, y el número de proyectos en los que está trabajando (ten en cuenta
que algunos profesores no trabajan en ningún proyecto). Usa la base de datos
PROFESORES. */
delimiter $$
drop procedure if exists listado $$
create procedure listado()
begin
	select p.nombre, count(pro.Cdpro)
    from profesores as p
    left join trabaja as t on p.Cdprofe=t.Cdprofe
    left join proyecto as pro on t.Cdpro=pro.Cdpro
    group by p.nombre
    order by 2;
end $$
delimiter ;

call listado();