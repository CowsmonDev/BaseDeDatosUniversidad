/* TODO: ENUNCIADO GENERAL:
Dado el siguiente esquema relacional en PostgreSQL (script creación), correspondiente a la gestión de internaciones en un centro de salud. Se organiza en torno a áreas médicas, cada una con un médico responsable y la cantidad de habitaciones que se encuentran disponibles (no ocupadas). Cada habitación tiene una descripción de los accesorios que posee, indicación de si dispone o no lugar para acompañante y una situación que indica si la habitación está actualmente (L)libre u (O)cupada. En cada internación de un paciente se asigna una habitación, registrando la fecha de ingreso y de salida (cuando se conoce), el diagnóstico principal y el médico asignado. Los médicos poseen una especialidad y se identifican por el número de matrícula y tipo de matrícula, que puede ser (N)acional o (P)rovincial, y pueden actuar como médicos de cabecera para los pacientes.
*/

-- TODO: Ejercicio 1
-- Considere que se ejecutan las siguientes operaciones sobre la base dada, inicialmente vacía:

INSERT INTO MEDICO (nro_matricula, tipo_matricula, apellido, nombre, especialidad, e_mail, telefono)
VALUES (12345, 'N', 'Gonzalez', 'Maria', 'Cardiologia', 'mgonzalez@email.com', '1122334455'),
       (67890, 'P', 'Fernandez', 'Juan', 'Medicina General', 'jfernandez@email.com', '1199887766'),
       (54321, 'N', 'Garcia', 'Fernando', 'Clinica Medica', 'fgarcia@email.com', '1177554433');

INSERT INTO PACIENTE (id_paciente, apellido, nombre, obra_social, matr_med_cabecera, tipo_mat_med_cabecera)
VALUES (1, 'Perez', 'Carlos', 'OSDE', 12345, null),
       (2, 'Lopez', 'Ana', 'SwissMed', null, 'P'),
       (3, 'Ortiz', 'Laura', null, 12345, 'N'),
       (5, 'Ramirez', 'Mario', 'PAMI', 67890, 'P');

/* TODO: Ejercicio 1.a
1.a) Teniendo en cuenta las diferentes posibilidades de ensamble para listar los datos de
los pacientes y de sus médicos de cabecera, provea la/s sentencia/s
SQL correspondiente/s y analice en qué caso/s se listarían todas las
tuplas de PACIENTE y en qué caso/s no, justificando por qué.
*/

-- Respuesta:
/*
 Tenemos los diferentes joins, para este caso tenemos LEFT JOIN, RIGHT JOIN, FULL JOIN, INNER JOIN, NATURAL JOIN

 - INNER JOIN: para este ensable nos da solo los pacientes que tienen un medico asociado mediante la clave foranea completa.
 si ejecutamos el ensable podemos ver que solo nos devuelve 2 pacientes con id 3 y 5.
 - LEFT JOIN: este ensable nos devuelve todos los pacientes y lo concatena, en caso de tener, con los medicos asociados a este.
 si el paciente no tiene ningun medico asociado se rellena con NULL las casillas correspondientes. si ejecutamos la consulta, nos devuelve
 los 4 pacientes guardados
 - RIGHT JOIN: concepto similar al anterior pero en este caso se muestra a todos los medicos y en caso de no tener un paciente asociado
 se rellena con NULL en el caso de no tener ningun paciente asociado.
 - FULL JOIN: es una combinacion de lo enterior, selecciona todos los pacientes y todos los medicos, en el caso de tener una relacion lo concatena
 y en caso de no tener una relacion validad se rellena con NULL. en este caso muestra los 5 pacientes, con sus respectivos datos y una sexta tupla
 que corresponde al medico que no tiene pacientes asociados
 - NATURAL JOIN: este ensamble unifica a las tablas por los campos que tienen el mismo nombre, en este caso no devuelve ningun dato ya que intentaria relacionar
 las tablas por nombre y apellido y no existe ninguna tupla entre las tablas que lo compartan
 */

