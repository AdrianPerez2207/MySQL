SET GLOBAL log_bin_trust_function_creators = 1;
use profesores;

/*9. Escribe una función para la base de datos PROFESORES que le pases el nombre
de un profesor y te diga si es director o no, que devuelva un valor booleano true
o false.
Usa la base de datos PROFESORES.*/
delimiter $$
drop function if exists director $$
create function director(nombre_director varchar(30))
returns boolean
begin
/*Si es director el Código del director será "null". Lo guardo en una variable y si esa variable es "null", la persona que buscamos es director.
	Si tiene alguna id dentro la varibale, sólo es profesor.*/
	set @director = (select p.Cddirector
    from profesores as d
    join profesores as p on d.Cdprofe = p.Cddirector
    where p.nombre = nombre_director);
    if @director != null then
    return false;
    else
    return true;
    end if;
end $$
delimiter ;
select director("JUAN ANGEL SOLER");
    
    
    
    
    