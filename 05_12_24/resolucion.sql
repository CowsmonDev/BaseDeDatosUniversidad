/* TODO: El siguiente esquema de base de datos (link) forma parte de un sistema de gestión de información relacionada con la agricultura, abarcando desde la siembra hasta la venta de cultivos. Las tablas incluyen detalles sobre los agricultores (con sus datos personales y fecha de registro en el sistema), sobre los cultivos sembrados por cada agricultor (incluyendo tipo de cultivo, nombre y fecha de siembra), sobre las cosechas resultantes de cada cultivo (detallando la fecha de cosecha, la cantidad cosechada y el precio estimado) y sobre las ventas efectuadas para cada cosecha (incluyendo la cantidad vendida, el precio de venta por unidad y la fecha de venta). También se registran los proveedores de insumos agrícolas, así como el inventario con las entregas recibidas de parte de los proveedores para cultivos específicos (indicando la cantidad recibida y la fecha de recepción).
 */

/* TODO: 1) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando sólo las tablas/atributos necesarios.

*/
-- 1.a) Controlar que los proveedores tengan registrado un teléfono o un email. Seleccione la opción que considera correcta, de acuerdo a lo solicitado y justifique claramente (debajo de la pregunta 1.c )

-- a.
ALTER TABLE Proveedor
    ADD CONSTRAINT chk_contacto
        CHECK (Telefono IS NULL OR Email IS NULL);

-- b.
ALTER TABLE Proveedor
    ADD CONSTRAINT chk_contacto
        CHECK (Telefono IS NULL AND Email IS NULL);

-- c. TODO: esta es la correcta
ALTER TABLE Proveedor
    ADD CONSTRAINT chk_contacto
        CHECK (Telefono IS NOT NULL OR Email IS NOT NULL);


-- d. Ninguna de las opciones

-- e.
ALTER TABLE Proveedor
    ADD CONSTRAINT chk_contacto
        CHECK (Telefono IS NOT NULL AND Email IS NOT NULL);

-- f.
ALTER TABLE Proveedor
    ADD CONSTRAINT chk_contacto
        CHECK (NOT EXISTS (SELECT 1
                           from PROVEEDOR
                           WHERE Telefono IS NOT NULL
                              OR Email IS NOT NULL));

-- g.
ALTER TABLE Proveedor
    ADD CONSTRAINT chk_contacto
        CHECK (NOT EXISTS (SELECT 1
                           from PROVEEDOR
                           WHERE Telefono IS NULL
                             AND Email IS NULL));

-- 1.b) Verificar que la cantidad total vendida de cada cosecha no exceda la cantidad cosechada de la misma. Seleccione la opción que considera correcta, de acuerdo a lo solicitado y justifique claramente (debajo de la pregunta 1.c ):
-- a.
ALTER TABLE venta
    add constraint check_fecha_siembra
        CHECK (not exists (select 1
                           from cosecha c
                                    join venta v using (id_cultivo)
                           group by id_cultivo
                           having SUM(v.cantidad_vendida) > c.cantidad_cosechada) );

-- b. TODO: esta es la correcta
CREATE
ASSERTION check_fecha_siembra
    CHECK ( not exists (
       select 1 from cosecha c join venta v using (id_cultivo, nro_cosecha)
       group by id_cultivo, nro_cosecha
       having SUM(v.cantidad_vendida) > c.cantidad_cosechada )
       );

-- c.
CREATE
ASSERTION check_fecha_siembra
    CHECK (not exists (
        select 1 from cosecha c join venta v using (id_cultivo, nro_cosecha)
        where SUM(v.cantidad_vendida) > c.cantidad_cosechada
        group by nro_cosecha )
);

-- d. Ninguna de las opciones
-- e.
CREATE
ASSERTION check_fecha_siembra
    CHECK ( exists (
        select 1 from cosecha c join venta v using (id_cultivo, nro_cosecha)
        group by id_cultivo, nro_cosecha
        having SUM(v.cantidad_vendida) <= c.cantidad_cosechada
    ));

-- f.
CREATE
ASSERTION check_fecha_siembra
CHECK (not exists (
        select 1 from cosecha c join venta v using (id_cultivo)
        group by id_cultivo
        having SUM(v.cantidad_vendida) > c.cantidad_cosechada
    ));

-- g.
ALTER TABLE cosecha
    add constraint check_fecha_siembra
        CHECK (not exists (select 1
                           from cosecha c
                                    join venta v using (nro_cosecha)
                           group by nro_cosecha
                           having SUM(v.cantidad_vendida) <= c.cantidad_cosechada) );

-- TODO: 1.c) En el esquema dado se requiere incorporar la siguiente restricción según SQL estándar utilizando el recurso declarativo más restrictivo posible (a nivel de atributo, de tupla, de tabla o general) y utilizando sólo las tablas/atributos necesarios.

-- Para cada cultivo, los números de cosecha deben reflejar el orden cronológico de las fechas de cosecha; es decir, un número de cosecha mayor debe corresponder a una fecha de cosecha posterior para el mismo cultivo.