SELECT p.id_paciente, m.nro_matricula, m.tipo_matricula
FROM paciente p
         INNER JOIN medico m on p.matr_med_cabecera = m.nro_matricula and p.tipo_mat_med_cabecera = m.tipo_matricula;

SELECT p.id_paciente, p.matr_med_cabecera, p.tipo_mat_med_cabecera, m.nro_matricula, m.tipo_matricula
FROM paciente p
         LEFT JOIN public.medico m
                   on p.matr_med_cabecera = m.nro_matricula and p.tipo_mat_med_cabecera = m.tipo_matricula;
-- where p.id_paciente = 2;

SELECT p.id_paciente, p.matr_med_cabecera, p.tipo_mat_med_cabecera, m.nro_matricula, m.tipo_matricula
FROM paciente p
         RIGHT JOIN public.medico m
                    on p.matr_med_cabecera = m.nro_matricula and p.tipo_mat_med_cabecera = m.tipo_matricula;

SELECT p.id_paciente, p.matr_med_cabecera, p.tipo_mat_med_cabecera, m.nro_matricula, m.tipo_matricula
FROM paciente p
         NATURAL JOIN medico m;

SELECT p.id_paciente, p.matr_med_cabecera, p.tipo_mat_med_cabecera, m.nro_matricula, m.tipo_matricula
FROM paciente p
         FULL JOIN medico m on p.matr_med_cabecera = m.nro_matricula and p.tipo_mat_med_cabecera = m.tipo_matricula;

/* TODO: Ejercicio 1.b
1.b) Luego de ejecutadas las operaciones anteriores, indique si procede o no cada una de las siguientes sentencias y por qué:
    b.1)  UPDATE PACIENTE SET tipo_mat_med_cabecera = ‘N’ WHERE id_paciente = 2;
    b.2) UPDATE PACIENTE SET tipo_mat_med_cabecera =  'P' WHERE id_paciente = 3;
*/


-- b.1)
UPDATE paciente
SET tipo_mat_med_cabecera = 'N'
WHERE id_paciente = 2;
/*
Respuesta: procede ya que por defecto Postgresql tiene Match Simple el cual cuando existe un campo con posibilidad de nulo en la clave foranea compuesta si este lo es, no realiza comprobaciones
*/

-- b.2)
UPDATE PACIENTE
SET tipo_mat_med_cabecera = 'P'
WHERE id_paciente = 3;
/*
Respuesta: no procede ya que aca no importa el matching dado que ninguna de los dos campos de la clave foranea son nulos y en este caso se toma encuenta la RIR y no existe un medico cuyo nro_matricula sea igual a 12345 y tipo de matrica a 'P'
*/

/* TODO: Ejercicio 1.c
1.c) Las siguientes expresiones de consulta SQL intentan listar los datos de los médicos que no están asignados como médicos de cabecera de pacientes. Determine cuál/es de ellas permiten recuperar correctamente dicha información en cualquier caso; si no fuera así, justifique claramente por qué e indique la corrección necesaria en cada una para obtener lo requerido.
*/
-- c.1)
SELECT *
FROM MEDICO
WHERE (nro_matricula, tipo_matricula) NOT IN (SELECT matr_med_cabecera, tipo_mat_med_cabecera
                                              FROM PACIENTE);

-- c.2)
SELECT *
FROM MEDICO M
WHERE tipo_matricula NOT IN (SELECT tipo_mat_med_cabecera
                             FROM PACIENTE P
                             WHERE matr_med_cabecera IS NOT NULL
                               and tipo_mat_med_cabecera IS NOT NULL);

-- c.3)
SELECT *
FROM MEDICO
WHERE NOT EXISTS
          (SELECT matr_med_cabecera, tipo_mat_med_cabecera
           FROM PACIENTE);

/*
Resolucion:
- c.1 no contempla las claves nulas.
- c.2 no utiliza la clave completa y solo utiliza tipo_matricula
- c.3 no realiza la relacion entre la consulta externa y la subconsulta

las correcciones son las siguientes:
*/

