SET GLOBAL log_bin_trust_function_creators = 1;
use profesores;

/*2. Haz un procedimiento para dar de alta nuevos institutos, con las siguientes
características. El procedimiento recibe 3 parámetros de entrada cdinsti char(2),
nombre varchar(30), ciudad varchar(20) y devolverá como salida un parámetro
llamado error que tendrá valor igual a 0 si la inserción se ha podido realizar con
éxito y un valor igual a 1 en caso contrario. El procedimiento de para dar de alta
realiza los siguientes pasos: (2 puntos)
 Inicia una transacción.
 Inserta una fila en la tabla.
 Comprueba si ha ocurrido algún error en las operaciones anteriores. Si
no ocurre ningún error entonces aplica un COMMIT a la transacción y si
ha ocurrido algún error aplica un ROLLBACK.
 Deberá manejar el siguiente error que pueda ocurrir durante el proceso
de inserción .ERROR 1062 (Duplicate entry for PRIMARY KEY)*/
delimiter $$
drop procedure if exists nueva_alta $$
create procedure nueva_alta(in cdinsti char(2), in nombre varchar(30), in ciudad varchar(20), out err tinyint)
begin
	declare continue handler for 1062
    begin
		set err = 1;
    end;
    start transaction;
		set err = 0;
		insert into institutos values
        (cdinsti, nombre, ciudad);
        if err = 0 then
			commit;
        else
			rollback;
        end if;
end $$
delimiter ;
    
    
    
    