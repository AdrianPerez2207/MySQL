SET GLOBAL log_bin_trust_function_creators = 1;
use profesores;

/*5. Crea un procedimiento para Borrar los institutos que no tienen profesores. Usa
la base de datos PROFESORES. */
delimiter $$
drop procedure if exists borrar_insti $$
create procedure borrar_insti()
begin
	delete from instituto
    where Cdinsti=(select i.Cdinsti
					from profesores as p
					right join instituto as i on p.Cdinsti=i.Cdinsti
					group by i.Cdinsti
					having count(cdprofe)=(select count(cdprofe)
											from profesores as p
											right join instituto as i on p.Cdinsti=i.Cdinsti
											group by i.Cdinsti
											order by 1 limit 1));

end $$
delimiter ;
call borrar_insti();
                        
                        
                        