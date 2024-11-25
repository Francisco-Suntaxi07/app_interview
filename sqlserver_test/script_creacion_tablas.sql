-- Creacion de la base de datos
CREATE DATABASE interview_db;

USE interview_db;

-- Crear las tablas
CREATE TABLE CARGO (
    ID INT IDENTITY(1,1) PRIMARY KEY,        
    NOMBRE VARCHAR(100) NOT NULL             
);

CREATE TABLE AREA (
    ID INT IDENTITY(1,1) PRIMARY KEY,        
    NOMBRE VARCHAR(100) NOT NULL             
);

CREATE TABLE EMPLEADO (
    ID INT IDENTITY(1,1) PRIMARY KEY,       
    NOMBRE VARCHAR(64) NOT NULL,            
    APELLIDO VARCHAR(64) NOT NULL,           
    CEDULA VARCHAR(11) UNIQUE NOT NULL,     
    FIRMA VARBINARY(MAX) NULL,               
);

GO

-- Relaciones
CREATE TABLE EMPLEADO_CARGO (
    EMPLEADO_ID INT,
    CARGO_ID INT,
    PRIMARY KEY (EMPLEADO_ID, CARGO_ID),
    FOREIGN KEY (EMPLEADO_ID) REFERENCES EMPLEADO(ID),
    FOREIGN KEY (CARGO_ID) REFERENCES CARGO(ID)
);

ALTER TABLE EMPLEADO
ADD AREA_ID INT;

ALTER TABLE EMPLEADO
ADD CONSTRAINT FK_EMPLEADO_AREA FOREIGN KEY (AREA_ID) REFERENCES AREA(ID);
