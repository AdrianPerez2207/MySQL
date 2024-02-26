drop database if exists Relacion4;
create database if not exists Relacion4;
use Relacion4;
show databases;

create table if not exists mecanico(
	id_mec varchar(10) not null primary key,
    nom_mec varchar(25),
    sueldo integer not null,
    fech_nac date
)
engine=InnoDB;
describe mecanico;

create table if not exists coche(
	mat_co varchar(8) not null primary key,
    mod_co varchar(20),
    color varchar(10),
    tipo varchar(20)
)
engine=InnoDB;
describe coche;

create table if not exists periodo(
	id_per varchar(10) not null primary key,
    fec_ini date,
    fec_fin date
)
engine=InnoDB;
describe periodo;

create table if not exists tipo(
	id_tipo varchar(10) primary key,
    nom_tipo varchar(30)
)
engine=InnoDB;
describe tipo;

create table if not exists pieza(
	id_piez varchar(10) not null primary key,
    nom_piez varchar(30),
    id_tipo varchar(10),
    foreign key (id_tipo) references tipo (id_tipo)
    on delete cascade
)
engine=InnoDB;
describe pieza;

create table if not exists relacion(
	id_mec varchar(10),
    mat_co varchar(8),
    id_per varchar(10),
    id_piez varchar(10),
    precio double,
    primary key(id_mec, mat_co, id_per, id_piez),
    foreign key (id_mec) references mecanico (id_mec)
    on delete cascade,
    foreign key (mat_co) references coche (mat_co)
    on delete cascade,
    foreign key (id_per) references periodo (id_per)
    on delete cascade,
    foreign key (id_piez) references pieza (id_piez)
    on delete cascade
)
engine=InnoDB;
describe relacion;

insert into mecanico values
("ME1", "JUAN ROMUALDO", 1289, "1970/09/05"),
("ME2", "RAMON FERNANDEZ", 1678, "1976/07/05"),
("ME3", "ANA LUCAS", 1100, "1968/09/04");

insert into coche values
("1234-CDF", "SEAT LEON", "GRIS", "DIESEL"),
("0987-CCC", "RENAULT MEGANE", "BLANCO", "GASOLINA"),
("0123-BVC", "OPEL ASTRA", "AZUL", "DIESEL"),
("1456-BNL", "FORD FOCUS", "VERDE", "DIESEL"),
("1111-CSA", "SEAT TOLEDO", "ROJO", "GASOLINA"),
("4567-BCB", "VOLKSWAGEN POLO", "BLANCO", "DIESEL"),
("0987-BFG", "FORD FIESTA", "NEGRO", "GASOLINA");


insert into periodo values
("PE1", "2003/04/09", "2003/04/10"),
("PE2", "2004/05/12", "2004/05/17"),
("PE3", "2004/06/17", "2004/06/27"),
("PE4", "2005/08/22", "2005/09/1"),
("PE5", "2005/09/10", "2005/09/15"),
("PE6", "2005/10/1", "2005/10/17");

insert into tipo values
("TI1", "CHAPA"), 
("TI2", "MECANICA"), 
("TI3", "ELECTRICIDAD"), 
("TI4", "ACCESORIOS");

insert into pieza values
("PI1", "FILTRO", "TI4"),
("PI2", "BATERIA", "TI3"),
("PI3", "ACEITE", "TI2"),
("PI4", "RADIO", "TI4"),
("PI5", "EMBRAGE", "TI2"),
("PI6", "ALETA", "TI1"),
("PI7", "PILOTO", "TI3"),
("PI8", "CALENTADOR", "TI2"),
("PI9", "CORREAS", "TI4");