-- c.1)
SELECT *
FROM MEDICO
WHERE (nro_matricula, tipo_matricula) NOT IN (SELECT matr_med_cabecera, tipo_mat_med_cabecera
                                              FROM PACIENTE
                                              WHERE matr_med_cabecera IS NOT NULL
                                                and tipo_mat_med_cabecera IS NOT NULL);

-- c.2)
SELECT *
FROM MEDICO M
WHERE (nro_matricula, tipo_matricula) NOT IN (SELECT matr_med_cabecera, tipo_mat_med_cabecera
                                              FROM PACIENTE P
                                              WHERE matr_med_cabecera IS NOT NULL
                                                and tipo_mat_med_cabecera IS NOT NULL);

-- c.3)
SELECT *
FROM MEDICO
WHERE NOT EXISTS
          (SELECT matr_med_cabecera, tipo_mat_med_cabecera
           FROM PACIENTE
           WHERE nro_matricula = matr_med_cabecera
             and tipo_matricula = tipo_mat_med_cabecera);

/* TODO: Ejercicio 2
Considere las siguientes restricciones sobre el esquema dado debidas a políticas de la institución:

A- Al menos el 50% de las camas de cada área deben tener lugar para acompañante.

B- Los pacientes de la obra social PAMI deben tener un médico de cabecera.

C- El médico asignado a una internación debe tener la misma especialidad que el médico responsable del área correspondiente.

Para cada una de las condiciones anteriores:

2.a) plantee la implementación completa en SQL estándar, mediante el recurso declarativo más restrictivo posible (justifique su elección).

2.b) para aquellas restricciones que no puedan incorporarse en PostgreSQL según lo implementado en 2.a), indique y justifique cada uno de los eventos críticos que deben ser chequeados y provea las declaraciones de los triggers correspondientes.

*/


-- TODO: 2.a) plantee la implementación completa en SQL estándar, mediante el recurso declarativo más restrictivo posible (justifique su elección).

-- A- Al menos el 50% de las camas de cada área deben tener lugar para acompañante.
ALTER TABLE habitacion
    ADD CONSTRAINT chk_cantidad_habitaciones_por_area CHECK ( NOT EXISTS(SELECT 1
                                                                         FROM habitacion he
                                                                         where acompaniante = true
                                                                         group by id_area
                                                                         having count(*) >
                                                                                ((select count(*) as cantidad_habitaciones_por_area
                                                                                  from habitacion hi
                                                                                  where he.id_area = hi.id_area) /
                                                                                 2)) );


-- B- Los pacientes de la obra social PAMI deben tener un médico de cabecera.
ALTER TABLE paciente
    ADD CONSTRAINT chk_pacientes_pami_medicos_cabecera CHECK (
        obra_social is null OR obra_social <> 'PAMI' OR
        (matr_med_cabecera is not null AND tipo_mat_med_cabecera is not null)
        );


-- C- El médico asignado a una internación debe tener la misma especialidad que el médico responsable del área correspondiente.
CREATE
ASSERTION internacion_medico_responsable
    CHECK (
       NOT EXISTS(
        select 1
        from internacion i
                 join medico m on i.matr_med_asignado = m.nro_matricula and i.tipo_matr_med_asig = m.tipo_matricula
                 join area a using (id_area)
                 join medico m2 on a.matr_medico_resp = m2.nro_matricula and a.tipo_matr_medico_resp = m2.tipo_matricula
        where m.especialidad <> m2.especialidad
    )
)


-- TODO: 2.b) para aquellas restricciones que no puedan incorporarse en PostgreSQL según lo implementado en 2.a), indique y justifique cada uno de los eventos críticos que deben ser chequeados y provea las declaraciones de los triggers correspondientes.
/*
-- TODO: A- Al menos el 50% de las camas de cada área deben tener lugar para acompañante.
-- el inciso A no se puede implementar en PostgreSql dado que tiene subsoncultas.
-- EVENTOS CRITICOS:
-- Habitaciones:
    -- INSERT: si se inserta una habitacion con el acompaniante false
    -- DELETE: si se elimina una habitacion con el acompaniante true
    -- UPDATE: si se modifica el area de la habitacion o si puede tener acompaniante o no.

 */

