/*
TODO: El esquema es parte de un sistema de gestion de planes de servicios a usuarios por parte de una empresa. De los planes disponibles se registra su identificador, nombre, año de inicio y tipo de plan, que puede ser tradicional o promocional. De los usuarios que se registra su numero, apellido y nombre, ciudad y fecha de alta en el sistema. Se lleva registro de las asignaciones de planes a los usuarios, indicando desde cuando y hasta cuando estara asignado y el numero de dispositivos habilitados. De cada usuario se almacenan las distintas gestiones que efectua con el motivo y plan asociado si corresponde.
*/

-- TODO: Ejercicio 1:
/*
a) Complete apropiadamente las siguientes definiciones de vistas sobre el esquema dado, teniendo en cuenta que deben resultar -siempre que sea posible- automáticamente actualizables en PostgreSQL, justificándolo en cada caso:
*/

-- TODO: V1 con los datos de los usuarios de Tandil o Mar del Plata que no registran gestiones sobre planes promocionales durante el corriente año.

DROP VIEW V1;
CREATE OR REPLACE VIEW V1 (nroUsuario, apell_nombre, ciudad, anio_alta) as
select nrousuario, apell_nombre, ciudad, extract(year from fecha_alta)
from usuario
where (ciudad = 'Mar del Plata'
    or ciudad = 'Tandil')
  and nrousuario not in (select usuario
                         from gestion g
                                  join plan_promo pp using (idarea, cod_plan)
                         where extract(year from g.fecha) = extract(year from current_date));


-- TODO: V2 con los datos completos de todos los planes ofrecidos, incluyendo también los atributos: caract_cond (con su característica o condición, según sea plan tradicional o promocional) y descuento (con el valor de descuento ofrecido si es promocional, o 0 si es tradicional).

-- CREATE VIEW V2 (cod_plan, idarea, nombre, anio_inicio, tipo_plan, caract_cond, descuento) AS ... ;

CREATE VIEW V2 (cod_plan, idarea, nombre, anio_inicio, tipo_plan, caract_cond, descuento) AS
select cod_plan, idarea, nombre, anio_inicio, tipo_plan, condicion, descuento
from plan p
         join (select idarea, cod_plan, condicion, descuento
               from plan_promo
               union all
               select idarea, cod_plan, caracteristica, 0
               from plan_trad) as todos_planes using (idarea, cod_plan);

-- b) Respecto de las vistas V1 y V2 anteriores que no resulten actualizables por parte del SGBD, provea una implementación completa en PostgreSQL para posibilitar la propagación adecuada de inserciones. Explique su solución y ejemplifique a partir de una sentencia SQL concreta.

-- TODO: V2
CREATE OR REPLACE FUNCTION fn_insert_V1() returns trigger as
$$
begin
    INSERT INTO usuario (nroUsuario, apell_nombre, ciudad, fecha_alta)
    VALUES (NEW.nroUsuario,
            NEW.apell_nombre,
            NEW.ciudad,
            make_date(NEW.anio_alta, 1, 1) -- fecha con 1 de enero del año dado
           );
    RETURN NULL;
end;
$$ language plpgsql;

CREATE TRIGGER tg_insert_V1
    INSTEAD OF INSERT
    on V1
    for each row
execute function fn_insert_V1();

-- TODO: V2
CREATE OR REPLACE FUNCTION fn_insert_V2() returns trigger as
$$
begin

    insert into plan(idarea, cod_plan, nombre, anio_inicio, tipo_plan)
    values (new.idarea, new.cod_plan, new.nombre, new.anio_inicio, new.tipo_plan);

    if (new.tipo_plan = 'promocional') then
        insert into plan_promo(idarea, cod_plan, condicion, descuento)
        values (new.idarea, new.cod_plan, new.caract_cond, new.descuento);
    elseif (new.tipo_plan = 'tradicional') then
        insert into plan_trad(idarea, cod_plan, caracteristica)
        values (new.idarea, new.cod_plan, new.caract_cond);
    end if;
    return null;
end;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER tg_insert_V2
    INSTEAD OF INSERT
    on V2
    for each row
execute FUNCTION fn_insert_V2();

select *
from plan
         NATURAL JOIN gestion;

-- TODO: Ejercicio 2:
--  Provea la implementación completa en SQL estándar para las siguientes restricciones sobre el esquema dado, mediante el recurso declarativo más restrictivo (justifique claramente su elección). Si en algún caso no es posible, explique por qué.

-- a) Cada usuario puede tener hasta 3 asignaciones de planes diferentes por año (Nota: considere sólo la fecha desde cuándo se realiza la asignación).
alter table asignacion
    add constraint chk_cantidad_asignaciones check ( not exists(SELECT nrousuario, extract(year from fecha_desde) anio_fecha_desde
                                                                FROM asignacion
                                                                group by nrousuario, anio_fecha_desde
                                                                having count(*) > 3) );

-- b) En toda gestión realizada por un usuario debe controlarse que, en caso de asociarse a un plan, éste corresponda a uno de los planes que el usuario tiene asignado y durante el periodo de vigencia del mismo.

