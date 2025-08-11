-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-02-27 16:44:42.412

-- tables
-- Table: ASIGNACION
CREATE TABLE ASIGNACION
(
    cod_plan         int     NOT NULL,
    idArea           char(2) NOT NULL,
    nroUsuario       int     NOT NULL,
    fecha_desde      date    NOT NULL,
    fecha_hasta      date    NULL,
    num_dispositivos int     NOT NULL,
    CONSTRAINT ASIGNACION_pk PRIMARY KEY (cod_plan, idArea, nroUsuario)
);

-- Table: GESTION
CREATE TABLE GESTION
(
    usuario     int      NOT NULL,
    nro_gestion int      NOT NULL,
    motivo      char(80) NOT NULL,
    idArea      char(2)  NULL,
    cod_plan    int      NULL,
    fecha       date     NOT NULL,
    CONSTRAINT GESTION_pk PRIMARY KEY (usuario, nro_gestion)
);

-- Table: PLAN
CREATE TABLE PLAN
(
    idArea      char(2)     NOT NULL,
    cod_plan    int         NOT NULL,
    nombre      varchar(50) NOT NULL,
    anio_inicio int         NOT NULL,
    tipo_plan   char(1)     NOT NULL,
    CONSTRAINT PLAN_pk PRIMARY KEY (idArea, cod_plan)
);

-- Table: PLAN_PROMO
CREATE TABLE PLAN_PROMO
(
    idArea    char(2)       NOT NULL,
    cod_plan  int           NOT NULL,
    condicion varchar(80)   NOT NULL,
    descuento decimal(5, 2) NOT NULL,
    CONSTRAINT PLAN_PROMO_pk PRIMARY KEY (idArea, cod_plan)
);

-- Table: PLAN_TRAD
CREATE TABLE PLAN_TRAD
(
    idArea         char(2)     NOT NULL,
    cod_plan       int         NOT NULL,
    caracteristica varchar(80) NOT NULL,
    CONSTRAINT PLAN_TRAD_pk PRIMARY KEY (idArea, cod_plan)
);

-- Table: USUARIO
CREATE TABLE USUARIO
(
    nroUsuario   int         NOT NULL,
    apell_nombre varchar(50) NOT NULL,
    ciudad       varchar(20) NOT NULL,
    fecha_alta   date        NOT NULL,
    CONSTRAINT USUARIO_pk PRIMARY KEY (nroUsuario)
);

-- foreign keys
-- Reference: FK_ASIGNACION_PLAN (table: ASIGNACION)
ALTER TABLE ASIGNACION
    ADD CONSTRAINT FK_ASIGNACION_PLAN
        FOREIGN KEY (idArea, cod_plan)
            REFERENCES PLAN (idArea, cod_plan)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: FK_ASIGNACION_USUARIO (table: ASIGNACION)
ALTER TABLE ASIGNACION
    ADD CONSTRAINT FK_ASIGNACION_USUARIO
        FOREIGN KEY (nroUsuario)
            REFERENCES USUARIO (nroUsuario)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: FK_GESTION_PLAN (table: GESTION)
ALTER TABLE GESTION
    ADD CONSTRAINT FK_GESTION_PLAN
        FOREIGN KEY (idArea, cod_plan)
            REFERENCES PLAN (idArea, cod_plan)
            ON DELETE SET NULL
            ON UPDATE SET NULL
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: FK_GESTION_USUARIO (table: GESTION)
ALTER TABLE GESTION
    ADD CONSTRAINT FK_GESTION_USUARIO
        FOREIGN KEY (usuario)
            REFERENCES USUARIO (nroUsuario)
            ON DELETE CASCADE
            ON UPDATE CASCADE
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: FK_PLANPROMO_PLAN (table: PLAN_PROMO)
ALTER TABLE PLAN_PROMO
    ADD CONSTRAINT FK_PLANPROMO_PLAN
        FOREIGN KEY (idArea, cod_plan)
            REFERENCES PLAN (idArea, cod_plan)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- Reference: FK_PLANTRAD_PLAN (table: PLAN_TRAD)
ALTER TABLE PLAN_TRAD
    ADD CONSTRAINT FK_PLANTRAD_PLAN
        FOREIGN KEY (idArea, cod_plan)
            REFERENCES PLAN (idArea, cod_plan)
            NOT DEFERRABLE
                INITIALLY IMMEDIATE
;

-- End of file.