CREATE OR REPLACE FUNCTION fn_cincuenta_acompaniante()
    RETURNS trigger AS
$$
BEGIN
    -- Validación sobre OLD.id_area (DELETE o UPDATE con cambio de área)
    IF TG_OP = 'DELETE' OR (TG_OP = 'UPDATE' AND NEW.id_area <> OLD.id_area) THEN
        IF EXISTS (SELECT 1
                   FROM (SELECT COUNT(*) FILTER (WHERE acompaniante) AS con_acompaniante,
                                COUNT(*)                             AS total
                         FROM habitacion
                         WHERE id_area = OLD.id_area) sub
                   WHERE con_acompaniante < (total / 2.0)) THEN
            RAISE EXCEPTION 'Al menos el 50%% de las camas del área (%) deben tener lugar para acompañante', OLD.id_area;
        END IF;
    END IF;

    -- Validación sobre NEW.id_area (INSERT o UPDATE)
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        IF EXISTS (SELECT 1
                   FROM (SELECT COUNT(*) FILTER (WHERE acompaniante) AS con_acompaniante,
                                COUNT(*)                             AS total
                         FROM habitacion
                         WHERE id_area = NEW.id_area) sub
                   WHERE con_acompaniante < (total / 2.0)) THEN
            RAISE EXCEPTION 'Al menos el 50%% de las camas del área (%) deben tener lugar para acompañante', NEW.id_area;
        END IF;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE TRIGGER tg_cincuenta_acompaniante
    AFTER INSERT OR DELETE OR UPDATE OF id_area, acompaniante
    ON habitacion
    FOR EACH ROW
EXECUTE FUNCTION fn_cincuenta_acompaniante();


/*
-- TODO: C- El médico asignado a una internación debe tener la misma especialidad que el médico responsable del área correspondiente.
-- TODO: el inciso C no se puede dado que se realiza con assertion en multiples tablas
-- EVENTOS CRITICOS:
    -- medico:
        -- UPDATE: si se modifica la especialidad hay que verificar la condicion devuelta
    -- internacion:
        -- UPDATE: si se modifica el medico o la area
        -- INSERT: si se inserta una internacion
    -- area:
        -- UPDATE: si se modifica el medico responsable
 */

CREATE OR REPLACE FUNCTION fn_medico_responsable()
    RETURNS trigger AS
$$
BEGIN
    IF (EXISTS(select 1
               from internacion i
                        join medico m
                             on i.matr_med_asignado = m.nro_matricula and i.tipo_matr_med_asig = m.tipo_matricula
                        join area a using (id_area)
                        join medico m2 on a.matr_medico_resp = m2.nro_matricula and
                                          a.tipo_matr_medico_resp = m2.tipo_matricula
               where m.especialidad <> m2.especialidad)
        ) THEN
        raise exception 'El médico asignado a una internación debe tener la misma especialidad que el médico responsable del área correspondiente.';
    end if;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tg_medico_responsable_medico
    AFTER UPDATE OF especialidad
    on medico
    for each statement
EXECUTE FUNCTION fn_medico_responsable();

CREATE OR REPLACE TRIGGER tg_medico_responsable_internacion
    AFTER INSERT OR UPDATE OF id_area, tipo_matr_med_asig, matr_med_asignado
    on internacion
    for each statement
EXECUTE FUNCTION fn_medico_responsable();

CREATE OR REPLACE TRIGGER tg_medico_responsable
    AFTER UPDATE OF tipo_matr_medico_resp, matr_medico_resp
    on area
    for each statement
EXECUTE FUNCTION fn_medico_responsable();