insert into relacion values
("ME1", "1234-CDF", "PE1", "PI1", 23),
("ME1", "0123-BVC", "PE2", "PI2", 98),
("ME1", "1456-BNL", "PE3", "PI6", 124),
("ME1", "4567-BCB", "PE4", "PI5", 245),
("ME2", "0987-CCC", "PE1", "PI9", 345),
("ME2", "0987-CCC", "PE1", "PI8", 232),
("ME2", "0987-BFG", "PE2", "PI1", 17),
("ME2", "4567-BCB", "PE3", "PI7", 99),
("ME2", "1111-CSA", "PE4", "PI4", 124),
("ME2", "1111-CSA", "PE4", "PI2", 153),
("ME3", "1456-BNL", "PE6", "PI3", 89),
("ME3", "1456-BNL", "PE1", "PI4", 232),
("ME3", "1234-CDF", "PE2", "PI8", 235),
("ME3", "1111-CSA", "PE3", "PI9", 567),
("ME3", "0123-BVC", "PE5", "PI6", 232),
("ME3", "0987-CCC", "PE4", "PI2", 78),
("ME1", "0987-BFG", "PE5", "PI3", 64),
("ME2", "1234-CDF", "PE6", "PI5", 234),
("ME1", "0987-BFG", "PE6", "PI9", 345),
("ME2", "1234-CDF", "PE6", "PI1", 12),
("ME1", "1234-CDF", "PE1", "PI6", 187),
("ME3", "1111-CSA", "PE3", "PI4", 345),
("ME1", "0123-BVC", "PE2", "PI3", 72),
("ME2", "0123-BVC", "PE6", "PI3", 89);


/*DATOS DEL EMPLEADO DE MAYOR SUELDO.*/
select *
from mecanico
where sueldo=(select max(sueldo)
				from mecanico);

/*DATOS DEL EMPLEADO MAYOR*/
select *
from mecanico
where fech_nac=(select min(fech_nac)
				from mecanico);


/*DATOS DEL EMPLEADO MENOR.*/
select *
from mecanico
where fech_nac=(select max(fech_nac)
				from mecanico);
                
/* DATOS DE TODOS LOS COCHES DIESEL.*/
select *
from coche
where tipo like "DIESEL";

/* DATOS DEL COCHE QUE MAS HA IDO AL TALLER.*/
select c.*
from coche as c
join relacion as r on c.mat_co=r.mat_co
group by mat_co
having count(c.mat_co)=(select count(mat_co)
						from relacion
                        group by mat_co
                        order by count(mat_co) desc limit 1);


/* PRECIO TOTAL DE TODAS LAS REPARACIONES.*/
select sum(precio)
from relacion;


/*- NOMBRE DE PIEZA Y TIPO DE LA PIEZA MAS USADA.*/
select p.nom_piez, t.nom_tipo
from pieza as p
join tipo as t on p.id_tipo=t.id_tipo
join relacion as r on p.id_piez=r.id_piez
group by p.nom_piez, t.nom_tipo
having count(r.id_piez)=(select count(r2.id_piez)
						from relacion as r2
                        group by r2.id_piez
                        order by 1 desc limit 1);

/*NOMBRE Y TIPO DE LA PIEZA MENOS USADA.*/
select p.nom_piez, t.nom_tipo
from pieza as p
join tipo as t on p.id_tipo=t.id_tipo
join relacion as r on p.id_piez=r.id_piez
group by p.nom_piez, t.nom_tipo
having count(r.id_piez)=(select count(r2.id_piez)
						from relacion as r2
                        group by r2.id_piez
                        order by 1 asc limit 1);
                        
/* MATRICULA, MARCA, MODELO COLOR PIEZA Y TIPO DE TODOS LOS COCHES
REPARADOS.*/
select distinct c.*, p.nom_piez, t.nom_tipo
from coche as c
join relacion as r on c.mat_co=r.mat_co
join pieza as p on p.id_piez=r.id_piez
join tipo as t on t.id_tipo=p.id_tipo
order by c.mod_co;

/*MODELO DE PIEZA Y TIPO PUESTAS A ‘0123-BVC’*/
select p.nom_piez, t.nom_tipo
from pieza as p
join tipo as t on p.id_tipo=t.id_tipo
join relacion as r on p.id_piez=r.id_piez
join coche as c on c.mat_co=r.mat_co
where r.mat_co like "0123-BVC";

/*-DINERO QUE HA GASTADO EN REPARACIONES 1234-CDF*/
select sum(precio)
from relacion as r
where r.mat_co like "1234-CDF";

/*DATOS DEL COCHE QUE MAS HA GASTADO EN REPARACIONES*/
select c.*, sum(r.precio)
from relacion as r
join coche as c on r.mat_co=c.mat_co
group by c.mat_co
having sum(r.precio)=(select sum(precio)
					from relacion
                    group by mat_co
                    order by sum(precio) desc limit 1);
                    
