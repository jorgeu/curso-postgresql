create table producto (
    id serial primary key,
    nombre varchar(40) not null,
    precio numeric(7,2) not null
);
insert into producto(nombre,precio) 
   select md5(to_char(random()*100,'99.99')),random()*100 
   from generate_series(1,20000);


create table factura (
    id serial primary key,
    ced_comprador integer not null,
    nom_comprador varchar(50) not null,
    fecha timestamp not null default(now())
);

insert into factura (ced_comprador,nom_comprador)
    select 1000+random()*1000, md5(to_char(random()*100,'99.99')) 
   from generate_series(1,5000);

create table factura_producto (
    id_producto integer not null 
       references producto(id)
       on update cascade on delete restrict
       deferrable initially deferred,
    id_factura integer not null
       references factura(id)
       on update cascade on delete cascade
       deferrable initially deferred,
    precio numeric(7,2) not null
);

do $$
declare
   p integer;
   f integer;
   x integer;
begin
    for f in select id from factura
    loop 
       for x in 1..10
       loop
          p := ceil(random()*20000);
          insert into factura_producto values (p,f,random()*100);
       end loop;
    end loop;
end $$;














