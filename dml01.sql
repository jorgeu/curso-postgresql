create table estudiante (
   id SERIAL primary key,
   cedula integer unique,
   nombre varchar(50) not null,
   sexo character check(sexo in ('M','F')) not null,
   direccion varchar(200) not null
);

create table materia (
   id SERIAL primary key,
   codigo varchar(20) unique,
   titulo varchar(50) not null
);

-- definición "inline"
create table inscripcion (
   ced_estudiante integer not null 
       references estudiante(cedula) 
       on update cascade on delete cascade,
   cod_materia varchar(20) not null
       references materia(codigo)
       on update cascade on delete cascade,
   primary key (ced_estudiante,cod_materia)
);

insert into estudiante(cedula,nombre,sexo,direccion) values (1515,'Jorge Urdaneta','M','maracaibo');
insert into estudiante(cedula,nombre,sexo,direccion) values (1616,'Luis Ramirez','M','ojeda');
insert into estudiante(cedula,nombre,sexo,direccion) values (1717,'Maria Campos','F','machiques');

insert into materia(codigo,titulo) values ('comp01','Introducción a la computación');
insert into materia(codigo,titulo) values ('comp02','Bases de datos');
insert into materia(codigo,titulo) values ('mat01','Algebra I');
insert into materia(codigo,titulo) values ('mat02','Algebra Lineal');

-- inscribimos a Jorge en todas las materias
insert into inscripcion values (1515, 'comp01');
insert into inscripcion values (1515, 'comp02');
insert into inscripcion values (1515, 'mat01');
insert into inscripcion values (1515, 'mat02');

-- inscribimos a Luis en las matematicas
insert into inscripcion values (1616, 'mat01');
insert into inscripcion values (1616, 'mat02');

-- inscribimos a maria en las de computación
insert into inscripcion values (1717, 'comp01');
insert into inscripcion values (1717, 'comp02');

-- estudiantes inscritos en mat01
select cedula,nombre from estudiante join inscripcion on (cedula=ced_estudiante)
where cod_materia='mat01';

-- estudiantes inscritos en las álgebras
select distinct cedula,nombre from estudiante join inscripcion on (cedula=ced_estudiante) 
                                      join materia on (codigo=cod_materia)
                                      where titulo like 'Algebra%';
                                      
-- estudiante(s) con más materias inscritas
select cedula,nombre from estudiante join inscripcion on (cedula=ced_estudiante)
group by cedula,nombre
having count(*) >= all (select count(*) from inscripcion group by ced_estudiante);

-- cambiamos el nombre de Luis
update estudiante set nombre='Pedro Perez' where cedula=1616;

-- cambiamos a mujer los que no tienen inscritas materias de computación (sólo Pedro hace match)
update estudiante set sexo='F' where cedula not in 
     (select ced_estudiante from inscripcion where cod_materia like 'comp%');
-- verificamos
select * from estudiante where cedula=1616;

-- ejercicio: inserte un estudiante y obtenga la lista de estudiantes y sus materias 
-- inscritas. Incluya aquellos estudiantes no inscritos
-- nota: use LEFT OUTER JOIN 

-- ejercicio: cree una nueva materia. Escriba una consulta que traiga los títulos de las materias sin alumnos

-- ejercicio: escriba una consulta que traiga la materia con mayor cantidad de alumnos inscritos

