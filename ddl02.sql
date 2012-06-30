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
   id_estudiante integer not null 
       references estudiante(id) 
       on update cascade on delete cascade,
   id_materia integer not null
       references materia(id)
       on update cascade on delete cascade,
   primary key (id_estudiante,id_materia)
);

-- definición separada
create table inscripcion (
   id_estudiante integer not null,
   id_materia integer not null
);
alter table inscripcion add constraint fk_ins_est 
    foreign key (id_estudiante) references estudiante(id) 
    on update cascade on delete cascade;
alter table inscripcion add constraint fk_ins_mat
    foreign key (id_materia) references materia(id)
    on update cascade on delete cascade;
alter table inscripcion add primary key (id_estudiante,id_materia);