ALTER TABLE cosecha
    ADD CONSTRAINT ck_orden_cronologico
        CHECK (NOT EXISTS (SELECT 1
                           FROM cosecha c1
                                    JOIN cosecha c2 USING (id_cultivo)
                           WHERE c1.nro_cosecha > c2.nro_cosecha
                             AND c1.fecha_cosecha < c2.fecha_cosecha));

/*2.a) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente
actualizable en PostgreSQL, siempre que sea posible:
- V1: que contenga los datos de los cultivos sembrados durante el corriente año que no registren inventario de
productos adquiridos al proveedor ‘AgroPlus’.
Considerando la siguiente definición para V1, seleccione la/s afirmación/es que considere correcta/s respecto
de esta vista (Nota: tenga en cuenta que las opciones incorrectamente seleccionadas pueden restar puntaje) y
justifíquela/s claramente (debajo de la pregunta 2.c).

 */
CREATE VIEW V1 AS
SELECT *
FROM cultivo
WHERE EXTRACT(YEAR FROM fecha_siembra) = EXTRACT(YEAR FROM CURRENT_DATE)
  AND id_cultivo IN (SELECT id_cultivo
                     FROM inventario
                              JOIN proveedor using (id_proveedor)
                     WHERE nombre <> 'AgroPlus');

/*
a. no resulta automáticamente actualizable en PostgreSQL
b. no es posible reformularla para que cumpla lo requerido (y sea automáticamente actualizable)
c. para cumplir lo requerido hay que reformularla, sólo cambiando IN por NOT IN
d. para cumplir lo requerido hay que reformularla, cambiando IN por NOT IN y <> por = -- TODO: esta es correcta
e. no garantiza que los cultivos de este año no tengan inventario de productos de 'AgroPlus' -- TODO: esta es correcta
f. incluye cultivos de este año que tienen inventarios de proveedores distintos de 'AgroPlus' -- TODO: esta es correcta
g. es automáticamente actualizable en PostgreSQL -- TODO: esta es correcta
h. filtra correctamente los cultivos de este año que no tienen inventario de 'AgroPlus'
i. ninguna de las opciones
j. para cumplir lo requerido hay que reformularla, sólo cambiando <> por =
  */


/*
TODO: 2.b) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente actualizable en PostgreSQL, siempre que sea posible:

    - V2: que contenga para cada cosecha con al menos 3 ventas realizadas, el identificador de la cosecha, la cantidad total vendida y la fecha de la última venta registrada. Considerando la siguiente definición para V2, seleccione la/s afirmación/es que considere correcta/s respecto de esta vista (Nota: tenga en cuenta que las opciones incorrectamente seleccionadas pueden restar puntaje) y justifíquela/s claramente (debajo de la pregunta 2.c)
*/

CREATE VIEW V2 AS
SELECT nro_cosecha,
       id_cultivo,
       SUM(cantidad_vendida) AS total_vendido,
       MAX(fecha_venta)      AS ultima_venta
FROM venta
GROUP BY nro_cosecha, id_cultivo
HAVING COUNT(*) >= 3;
/*
a. no es automáticamente actualizable al incluir agrupamiento en su definición -- TODO: esta es correcta
b. ninguna de las opciones
c. la cláusula HAVING incluida no permite asegurar que solo se incluyan cosechas con al menos tres ventas realizadas
d. calcula incorrectamente la fecha de la última venta registrada y de la fecha de la última venta registrada porque no incluye una cláusula WHERE para filtrar valores nulos
e. resulta automáticamente actualizable en PostgreSQL
f. no resuelve lo requerido debido a que la cantidad total vendida y la fecha de la última venta registrada no se asocian adecuadamente a cada cosecha diferente
g. calcula correctamente la cantidad total vendida y la fecha de la última venta registrada por cada cosecha diferente -- TODO: esta es correcta
h. mediante la cláusula HAVING se asegura que solo se incluyan cosechas con al menos tres ventas realizadas -- TODO: esta es correcta
i. resulta automáticamente actualizable para el estándar SQL
j. puede convertirse en actualizable si se elimina la cláusula HAVING
*/

/*
TODO: 2.c) Sobre el esquema dado se requiere definir la siguiente vista, de manera que resulte automáticamente actualizable en PostgreSQL, siempre que sea posible, y que se verifique que no haya migración de tuplas de la vista:. Resuelva según lo solicitado y justifique su solución.

    - V3: que contenga los datos de los cultivos que han tenido el mayor promedio de cantidad vendida el año actual.
*/
CREATE VIEW V3 AS
SELECT *
FROM cultivo
WHERE id_cultivo IN (SELECT id_cultivo
                     FROM (SELECT id_cultivo,
                                  avg(cantidad_vendida) as promedio_por_cultivo
                           FROM venta
                           WHERE extract(year from current_date) = extract(year from fecha_venta)
                           GROUP BY id_cultivo) promedios
                     WHERE promedio_por_cultivo = (SELECT MAX(promedio_por_cultivo)
                                                   FROM (SELECT avg(cantidad_vendida) as promedio_por_cultivo
                                                         FROM venta
                                                         WHERE extract(year from current_date) = extract(year from fecha_venta)
                                                         GROUP BY id_cultivo) max_promedio));

