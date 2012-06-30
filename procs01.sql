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

create or replace function materias1(ced integer)
returns TABLE(cod varchar(20),tit varchar(50)) as $$
begin
    return query select codigo,titulo from materia join inscripcion on (cod_materia=codigo)
                 where ced_estudiante=ced;
end;
$$ language plpgsql;

-- consultamos para Luis
select * from materias1(1616);

-- ejercicio hacer una función para las materias más concurridas

-- ejercicio hacer una función para la cantidad de estudiantes