CREATE
ASSERTION gestion_asignacion_valida CHECK (
    NOT EXISTS (
        SELECT 1
        FROM gestion g
        WHERE g.idArea IS NOT NULL AND g.cod_plan IS NOT NULL
          AND NOT EXISTS (
              SELECT 1
              FROM asignacion a
              WHERE a.nroUsuario = g.usuario
                AND a.idArea = g.idArea
                AND a.cod_plan = g.cod_plan
                AND g.fecha BETWEEN a.fecha_desde AND COALESCE(a.fecha_hasta, DATE '9999-12-31')
          )
    )
);

--c) Una vez indicada la fecha_hasta correspondiente a una asignación, ésta podrá modificarse pero no nulificarse.
-- no se puede hacer de manera declarativa en Sql estandar hay que establecerlo con un trigger

-- TODO: Ejercicio 3
--  Respecto de las restricciones del ej. 2) que no pueden ser implementadas declarativamente en PostgreSQL,

-- a) determine y justifique todos los eventos críticos que debe controlar en cada caso ante actualizaciones sobre la BD.
-- b) provea una implementación completa en PostgreSQL que permita controlar el cumplimiento de cada restricción ante inserciones de datos.

-- 2.a)
/*
Tablas:
    - Asignacion
        Eventos:
            - INSERT: al insertar hay que verificar que no sobrepase la condicion en ese año
            - UPDATE: si se modifica el anio de la fecha o el usuario asignado hay que verificar
*/

CREATE OR REPLACE function fn_chk_cantidad_asignaciones() returns trigger as
$$
begin
    if ((select count(*)
         from asignacion
         where nrousuario = new.nrousuario
           and extract(year from fecha_desde) = extract(year from current_date)) > 3) then
        raise exception 'No puede haber mas de 3 asignaciones en el mismo año para el mismo usuario';
    end if;
    return new;
end;
$$ language plpgsql;

create or replace trigger fn_chk_cantidad_asignaciones
    after insert or update OF fecha_desde, nrousuario
    on asignacion
    for each row
execute FUNCTION fn_chk_cantidad_asignaciones();

-- 2.b)
/*
Tablas:
    - Gestion
        Eventos:
            - INSERT: cuando se inserta una gestion hay que verificar que existe un plan en esa fecha
            - UPDATE: si se modifica el plan, la feccha o el usuario hay que verificar que cumpla la condicion
    - Asignacion
        Eventos:
            - DELETE: si se elimina una asignacion hay que verificar que no existan gestiones para dicha asignacion en esa fecha
            - UPDATE: si se modifica la fecha, el plan o el usuario hay que volver a verificar la gestion
*/

-- 2.c)
/*
    Tablas:
       - Asignacion:
            - UPDATE: si se modifica la fecha_hasta hay que verificar haya sido null o que las fechas sean identicas
 */


CREATE OR REPLACE FUNCTION fn_check_fecha_hasta() returns trigger as
$$
begin
    raise 'la fecha hasta una vez asignada no puede ser modificada';
end;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER tg_check_fecha_hasta
    before update of fecha_hasta
    ON asignacion
    for each row
    when ( old.fecha_hasta is null or old.fecha_hasta <> new.fecha_hasta )
execute function fn_check_fecha_hasta();

-- TODO: Ejercicio 4:
--  La siguiente tabla ha sido creada sobre el esquema dado para contener, por cada año, el nombre del plan, la fecha de la primera asignación en dicho año, la cantidad de asignaciones realizadas de dicho plan y el promedio de dispositivos asignados en tal año.

create table if not exists InformePlan
(
    NombrePlan      varchar(50) not null,
    Anio            int,
    prim_fecha_asig date,
    cant_asig_plan  int,
    prom_disposit   int
);
/*
TODO: Mediante el método que considere más adecuado, provea una implementación completa en PostgreSQL que permita completar adecuadamente la tabla InformePlan, teniendo en cuenta un intervalo de años brindados por el usuario. Tenga en cuenta que sólo deben existir en la tabla los datos comprendidos para todos los planes en el periodo de años indicados.
 Explique su solución Nota: No debe utilizar sentencias de bucle (for, loop, etc.) en su solución
*/

CREATE OR REPLACE PROCEDURE llenar_informe_plan(anio_desde integer, anio_hasta integer) as
$$
begin
    insert into informeplan (select p.nombre,
                                    p.anio_inicio,
                                    a_min.primera_asignacion,
                                    a_min.cantidad_asignaciones,
                                    a_min.promedio_dispositivos
                             from plan p
                                      join
                                  (select cod_plan,
                                          idarea,
                                          min(fecha_desde) as   primera_asignacion,
                                          count(*)              cantidad_asignaciones,
                                          avg(num_dispositivos) promedio_dispositivos
                                   from asignacion
                                   group by cod_plan, idarea, extract(year from fecha_desde)) as a_min
                                  using (idarea, cod_plan)
                             where p.anio_inicio between anio_desde and anio_hasta);
end;
$$ language plpgsql;

call llenar_informe_plan(2021, 2024);

select *
from informeplan;

delete
from informeplan
where true;