/*3) Para el esquema dado, se ha creado la tabla cultivos_agricultor donde se requiere registrar la siguiente información para todos los agricultores que están registrados en la base:
    id_agricultor, nombre, fecha_registro, cantidad_cultivos, fecha_ultima_siembra donde, para cada agricultor:
        - cantidad_cultivos corresponde a la cantidad de cultivos que registra
        - fecha_ultima_siembra es la fecha correspondiente a la última siembra que realizó
Nota: en caso que un agricultor no registre cultivos, se deberá indicar apropiadamente.

TODO: a) Implemente el método más adecuado en PostgreSQL que permita completar dicha tabla con la información de todos los agricultores a partir de los datos existentes en la base. Explique su solución e incluya la sentencia que debería utilizar un usuario para la ejecución del mismo. Nota: no puede utilizar sentencias de bucle (for, loop, etc.) para resolverlo.
 */

DROP TABLE cultivos_agricultor;
CREATE TABLE cultivos_agricultor
(
    id_agricultor        int          NOT NULL,
    nombre               varchar(100) NOT NULL,
    fecha_registro       date         NULL,
    cantidad_cultivos    int          NOT NULL,
    fecha_ultima_siembra date         NULL
);

CREATE OR REPLACE PROCEDURE pg_cultivos_agricultor()
    language plpgsql as
$$
begin
    delete from cultivos_agricultor where true;

    insert into cultivos_agricultor
    select id_agricultor,
           nombre,
           fecha_registro,
           count(id_cultivo)    cantidad_cultivos,
           max(c.fecha_siembra) fecha_ultima_siembra
    from agricultor a
             left join cultivo c using (id_agricultor)
    group by id_agricultor, nombre, fecha_registro;
end;
$$;

delete
from cultivos_agricultor
where true;
select *
from cultivos_agricultor;
call pg_cultivos_agricultor();

/*
3.b) Indique y justifique todos los eventos críticos necesarios para mantener los datos actualizados en la tabla cultivos_agricultor cuando se produzcan actualizaciones en la base. Incluya la declaración de los triggers correspondientes en PostgreSQL y escriba la implementación de la/s función/es requerida/s para operaciones de insert.
*/


-- Resolucion, Eventos Criticos:
-- TODO: Agricultor
-- INSERT: se debe insertar en cultivos_agricultor cuando se agrega un nuevo agricultor, este agricultor va a tener fecha null y cantidad_cultivos 0
-- DELETE: asumimos que existe una foreign key
-- UPDATE: si se cambia el nombre o la fecha de registro
-- TODO: cultivo
-- INSERT: si se agrega un nuevo cultivo hay que incrementar un cultivo al agricultor y volver a revisar la fecha de la ultima siembra
-- UPDATE: si se modifica la fecha de siembra hay que verificar si existe un cultivo mas reciente, si se modifica el agricultor hay que modificar
-- DELETE: si se elimina un cultivo hay que restarle un elemento a la cantidad de cultivos al agricultor afectado

CREATE OR REPLACE FUNCTION fn_modify_agricultor_to_agricultor_cultivo() returns trigger as
$$
begin
    if (tg_op = 'INSERT') then
        INSERT INTO cultivos_agricultor(id_agricultor, nombre, fecha_registro, cantidad_cultivos, fecha_ultima_siembra)
        values (new.id_agricultor, new.nombre, new.fecha_registro, 0, null);
    end if;
    if (tg_op = 'UPDATE') then
        UPDATE cultivos_agricultor
        set nombre         = new.nombre,
            fecha_registro = new.fecha_registro
        where id_agricultor = new.id_agricultor;
    end if;
end;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER tg_modify_agricultor_to_agricultor_cultivo
    after insert or update of nombre, fecha_registro
    on agricultor
    for each row
execute function fn_modify_agricultor_to_agricultor_cultivo();

CREATE OR REPLACE FUNCTION fn_modify_cultivo_to_agricultor_cultivo() returns trigger as
$$
DECLARE
    cultivo_agricultor_existente RECORD;
begin
    if (tg_op = 'INSERT' or tg_op = 'UPDATE') then
        UPDATE cultivos_agricultor
        set cantidad_cultivos    = (select cantidad_cultivos
                                    from cultivos_agricultor
                                    where id_agricultor = old.id_agricultor),
            fecha_ultima_siembra = (select max(fecha_siembra) from cultivo where id_agricultor = new.id_agricultor);
    elseif (tg_op = 'DELETE' or tg_op = 'UPDATE') then
        UPDATE cultivos_agricultor
        set cantidad_cultivos    = (select cantidad_cultivos
                                    from cultivos_agricultor
                                    where id_agricultor = old.id_agricultor),
            fecha_ultima_siembra = (select max(fecha_siembra) from cultivo where id_agricultor = old.id_agricultor);
    end if;


end;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER  tg_modify_cultivo_to_agricultor_cultivo
    after INSERT or DELETE or UPDATE of fecha_siembra, id_agricultor
    on cultivo
    for each row
    EXECUTE function fn_modify_cultivo_to_agricultor_cultivo();