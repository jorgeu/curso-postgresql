create table estudiante (
   id SERIAL primary key,
   cedula integer unique,
   nombre varchar(50) not null,
   sexo character check(sexo in ('M','F')) not null,
   direccion varchar(200) not null
);

alter table estudiante add column telefono varchar(11) not null;

alter table estudiante drop column telefono;

drop table estudiante;
