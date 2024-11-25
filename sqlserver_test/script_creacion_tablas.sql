-- Creacion de la base de datos
CREATE DATABASE EMPRESA;

USE EMPRESA;

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
    NOMBRE VARCHAR(100) NOT NULL,            
    APELLIDO VARCHAR(100) NOT NULL,           
    CEDULA VARCHAR(20) UNIQUE NOT NULL,     
    FIRMA VARBINARY(MAX) NULL,               
    
    CARGO_ID INT FOREIGN KEY REFERENCES CARGO(ID), 
    AREA_ID INT FOREIGN KEY REFERENCES AREA(ID)  
);