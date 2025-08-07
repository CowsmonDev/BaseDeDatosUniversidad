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

select
    id_cultivo,
    avg(cantidad_vendida)
    from venta
    where extract(year from current_date) = extract(year from fecha_venta)
group by id_cultivo