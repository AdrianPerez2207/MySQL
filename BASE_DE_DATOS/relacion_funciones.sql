drop database if exists procedimientos;
create database if not exists procedimientos;
use procedimientos;
show databases;

create table if not exists Operaciones(
	id int auto_increment primary key,
	num1 int unsigned,
    num2 int unsigned,
    suma int unsigned,
    producto int unsigned
)
engine=InnoDB;

/*Una vez creada la base de datos y la tabla crear un procedimiento llamado
Calcular_Operaciones con las siguientes características. El procedimiento recibe
dos parámetro, uno llamado número y otro tope de tipo int unsigned y calculara
el valor de la suma y del producto de los números naturales comprendidos entre
número y tope.
Ten en cuenta que el procedimiento deberá eliminar el contenido actual de la
tabla antes de insertar los nuevos valores de la suma y el producto que va a
calcular*/

/*Funciones.*/
delimiter $$
create procedure Calcular_Operaciones(in numero int unsigned, in tope int unsigned)
begin
delete from Operaciones;
	set @i = numero + 1;
    set @total = 0;
    set @totalProducto = 1;
    
	while @i < tope do
    set @total = @total + @i;
    set @totalProducto = @totalProducto * @i;
    set @i = @i + 1;
    end while;
    
	insert into Operaciones (num1, num2 ,suma, producto) values (
		numero, tope, @total, @totalProducto
    );
    
end $$
delimiter ;

/*Llamamos a los procedimientos*/
call Calcular_Operaciones (2, 7);

select * from Operaciones;

/*Repeat*/
delimiter $$
create procedure Calcular_Operaciones2(in numero int unsigned, in tope int unsigned)
begin
delete from Operaciones;
	set @i = numero + 1;
    set @total = 0;
    set @totalProducto = 1;
    
    repeat
    set @total = @total + @i;
    set @totalProducto = @totalProducto * @i;
    set @i = @i + 1;
    until @i >= tope end repeat;
    
    insert into Operaciones (num1, num2 ,suma, producto) values (
		numero, tope, @total, @totalProducto
    );

end $$
delimiter ;

call Calcular_Operaciones2 (2, 7);

select * from Operaciones;

/*Loop*/
delimiter $$
create procedure Calcular_Operaciones3(in numero int unsigned, in tope int unsigned)
begin
delete from Operaciones;
	set @i = numero + 1;
    set @total = 0;
    set @totalProducto = 1;
    
    label1:loop
    set @total = @total + @i;
    set @totalProducto = @totalProducto * @i;
    set @i = @i + 1;
    if @i < tope then
    iterate label1;
    end if;
    leave label1;
    end loop label1;

	insert into Operaciones (num1, num2 ,suma, producto) values (
		numero, tope, @total, @totalProducto
	);
end $$
delimiter ;

call Calcular_Operaciones3 (2, 7);

select * from Operaciones;











