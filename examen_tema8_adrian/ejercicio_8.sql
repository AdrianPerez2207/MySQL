SET GLOBAL log_bin_trust_function_creators = 1;
use ExamenTema8;

/*8. Un número perfecto es aquel en el que la suma de todos sus divisores, sin
incluirlo a él mismo da como resultado ese número. Por ejemplo, el número 6 es
perfecto ya que los divisores de 6: 1, 2 y 3 (sin contar el 6) sumados dan 6. Hacer
una función que lea un número y diga si es o no perfecto. Usa la base de datos
ExamenTema8. */
delimiter $$
drop function if exists numero_perfecto $$
create function numero_perfecto(numero int)
returns varchar(20)
begin
	delete from divisores;
    set @divisores = 1;
    set @suma = 0;
    while numero > @divisores do
		if numero % @divisores = 0  then
			set @suma = @suma + @divisores;
            insert into divisores values 
			(@divisores);
        end if;
        set @divisores = @divisores + 1;
    end while;
    if @suma = numero then
    return "Es perfecto.";
    else
    return "No es perfecto";
    end if;
end $$
delimiter ;
select numero_perfecto(6);
select * from divisores;