/*DATOS DEL COCHE QUE MENOS HA GASTADO EN REPARACIONES*/
select c.*, sum(r.precio)
from relacion as r
join coche as c on r.mat_co=c.mat_co
group by c.mat_co
having sum(r.precio)=(select sum(precio)
					from relacion
                    group by mat_co
                    order by sum(precio) asc limit 1);
                    
/*- DATOS DEL COCHE QUE MENOS HA GASTADO EN EL TALLER.*/
select c.*, sum(r.precio)
from relacion as r
join coche as c on r.mat_co=c.mat_co
group by c.mat_co
having sum(r.precio)=(select sum(precio)
					from relacion
                    group by mat_co
                    order by sum(precio) asc limit 1);
                    
/*- TOTAL DE TODAS LAS REPARACIONES DE ‘ANA LUCAS’*/
select m.nom_mec, count(m.id_mec)
from mecanico as m
join relacion as r on m.id_mec=r.id_mec
group by m.id_mec
having m.nom_mec like "ANA LUCAS";
                        
/*- DATOS DE LOS COCHES Y LAS PIEZAS PUESTAS POR ‘JUAN ROMUALDO’*/
select c.*, p.*, m.nom_mec
from coche as c
join relacion as r on c.mat_co=r.mat_co
join pieza as p on r.id_piez=p.id_piez
join mecanico as m on r.id_mec=m.id_mec
where m.nom_mec like "JUAN ROMUALDO";

/*- FECHA DE INICIO Y FIN DEL PERIODO EN QUE MAS SE HA TRABAJADO.*/
select p.fec_ini, p.fec_fin
from periodo as p
join relacion as r on p.id_per=r.id_per
group by r.id_per
having count(r.id_per)=(select count(id_per)
						from relacion
                        group by id_per
                        order by count(id_per) desc limit 1);

/*FECHA DE INICIO Y FIN DEL PERIODO QUE MENOS SE HA TRABAJADO.*/
select p.fec_ini, p.fec_fin
from periodo as p
join relacion as r on p.id_per=r.id_per
group by r.id_per
having count(r.id_per)=(select count(id_per)
						from relacion
                        group by id_per
                        order by count(id_per) asc limit 1);

/*-DINERO QUE SE HA HECHO EN EL PERIODO PE2*/
select sum(precio)
from relacion as r
where id_per like "PE2";

/*DATOS DE LOS COCHES QUE SE LE HALLA PUESTO UN EMBRAGUE*/
select c.*
from coche as c
join relacion as r on c.mat_co=r.mat_co
join pieza as p on r.id_piez=p.id_piez
where r.id_piez like "PI5";

/*DATOS DE LOS COCHES A LOS QUE SE LES HALLA CAMBIADO EL ACEITE*/
select c.*
from coche as c
join relacion as r on c.mat_co=r.mat_co
join pieza as p on r.id_piez=p.id_piez
where r.id_piez like "PI3";

/*- DATOS DE LOS MECANICOS QUE HALLAN PUESTO ALGUNA PIEZA DE TIPO
‘ELECTRICIDAD’.*/
select m.*
from mecanico as m
join relacion as r on m.id_mec=r.id_mec
join pieza as p on r.id_piez=p.id_piez
join tipo as t on p.id_tipo=t.id_tipo
where t.nom_tipo like "ELECTRICIDAD";

/*MONTANTE ECONOMICO DE TODAS LAS PIEZAS DE TIPO CHAPA.*/
select sum(r.precio)
from relacion as r
join pieza as p on r.id_piez=p.id_piez
join tipo as t on p.id_tipo=t.id_tipo
where t.nom_tipo like "CHAPA";

/*TIPO DE PIEZA QUE MAS DINERO HA DEJADO EN EL TALLER.*/
select t.nom_tipo
from tipo as t
join pieza as p on t.id_tipo=p.id_tipo
join relacion as r on p.id_piez=r.id_piez
group by r.id_piez
having sum(r.precio)=(select sum(precio)
					  from relacion
                      group by id_piez
                      order by sum(precio) desc limit 1);

/*-DATOS DEL MECANICO QUE MENOS HA TRABAJADO. */
select m.*
from mecanico as m
join relacion as r on  m.id_mec=r.id_mec
group by r.id_mec
having count(r.id_mec)=(select count(id_mec)
						from relacion
                        group by id_mec
                        order by count(id_mec) asc limit 1);


















