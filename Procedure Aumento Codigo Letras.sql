CREATE DATABASE supermercado;

CREATE TABLE productos(
	codigo char(3),
	nombre varchar(50),
	marca varchar(50),
	cantidad int
);

DELIMITER //

CREATE PROCEDURE generarCodigo(
    in_nombre VARCHAR(50),
    in_marca VARCHAR(50),
    in_cantidad INT
)
BEGIN
    DECLARE ultimoCodigo CHAR(3);
    DECLARE nuevaPosicion INT;
    DECLARE nuevaLetra CHAR(1);
    DECLARE nuevoCodigo CHAR(3);

    -- Obtener el último código de la tabla
    SELECT MAX(codigo) INTO ultimoCodigo FROM productos;

    -- Verificar si hay registros en la tabla
    IF ultimoCodigo IS NULL THEN
        SET nuevoCodigo = 'AAA';
    ELSE
        -- Obtener la posición y letra de la tercera letra del código
        SET nuevaPosicion = (ASCII(SUBSTRING(ultimoCodigo, 3, 1)) - 65 + 1) % 26;
        SET nuevaLetra = CHAR(65 + nuevaPosicion);

        -- Incrementar la posición en la tercera letra del código
        SET nuevaPosicion = (nuevaPosicion + 1) % 26;

        -- Construir el nuevo código
        SET nuevoCodigo = CONCAT(
            SUBSTRING(ultimoCodigo, 1, 2),
            CHAR(65 + (ASCII(SUBSTRING(ultimoCodigo, 2, 1)) - 65 + FLOOR(nuevaPosicion / 26) + 1) % 26),
            nuevaLetra
        );
    END IF;

    -- Insertar el nuevo código y los demás datos en la tabla
    INSERT INTO productos (codigo, nombre, marca, cantidad)
    VALUES (nuevoCodigo, in_nombre, in_marca, in_cantidad);
END //

DELIMITER ;


CALL generarCodigo('Tapa de Empanada','Marolio',5);
CALL generarCodigo('Tapa de Empanada','La Salteña',5);