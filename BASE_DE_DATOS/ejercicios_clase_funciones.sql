set global log_bin_trust_function_creators = 1;
drop database if exists funciones;
create database if not exists funciones;
use funciones;
show databases;


delimiter $$
drop function if exists es_par$$
create function es_par(numero int)
returns boolean 
begin
	if numero % 2 = 0 then
		return true;
	else 
		return false;
	end if;
end $$
delimiter ;
select es_par(4);

/*------Lo hacemos con varchar-----------*/
drop function if exists es_par2;
delimiter $$
create function es_par2(numero int)
returns varchar(30)
begin
	if numero % 2 = 0 then
		return "es par";
	else 
		return "es impar";
	end if;
end $$
delimiter ;
select es_par2(5);

/*2. Escribe una función que devuelva el valor de la hipotenusa de un triángulo a partir de los valores de sus
lados.*/
drop function if exists hipotenusa;
delimiter $$
create function hipotenusa(numero1 int, numero2 int)
returns double
begin
	set @h = 0;
	set @h = sqrt(pow(numero1, 2) + pow(numero2, 2));
    return @h;
end $$
delimiter ;
select hipotenusa(9, 12);

/*3. Escribe una función que reciba como parámetro de entrada un valor numérico que represente un día de
la semana y que devuelva una cadena de caracteres con el nombre del día de la semana correspondiente.
Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes.*/
drop function if exists dias_semana;
delimiter $$
create function dias_semana(numero int)
returns varchar(20)
begin
	case numero
		when 1 then
        return "Lunes";
        when 2 then
        return "Martes";
        when 3 then
        return "Miércoles";
        when 4 then
        return "Jueves";
        when 5 then
        return "Viernes";
        when 6 then
        return "Sábado";
        when 7 then
        return "Domingo";
		else 
        return "Número no válido";
	end case;

end $$
delimiter ;
select dias_semana(3);

/*4. Escribe una función que reciba tres números reales como parámetros de entrada y devuelva el mayor de
los tres.*/
drop function if exists esMayor;
delimiter $$
create function esMayor(numero1 real, numero2 real, numero3 real)
returns real
begin
	if (numero1 > numero2) and (numero1 > numero3) then
		return numero1;
		elseif (numero2 > numero1) and (numero2 > numero3) then
			return numero2;
		else
			return numero3;
    end if;
end $$
delimiter ;
select esMayor(3, 6, 23);

/*5. Escribe una función que devuelva el valor del área de un círculo a partir del valor del radio que se recibirá
como parámetro de entrada.*/
drop function if exists area_circulo;
delimiter $$
create function area_circulo(radio double)
returns double
begin
	return round(pi() * pow(radio, 2), 2);
end $$
delimiter ;
select area_circulo(34);

/*6. Escribe una función que devuelva como salida el número de años que han transcurrido entre dos fechas
que se reciben como parámetros de entrada. Por ejemplo, si pasamos como parámetros de entrada las
fechas 2018-01-01 y 2008-01-01 la función tiene que devolver que han pasado 10 años.
Para realizar esta función puede hacer uso de las siguientes funciones que nos proporciona MySQL:
• DATEDIFF
• TRUNCATE*/
drop function if exists dias_transcurridos;
delimiter $$
create function dias_transcurridos(fecha1 date, fecha2 date)
returns int
begin
	return datediff(fecha1, fecha2) / 365;
end $$
delimiter ;
select dias_transcurridos("2018-01-01", "2008-01-01");


/*7. Escribe una función que reciba una cadena de entrada y devuelva la misma cadena pero sin acentos. La
función tendrá que reemplazar todas las vocales que tengan acento por la misma vocal pero sin acento.
Por ejemplo, si la función recibe como parámetro de entrada la cadena María la función debe devolver
la cadena Maria*/
delimiter $$
drop function if exists cadenas$$
create function cadenas(caracteres varchar(30))
returns varchar(30)
begin
	set caracteres = replace(caracteres, "á", "a");
    set caracteres = replace(caracteres, "é", "e");
    set caracteres = replace(caracteres, "í", "i");
    set caracteres = replace(caracteres, "ó", "o");
    set caracteres = replace(caracteres, "ú", "u");
	return caracteres;
end $$
delimiter ;
select cadenas("María");












