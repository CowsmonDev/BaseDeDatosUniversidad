-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-11-23 03:09:32.821

-- tables
-- Table: Agricultor
CREATE TABLE Agricultor (
                            ID_Agricultor serial  NOT NULL,
                            Nombre varchar(100)  NOT NULL,
                            Email varchar(100)  NOT NULL,
                            Telefono varchar(15)  NULL,
                            Fecha_registro date  NULL,
                            CONSTRAINT Agricultores_pk PRIMARY KEY (ID_Agricultor)
);

-- Table: Cosecha
CREATE TABLE Cosecha (
                         ID_Cultivo int  NOT NULL,
                         Nro_cosecha int  NOT NULL,
                         Fecha_Cosecha date  NOT NULL,
                         Cantidad_cosechada decimal(10,2)  NOT NULL,
                         Precio_estimado decimal(10,2)  NOT NULL,
                         CONSTRAINT Cosechas_pk PRIMARY KEY (ID_Cultivo,Nro_cosecha)
);

-- Table: Cultivo
CREATE TABLE Cultivo (
                         ID_Cultivo serial  NOT NULL,
                         Nombre_cultivo varchar(100)  NOT NULL,
                         Tipo varchar(50)  NOT NULL,
                         Fecha_siembra date  NOT NULL,
                         ID_agricultor int  NULL,
                         CONSTRAINT Cultivos_pk PRIMARY KEY (ID_Cultivo)
);

-- Table: Inventario
CREATE TABLE Inventario (
                            ID_Cultivo int  NOT NULL,
                            ID_Proveedor int  NOT NULL,
                            Cantidad_recibida decimal(10,2)  NOT NULL,
                            Fecha_recepcion date  NOT NULL,
                            CONSTRAINT Inventario_pk PRIMARY KEY (ID_Cultivo,ID_Proveedor)
);

-- Table: Proveedor
CREATE TABLE Proveedor (
                           ID_Proveedor serial  NOT NULL,
                           Nombre varchar(100)  NOT NULL,
                           Rubro varchar(100)  NOT NULL,
                           Telefono varchar(15)  NULL,
                           Email varchar(100)  NULL,
                           CONSTRAINT Proveedores_pk PRIMARY KEY (ID_Proveedor)
);

-- Table: Venta
CREATE TABLE Venta (
                       ID_Cultivo int  NOT NULL,
                       Nro_cosecha int  NOT NULL,
                       Fecha_Venta date  NOT NULL,
                       Cantidad_vendida decimal(10,2)  NOT NULL,
                       Precio_unitario decimal(10,2)  NOT NULL,
                       CONSTRAINT Ventas_pk PRIMARY KEY (Fecha_Venta,Nro_cosecha,ID_Cultivo)
);

-- foreign keys
-- Reference: FK_cosecha_cultivo (table: Cosecha)
ALTER TABLE Cosecha ADD CONSTRAINT FK_cosecha_cultivo
    FOREIGN KEY (ID_Cultivo)
        REFERENCES Cultivo (ID_Cultivo)
        ON UPDATE  CASCADE
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_cultivo_agricultor (table: Cultivo)
ALTER TABLE Cultivo ADD CONSTRAINT FK_cultivo_agricultor
    FOREIGN KEY (ID_agricultor)
        REFERENCES Agricultor (ID_Agricultor)
        ON DELETE  SET NULL
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_inventario_cultivo (table: Inventario)
ALTER TABLE Inventario ADD CONSTRAINT FK_inventario_cultivo
    FOREIGN KEY (ID_Cultivo)
        REFERENCES Cultivo (ID_Cultivo)
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_inventario_proveedor (table: Inventario)
ALTER TABLE Inventario ADD CONSTRAINT FK_inventario_proveedor
    FOREIGN KEY (ID_Proveedor)
        REFERENCES Proveedor (ID_Proveedor)
        ON UPDATE  CASCADE
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- Reference: FK_venta_cosecha (table: Venta)
ALTER TABLE Venta ADD CONSTRAINT FK_venta_cosecha
    FOREIGN KEY (ID_Cultivo, Nro_cosecha)
        REFERENCES Cosecha (ID_Cultivo, Nro_cosecha)
        ON UPDATE  CASCADE
        NOT DEFERRABLE
            INITIALLY IMMEDIATE
;

-- End of file.