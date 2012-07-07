create table producto (
    id serial primary key,
    nombre varchar(30) not null,
    precio numeric(7,2) not null
);

insert into producto(nombre,precio) values ('martillo',205.22);
insert into producto(nombre,precio) values ('destornillador',115.89);
insert into producto(nombre,precio) values ('tuerca',20.65);

create table factura (
    id serial primary key,
    ced_comprador integer not null,
    nom_comprador varchar(50) not null,
    fecha timestamp not null default(now())
);

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

-- restringimos que la factura tenga productos
create or replace function check_productos()
returns trigger as $$
declare
    cant integer;
begin
    select count(*) into cant
    from factura_producto where id_factura=NEW.id;
    
    if cant = 0 then
       RAISE EXCEPTION 'factura sin producto';
       RETURN NULL;
    end if;
    
    RETURN NEW;
end;
$$ language plpgsql;

create trigger trigger_factura_producto before insert on factura
for each row execute procedure check_productos();

-- restringimos que el precio en la factura sea el actual
create or replace function check_precio()
returns trigger as $$
declare
    p numeric(7,2);
begin
    select precio into p
    from producto where id=NEW.id_producto;
    
    if p <> NEW.precio then
       RAISE EXCEPTION 'precio invalido';
       RETURN NULL;
    end if;
    
    RETURN NEW;
end;
$$ language plpgsql;

create trigger trigger_precio_producto before insert on factura_producto
for each row execute procedure check_precio();

-- probamos tratar de insertar factura sin productos
begin;

insert into factura(ced_comprador,nom_comprador) values(1515,'Jorge');


commit;
-- da error porque la factura no tiene producto

-- hacemos una inserción correcta
-- OJO: esto es una función "inline" requiere postgresql >= 9.0
begin;
do $$
declare
 idf integer;
begin
   select nextval('factura_id_seq') into idf;
   insert into factura_producto values (1,idf,205.22);
   insert into factura_producto values (2,idf,115.89);
   insert into factura(id,ced_comprador,nom_comprador) values(idf,1515,'Jorge');
end $$;
commit;


-- ¿qué pasa si ponemos otros precios?
begin;
do $$
declare
 idf integer;
begin
   select nextval('factura_id_seq') into idf;
   insert into factura_producto values (1,idf,200.22);
   insert into factura_producto values (2,idf,116.89);
   insert into factura(id,ced_comprador,nom_comprador) values(idf,1616,'Maria');
end $$;
commit;
-- error ERROR:  precio invalido
-- CONTEXT:  SQL statement "insert into factura_producto values (1,idf,200.22)"
-- PL/pgSQL function "inline_code_block" line 6 at SQL statement









