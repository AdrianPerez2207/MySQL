/*
1.	Crea una base de datos llamada cine que contenga dos tablas con las siguientes columnas.
Tabla cuentas:
•	id_cuenta: entero sin signo (clave primaria).
•	saldo: real sin signo.
Tabla entradas:
•	id_butaca: entero sin signo (clave primaria).
•	nif: cadena de 9 caracteres.
Una vez creada la base de datos y las tablas deberá crear un procedimiento llamado comprar_entrada con las siguientes características. 
El procedimiento recibe 3 parámetros de entrada (nif, id_cuenta, id_butaca) 
y devolverá como salida un parámetro llamado error que tendrá un valor igual a 0 si la compra de la entrada se ha podido realizar con éxito
 y un valor igual a 1 en caso contrario.
El procedimiento de compra realiza los siguientes pasos:
•	Inicia una transacción.
•	Actualiza la columna saldo de la tabla cuentas cobrando 5 euros a la cuenta con el id_cuenta adecuado.
•	Inserta una fila en la tabla entradas indicando la butaca (id_butaca) que acaba de comprar el usuario (nif).
•	Comprueba si ha ocurrido algún error en las operaciones anteriores. Si no ocurre ningún error entonces aplica un COMMIT a la transacción 
y si ha ocurrido algún error aplica un ROLLBACK.
Deberá manejar los siguientes errores que puedan ocurrir durante el proceso.
•	ERROR 1264 (Out of range value)
•	ERROR 1062 (Duplicate entry for PRIMARY KEY)
2.	¿Qué ocurre cuando intentamos comprar una entrada y le pasamos como parámetro un número de cuenta que no existe en la tabla cuentas?
 ¿Ocurre algún error o podemos comprar la entrada?
En caso de que exista algún error, ¿cómo podríamos resolverlo?.

*/
drop database if exists cine;
create database cine;
use cine;
create table if not exists cuentas(
id_cuenta  int unsigned primary key,
saldo decimal(11,2) unsigned check (saldo>=0)
);
create table if not exists entradas(
id_butaca int unsigned primary key,
nif varchar(9)
);

/* meter datos en la tabla cuentas*/
insert into cuentas values(1,500);
insert into cuentas values(2,10);
insert into cuentas values(3,5);

delimiter $$
drop procedure if exists comprar_entrada $$
create procedure comprar_entrada (in nif varchar(9), in id_cuenta int unsigned, in id_butaca int unsigned, out err tinyint)
begin
	declare continue handler for 1264, 1062
    begin
	set err = 1;
    end;
    start transaction;
    set err = 0;
    update cuentas set saldo = saldo - 5;
    insert into entradas values
    (id_butaca, nif);
    if err = 0 then
    commit;
    else
    rollback;
    end if;
end $$
delimiter ;

call comprar_entrada("132456-H", 3, 25, @err);
select * from cuentas;
select @err;
select * from entradas;


