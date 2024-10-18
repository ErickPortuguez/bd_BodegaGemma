
CREATE USER BodegaGemma IDENTIFIED BY  gemma123
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA 20M ON USERS;

ALTER SESSION SET "_ORACLE_SCRIPT" = true;


GRANT CREATE SESSION TO BodegaGemma ;
GRANT CREATE TABLE TO BodegaGemma;
GRANT CREATE VIEW TO BodegaGemma;
GRANT CREATE PROCEDURE TO BodegaGemma;
GRANT CREATE TRIGGER TO BodegaGemma;
GRANT CREATE SEQUENCE TO BodegaGemma;
GRANT CREATE SYNONYM TO BodegaGemma;
GRANT UNLIMITED TABLESPACE TO BodegaGemma;