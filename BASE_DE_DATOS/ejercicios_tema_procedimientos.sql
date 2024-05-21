drop database if exists procedimientos;
create database if not exists procedimientos;
use procedimientos;
show databases;

create table if not exists ejercicio(
	numero int unsigned
)
engine=InnoDB;

create table if not exists pares(
	numero int unsigned
)
engine=InnoDB;

create table if not exists impares(
	numero int unsigned
)
engine=InnoDB;

/*Ejercicio 7, 8 y 9*/
delimiter $$
create procedure calcular_numeros(in valor_inicial int unsigned)
begin
	delete from ejercicio;
    
    while valor_inicial > 1 do
    insert into ejercicio (numero) values
	(valor_inicial);
	set valor_inicial = valor_inicial - 1;
    end while;

end $$
delimiter ;

/*Llamamos a la función*/
call calcular_numeros(7);

select * from ejercicio;

/*Bucle REPEAT*/
drop procedure if exists calcular_numeros2;
delimiter $$
create procedure calcular_numeros2(in valor_inicial int unsigned)
begin
delete from ejercicio;
	repeat
		insert into ejercicio (numero) values
        (valor_inicial);
		set valor_inicial = valor_inicial - 1;
    until valor_inicial < 1 end repeat;

end $$
delimiter ;

call calcular_numeros2(8);
select * from ejercicio;

/*Bucle LOOP*/
drop procedure if exists calcular_numeros3;
delimiter $$
create procedure calcular_numeros3(in valor_inicial int unsigned)
begin
	delete from ejercicio;
    
	label1:loop
    if(valor_inicial > 1) then
		insert into ejercicio (numero) values
        (valor_inicial);
        set valor_inicial = valor_inicial - 1;
        iterate label1;
        end if;
        leave label1;
		end loop label1;
end $$
delimiter ;

call calcular_numeros3(10);

select * from ejercicio;


/*Ejercicio 10*/

drop procedure if exists calcular_pares_impares;

delimiter $$
create procedure calcular_pares_impares(in tope int unsigned)
begin
	delete from pares;
    delete from impares;
    
    set @numero = 1;
    while @numero < tope do
		if @numero % 2 = 0 then
			insert into pares (numero) values
            (@numero);
		else 
			insert into impares (numero) values
            (@numero);
		end if;
        set @numero = @numero + 1;
    end while;
    
end $$
delimiter ;

call calcular_pares_impares(20);
select * from pares;
select * from impares;

/*Bucle REPEAT*/
drop procedure if exists calcular_pares_impares2;

delimiter $$
create procedure calcular_pares_impares2(in tope int unsigned)
begin
	delete from pares;
    delete from impares;
    
    set @numero = 1;
    repeat
		if @numero % 2 = 0 then
			insert into pares (numero) values
            (@numero);
		else 
			insert into impares (numero) values
            (@numero);
		end if;
        set @numero = @numero + 1;
    until @numero >= tope end repeat;
    
end $$
delimiter ;

call calcular_pares_impares(20);
select * from pares;
select * from impares;

/*-------Bucle LOOP-------*/
drop procedure if exists calcular_pares_impares3;

delimiter $$
create procedure calcular_pares_impares3(in tope int unsigned)
begin
	delete from pares;
    delete from impares;
    
    set @numero = 1;
    label1:loop
    if @numero < tope then
		if @numero % 2 = 0 then
			insert into pares (numero) values
            (@numero);
		else 
			insert into impares (numero) values
            (@numero);
		end if;
        set @numero = @numero + 1;
	iterate label1;
	end if;
    leave label1;
    end loop;
    
end $$
delimiter ;

call calcular_pares_impares(20);
select * from pares;
select * from impares;