-- TODO: Provea una implementación completa en PostgreSQL mediante el recurso que considere más adecuado para resolver cada uno de los siguientes requerimientos sobre el esquema dado, y justifique incluyendo los aspectos teóricos correspondientes:

-- TODO: 3.a) dada una cierta fecha, brindada por un usuario, se debe verificar si se ha superado el 75% de ocupación de habitaciones en el centro de salud y registrar en una tabla auxiliar (ya creada) si esto sucede, indicando tal fecha y el porcentaje de capacidad alcanzada.

-- =============================================
-- TABLA AUXILIAR SUGERIDA
-- =============================================
CREATE TABLE IF NOT EXISTS ocupacion_habitaciones
(
    id                       SERIAL PRIMARY KEY,
    fecha                    DATE          NOT NULL,
    porcentaje_ocupacion     DECIMAL(5, 2) NOT NULL,
    habitaciones_ocupadas    INTEGER       NOT NULL,
    habitaciones_disponibles INTEGER       NOT NULL,
    fecha_registro           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- VERSIÓN MEJORADA DEL PROCEDIMIENTO
-- =============================================
CREATE OR REPLACE PROCEDURE verificar_ocupacion_habitaciones(fecha_consulta DATE)
AS
$$
DECLARE
    cantidad_internaciones            INTEGER;
    cantidad_habitaciones_disponibles INTEGER;
    porcentaje_ocupacion              DECIMAL(5, 2);
    umbral_ocupacion CONSTANT         NUMERIC := 75.0;

BEGIN
    -- Contar internaciones activas en la fecha dada
    SELECT COUNT(*)
    INTO cantidad_internaciones
    FROM INTERNACION i
    WHERE fecha_ingreso <= fecha_consulta
      AND (fecha_salida IS NULL OR fecha_salida > fecha_consulta);

    -- Contar habitaciones disponibles (asumiendo que situación 'D' = Disponible)
    -- Si no hay campo que indique disponibilidad, usar todas las habitaciones
    SELECT COUNT(*)
    INTO cantidad_habitaciones_disponibles
    FROM HABITACION;

    -- Verificar que hay habitaciones para evitar división por cero
    IF cantidad_habitaciones_disponibles = 0 THEN
        RAISE EXCEPTION 'No hay habitaciones registradas en el sistema';
    END IF;

    -- Calcular porcentaje real de ocupación
    porcentaje_ocupacion := (cantidad_internaciones * 100.0) / cantidad_habitaciones_disponibles;

    -- Verificar si se superó el 75%
    IF porcentaje_ocupacion > umbral_ocupacion THEN
        INSERT INTO ocupacion_habitaciones (fecha,
                                            porcentaje_ocupacion,
                                            habitaciones_ocupadas,
                                            habitaciones_disponibles)
        VALUES (fecha_consulta,
                porcentaje_ocupacion,
                cantidad_internaciones,
                cantidad_habitaciones_disponibles);

        RAISE NOTICE 'ALERTA: Ocupación del %.2f%% en fecha % (umbral: %.1f%%)',
            porcentaje_ocupacion, fecha_consulta, umbral_ocupacion;
    END IF;

END;
$$ LANGUAGE plpgsql;

-- TODO: 3.b) se debe mantener automáticamente actualizada la cantidad de habitaciones disponibles en cada área a medida que se ocupan o desocupan camas de pacientes internados (considere que los valores actuales de dicho atributo son consistentes con los datos existentes en la base).

-- Resolucion Trigger:
-- Eventos Criticos:
-- habitacion:
-- insert: se agrega una habitacion al area
-- delete: se quita una habitacion al area
-- update: id_area, situacion

create or replace function fn_insert_delete_habitacion_area_cantidad_disponible() returns trigger as
$$
begin
    if (tg_op = 'INSERT') then
        update area
        set cant_habit_disponibles = ((select count(*)
                                       from habitacion
                                       where new.id_area = habitacion.id_area) + 1)
        where id_area = new.id_area;
    end if;

    if (tg_op = 'DELETE') then
        update area
        set cant_habit_disponibles = ((select count(*)
                                       from habitacion
                                       where old.id_area = habitacion.id_area) - 1)
        where id_area = old.id_area;
    end if;
