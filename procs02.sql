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
       on update cascade on delete cascade
       deferrable initially deferred,
   cod_materia varchar(20) not null
       references materia(codigo)
       on update cascade on delete cascade
       deferrable initially deferred,
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

-- hacemos un trigger que exija que el alumno a insertar tenga materias inscritas

create or replace function check_inscrito()
returns trigger as $$
declare
    cant integer;
begin
    select count(*) into cant
    from inscripcion where ced_estudiante=NEW.cedula;
    
    if cant = 0 then
       RAISE EXCEPTION 'estudiante no inscrito';
       RETURN NULL;
    end if;
    
    RETURN NEW;
end;
$$ language plpgsql;

create trigger trigger_inscrito before insert on estudiante
for each row execute procedure check_inscrito();

-- esto debe fallar porque insertamos sin inscripción
insert into estudiante(cedula,nombre,sexo,direccion) values (1818,'Ines Gonzalez','F','caracas');

-- en una transacción insertamos primero la inscripción. La llave foránea
-- está inicialmente diferida asi que no tendremos problemas por el registro 
-- de estudiante inexistente
begin;
insert into inscripcion values (1818, 'comp01');
insert into estudiante(cedula,nombre,sexo,direccion) values (1818,'Ines Gonzalez','F','caracas');
commit;

-- ejercicio: hacer un trigger que no permita insertar materias con menos de 2 inscritos