end;
$$ language plpgsql;

create or replace trigger tg_insert_delete_habitacion_area_cantidad_disponible
    before insert or delete
    on habitacion
    for each row
    when ( situacion = 'L')
EXECUTE FUNCTION fn_insert_delete_habitacion_area_cantidad_disponible();

create or replace function fn_update_habitacion_area_cantidad_disponible() returns trigger as
$$
begin
    if (old.id_area <> new.id_area) then
        update area
        set cant_habit_disponibles = (select count(*)
                                      from habitacion
                                      where old.id_area = habitacion.id_area
                                        and habitacion.situacion = 'L')
        where old.id_area = id_area;

    end if;
    update area
    set cant_habit_disponibles = (select count(*)
                                  from habitacion
                                  where new.id_area = habitacion.id_area
                                    and habitacion.situacion = 'L')
    where new.id_area = id_area;
end;
$$ language plpgsql;

create or replace trigger tg_update_habitacion_area_cantidad_disponible
    after update of id_area, situacion
    on habitacion
    for each row
execute function fn_update_habitacion_area_cantidad_disponible();


/* TODO: Ejercicio 4

TODO: Implemente las siguientes vistas sobre el esquema dado, de manera que resulten automáticamente actualizables en PostgreSQL siempre que sea posible; en caso contrario, justifique la/s razón/es. En ambos casos, explique las posibilidades de actualización sobre cada vista.

    4.a) V1, con identificador y denominación de la/s área/s con la mayor cantidad de internaciones en el año actual.

    4.b) V2, con datos de todos los pacientes con obra social, junto con el número total de internaciones que han tenido en los últimos 5 años y el promedio de duración de las mismas (si no registra internaciones, estos valores deben ser 0).

    4.c) V3, con apellido y nombre de los médicos de especialidad cardiología asignados únicamente a internaciones realizadas en el área de cardiología.

*/

-- TODO: Resolucion: 4.a) V1, con identificador y denominación de la/s área/s con la mayor cantidad de internaciones en el año actual.

CREATE OR REPLACE VIEW V1 as
(
select id_area, denominacion
from area
where id_area in (select id_area
                  from internacion
                  group by id_area
                  order by count(*) desc
                  limit 1)
    );


-- TODO: Resolucion: 4.b) V2, con datos de todos los pacientes con obra social, junto con el número total de internaciones que han tenido en los últimos 5 años y el promedio de duración de las mismas (si no registra internaciones, estos valores deben ser 0).

CREATE OR REPLACE VIEW estadisticas_pacientes_con_obra_social as
select p.*, i.cantidad_internaciones, promedio_internaciones
from paciente p
         join (select id_paciente,
                      count(*)                                                  cantidad_internaciones,
                      AVG(COALESCE(fecha_salida, CURRENT_DATE) - fecha_ingreso) promedio_internaciones
               from internacion
               WHERE fecha_ingreso >= NOW() - INTERVAL '5 years'
               group by id_paciente) i on p.id_paciente = i.id_paciente
where obra_social is not null;


-- TODO: Resolucion: 4.c) V3, con apellido y nombre de los médicos de especialidad cardiología asignados únicamente a internaciones realizadas en el área de cardiología.
CREATE OR REPLACE VIEW medicos_asignados_solo_cardiologia as
select nombre, apellido
from medico m
join internacion on m.nro_matricula = internacion.matr_med_asignado and m.tipo_matricula = internacion.tipo_matr_med_asig
where especialidad = 'Cardiologia'
  and (m.nro_matricula, m.tipo_matricula) not in (select i.matr_med_asignado, i.tipo_matr_med_asig
                                                  from internacion i
                                                           join area a using (id_area)
                                                  where a.denominacion <> 'Cardiologia');