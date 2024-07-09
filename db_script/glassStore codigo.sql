use glass_store_v2;

-- ---------------------------------------------------GENERALES DE LOS USUARIOS
-- login
DELIMITER //
CREATE PROCEDURE AuthenticateUser(
    IN p_username VARCHAR(70),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE v_id_usuario INT;
    DECLARE v_auth_success BOOLEAN;

    SET v_auth_success = FALSE;

    -- Validar las credenciales del usuario
    SELECT id_usuario INTO v_id_usuario
    FROM USUARIOS
    WHERE usuario = p_username AND contrasena = p_password;

    -- Verificar si se encontró un usuario
    IF v_id_usuario IS NOT NULL THEN
        SET v_auth_success = TRUE;
        SET @session_user_id = v_id_usuario; -- Establecer variable de sesión
    END IF;

    -- Devolver resultado de la autenticación
    IF v_auth_success THEN
        SELECT 'Autenticación exitosa' AS mensaje, @session_user_id AS id_usuario;
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Autenticación fallida. Usuario o contraseña incorrectos.';
    END IF;
END //
DELIMITER ;
call AuthenticateUser ('deleon@outlook.com','test');
call AuthenticateUser ('mateogl@gmail.com','test');
SELECT @session_user_id;

-- ---------------------------------------------------ÚNICAMENTE DE LOS CLIENTES

-- desactivar cuenta
-- si se desactiva la cuenta se quedan innacesibles sus cotizaciones y cotizaciones espeficias no enlazadas a ventas, los favoritos, las notificaciones
-- se conserva para que pueda checar el administrador sus ventas asociadas, asi como lo que se le vendio, el historial de abonos, las promos
DELIMITER //
CREATE PROCEDURE DesactivarCuenta()
BEGIN
    -- Validar que la variable de sesión del usuario esté definida
    IF @session_user_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay sesión de usuario válida. Autentíquese primero.';
    END IF;

    -- Desactivar la cuenta del usuario
    UPDATE USUARIOS
    SET status = 'inactivo'
    WHERE id_usuario = @session_user_id;
    -- Devolver mensaje de éxito
    SELECT 'Cuenta desactivada correctamente' AS mensaje;
END //
DELIMITER ;

-- Ejemplo de cómo establecer @session_user_id
CALL AuthenticateUser('deleon@outlook.com', 'test'); -- Esto establece @session_user_id si la autenticación es exitosa
-- Luego puedes desactivar la cuenta usando
CALL DesactivarCuenta();

-- consultar favoritos por usuario
DELIMITER //
CREATE PROCEDURE ConsultarFavoritos()
BEGIN
    IF @session_user_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se ha iniciado sesión';
    ELSE
        SELECT PRODUCTOS.nombre, PRODUCTOS.descripcion, PRODUCTOS.precio
        FROM FAVORITOS INNER JOIN PRODUCTOS ON FAVORITOS.producto = PRODUCTOS.id_producto
        WHERE FAVORITOS.usuario = @session_user_id;
    END IF;
END //
DELIMITER ;

call ConsultarFavoritos;

-- guardar en favoritos una vez le des al corazón
DELIMITER //
CREATE PROCEDURE InsertarFavorito(
    IN p_id_producto INT
)
BEGIN
    DECLARE v_id_favorito INT;

    -- Verificar si @session_user_id tiene un valor
    IF @session_user_id IS NULL THEN
        SELECT 'No se ha iniciado sesión' AS mensaje;
    ELSE
        -- Verificar si ya existe un favorito para este usuario y producto
        SELECT id_favorito INTO v_id_favorito
        FROM FAVORITOS
        WHERE usuario = @session_user_id AND producto = p_id_producto;

        IF v_id_favorito IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Este producto ya estaba en tus favoritos';
        ELSE
            -- Insertar el nuevo favorito
            INSERT INTO FAVORITOS (usuario, producto)
            VALUES (@session_user_id, p_id_producto);

            SELECT 'Registro insertado correctamente' AS mensaje;
        END IF;
    END IF;
END //
DELIMITER ;

CALL InsertarFavorito((SELECT id_producto FROM PRODUCTOS WHERE nombre = 'Persiana Moderna'));

-- ---------------------------------------------------MOSTRAR CATÁLOGO
-- hacer una vista de cada tipo de producto
CREATE OR REPLACE VIEW vista_herrerias AS
SELECT productos.nombre, productos.descripcion, productos.precio
FROM productos
RIGHT JOIN herrerias
ON productos.id_producto = herrerias.producto;

CREATE OR REPLACE VIEW vista_vidrios AS
SELECT productos.nombre, productos.descripcion, productos.precio
FROM productos
RIGHT JOIN vidrios
ON productos.id_producto = vidrios.producto;

CREATE OR REPLACE VIEW vista_persianas AS
SELECT productos.nombre, productos.descripcion, productos.precio
FROM productos
RIGHT JOIN persianas
ON productos.id_producto = persianas.producto;

CREATE OR REPLACE VIEW vista_tapices AS
SELECT productos.nombre, productos.descripcion, productos.precio
FROM productos
RIGHT JOIN tapices
ON productos.id_producto = tapices.producto;

select * from vista_tapices where tapices.producto = 1;

-- filtrar productos por precio
DELIMITER //
CREATE PROCEDURE filtro_por_precio(
    IN var_tabla VARCHAR(50),
    IN v1 DECIMAL(10,2),
    IN v2 DECIMAL(10,2)
)
BEGIN
    -- Almacenar la consulta en una variable
    SET @var_filtro = CONCAT('SELECT * FROM vista_', var_tabla, ' WHERE vista_', var_tabla, '.precio BETWEEN ', v1, ' AND ', v2);

    -- Preparar la consulta
    PREPARE stmt_filtro FROM @var_filtro;
    
    -- Ejecutar la consulta
    EXECUTE stmt_filtro;
    
    -- Liberar el statement
    DEALLOCATE PREPARE stmt_filtro;
END//
DELIMITER ;

CALL filtro_por_precio('herrerias', 0, 500);
CALL filtro_por_precio('vidrios', 0, 500);
CALL filtro_por_precio('persianas', 0, 5000);
CALL filtro_por_precio('tapices', 0, 500);

-- ---------------------------------------------------CARRITO/COTIZACIONES

/* armar carrito */

-- sacar cotizaciones sin ventas (esto también puede servir para que, recien inicien sesion, su carrito se restaure) 
DELIMITER //
create procedure CotizacionesSinVentaPorUsuario()
begin
SELECT cotizaciones.id_cotizacion 
	FROM ventas right JOIN cotizaciones ON cotizaciones.id_cotizacion = VENTAS.cotizacion
    WHERE VENTAS.cotizacion IS NULL AND cotizaciones.usuario = @session_user_id
    LIMIT 1;
END //
DELIMITER ;
call CotizacionesSinVentaPorUsuario;

/*asignar un carrito
debe de ejecutarse al momento de iniciar sesion para que siempre haya carrito*/

DELIMITER //
CREATE PROCEDURE HandleCotizacion(
)
BEGIN
    DECLARE v_cotizacion_id INT;
    DECLARE v_no_venta INT;

    -- Si se encontró una cotización no enlazada a venta
    IF v_cotizacion_id IS NOT NULL THEN
        -- Actualizar la fecha de la cotización encontrada
        UPDATE COTIZACIONES
        SET fecha = CURRENT_TIMESTAMP
        WHERE id_cotizacion = v_cotizacion_id;
        
        -- Guardar el id de la cotización en una variable global
        SET @current_cotizacion_id = v_cotizacion_id;

    ELSE
        -- Crear una nueva cotización
        INSERT INTO COTIZACIONES (usuario, fecha, monto)
        VALUES (@session_user_id, CURRENT_TIMESTAMP, 0);

        -- Obtener el ID de la nueva cotización creada
        SET @current_cotizacion_id = LAST_INSERT_ID();
    END IF;
END //
DELIMITER ;

CALL HandleCotizacion();
select * from cotizaciones;

/*echar un producto a un carro*/


DELIMITER //

CREATE PROCEDURE asignarACotizActual(
    IN var_tabla VARCHAR(50),
    IN var_id INT
)
BEGIN
    IF var_tabla = 'tapices' THEN
        UPDATE cotizaciones_tapices
        SET cotizacion = @current_cotizacion_id
        WHERE activo = TRUE AND id_cotizacion = var_id;
	elseif var_tabla = 'persianas' THEN
        UPDATE cotizaciones_persianas
        SET cotizacion = @current_cotizacion_id
        WHERE activo = TRUE AND id_cotizacion = var_id;
elseif var_tabla = 'vidrios' THEN
        UPDATE cotizaciones_vidrios
        SET cotizacion = @current_cotizacion_id
        WHERE activo = TRUE AND id_cotizacion = var_id;
	elseif var_tabla = 'herrerias' THEN
        UPDATE cotizaciones_herrerias
        SET cotizacion = @current_cotizacion_id
        WHERE activo = TRUE AND id_cotizacion = var_id;

    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER actualizarCotiz
BEFORE UPDATE ON cotizaciones_tapices
FOR EACH ROW
BEGIN
    CALL asignarACotizActual('tapices', 1);
END //

DELIMITER ;

update cotizaciones_tapices
set cantidad = true
where id_cotizacion = 1; 

DELIMITER //

CREATE TRIGGER asignacionCotiz
BEFORE INSERT ON cotizaciones_tapices
FOR EACH ROW
BEGIN
    CALL asignarACotizActual('tapices');
END //

DELIMITER ;

/*sacar del carrito*/

CREATE PROCEDURE cambiarEstadoInactivo(
    IN var_id_cotizacion INT
)
BEGIN
    UPDATE COTIZACIONES_HERRERIAS
    SET activo = FALSE
    WHERE id_cotizacion = var_id_cotizacion;
END;

/* mostrar todas las cotizaciones activas */
DELIMITER //
CREATE PROCEDURE mostrarCotizacionesActivas()
BEGIN
    -- Crear tabla temporal
    CREATE TEMPORARY TABLE IF NOT EXISTS TempCotizaciones (
        id INT AUTO_INCREMENT PRIMARY KEY,
        tipo VARCHAR(50),
        id_cotizacion INT,
        cotizacion int,
        alto DECIMAL(10,2),
        largo DECIMAL(10,2),
        cantidad INT
    );

    -- Insertar datos de COTIZACIONES_HERRERIAS activas
    INSERT INTO TempCotizaciones (tipo, id_cotizacion, cotizacion, alto, largo, cantidad)
    SELECT 'herreria', id_cotizacion, cotizacion, alto, largo, cantidad
    FROM COTIZACIONES_HERRERIAS
    WHERE activo = TRUE AND cotizacion = @current_cotizacion_id;

    -- Insertar datos de COTIZACIONES_vidrios activas
    INSERT INTO TempCotizaciones (tipo, id_cotizacion, cotizacion, alto, largo, cantidad)
    SELECT 'vidrio', id_cotizacion, cotizacion, alto, largo, cantidad
    FROM COTIZACIONES_vidrios
    WHERE activo = TRUE AND cotizacion = @current_cotizacion_id;

    -- Insertar datos de COTIZACIONES_persianas activas
    INSERT INTO TempCotizaciones (tipo, id_cotizacion, cotizacion, alto, largo, cantidad)
    SELECT 'persiana', id_cotizacion, cotizacion, alto, largo, cantidad
    FROM COTIZACIONES_persianas
    WHERE activo = TRUE AND cotizacion = @current_cotizacion_id;

    -- Insertar datos de COTIZACIONES_tapices activas
    INSERT INTO TempCotizaciones (tipo, id_cotizacion, cotizacion, alto, largo, cantidad)
    SELECT 'tapiz', id_cotizacion, cotizacion, alto, largo, cantidad
    FROM COTIZACIONES_tapices
    WHERE activo = TRUE AND cotizacion = @current_cotizacion_id;
END //
DELIMITER ;

call mostrarCotizacionesActivas();

select *
from TempCotizaciones
inner join cotizaciones on TempCotizaciones.cotizacion = cotizaciones.id_cotizacion
inner join usuarios on cotizaciones.usuario = usuarios.id_usuario
where id_usuario = @session_user_id;

-- Configura las variables
SET @current_cotizacion_id = 25; -- Reemplaza con el valor de cotización correspondiente
SET @session_user_id = 4; -- Reemplaza con el valor de usuario correspondiente

-- Llama al procedimiento almacenado
CALL mostrarCotizacionesActivas();

-- Verifica los datos en la tabla temporal
SELECT *
FROM TempCotizaciones;

-- Realiza la consulta completa
SELECT *
FROM TempCotizaciones
INNER JOIN cotizaciones ON TempCotizaciones.cotizacion = cotizaciones.id_cotizacion
INNER JOIN usuarios ON cotizaciones.usuario = usuarios.id_usuario
WHERE id_usuario = @session_user_id;

/*mostar cotizaciones activas del usuario*/
DELIMITER //

CREATE PROCEDURE mostrarCotizacionesActivasPorUsuario(IN session_user_id INT)
BEGIN
    -- Crear tabla temporal para almacenar resultados
    CREATE TEMPORARY TABLE IF NOT EXISTS TempCotizacionesActivasPorUsuario (
        id INT AUTO_INCREMENT PRIMARY KEY,
        tipo VARCHAR(50),
        id_cotizacion INT,
        cotizacion INT,
        alto DECIMAL(10,2),
        largo DECIMAL(10,2),
        cantidad INT
    );

    -- Insertar cotizaciones de herrería activas por usuario
    INSERT INTO TempCotizacionesActivasPorUsuario (tipo, id_cotizacion, cotizacion, alto, largo, cantidad)
    SELECT 'herreria', CH.id_cotizacion, CH.cotizacion, CH.alto, CH.largo, CH.cantidad
    FROM COTIZACIONES_HERRERIAS CH
    INNER JOIN COTIZACIONES C ON CH.id_cotizacion = C.id_cotizacion
    WHERE CH.activo = TRUE AND C.usuario = session_user_id;

    -- Insertar cotizaciones de vidrio activas por usuario
    INSERT INTO TempCotizacionesActivasPorUsuario (tipo, id_cotizacion, cotizacion, alto, largo, cantidad)
    SELECT 'vidrio', CV.id_cotizacion, CV.cotizacion, CV.alto, CV.largo, CV.cantidad
    FROM COTIZACIONES_VIDRIOS CV
    INNER JOIN COTIZACIONES C ON CV.id_cotizacion = C.id_cotizacion
    WHERE CV.activo = TRUE AND C.usuario = session_user_id;

    -- Insertar cotizaciones de persiana activas por usuario
    INSERT INTO TempCotizacionesActivasPorUsuario (tipo, id_cotizacion, cotizacion, alto, largo, cantidad)
    SELECT 'persiana', CP.id_cotizacion, CP.cotizacion, CP.alto, CP.largo, CP.cantidad
    FROM COTIZACIONES_PERSIANAS CP
    INNER JOIN COTIZACIONES C ON CP.id_cotizacion = C.id_cotizacion
    WHERE CP.activo = TRUE AND C.usuario = session_user_id;

    -- Insertar cotizaciones de tapiz activas por usuario
    INSERT INTO TempCotizacionesActivasPorUsuario (tipo, id_cotizacion, cotizacion, alto, largo, cantidad)
    SELECT 'tapiz', CT.id_cotizacion, CT.cotizacion, CT.alto, CT.largo, CT.cantidad
    FROM COTIZACIONES_TAPICES CT
    INNER JOIN COTIZACIONES C ON CT.id_cotizacion = C.id_cotizacion
    WHERE CT.activo = TRUE AND C.usuario = session_user_id;

    -- Seleccionar datos completos de las cotizaciones activas del usuario
    SELECT *
    FROM TempCotizacionesActivasPorUsuario;
END //
DELIMITER ;
CALL mostrarCotizacionesActivasPorUsuario(@session_user_id);
SET @session_user_id = 4;
SELECT * FROM TempCotizacionesActivasPorUsuario;

INSERT INTO COTIZACIONES_VIDRIOS (cotizacion, vidrio, alto, largo, grosor, cantidad, activo)
VALUES (25, 1, 1.5, 2.0,1, 5, TRUE),
    (25, 2, 2.0, 3.0,1, 3, TRUE),
    (25, 3, 1.0, 1.5,1, 2, TRUE);

/*ejecutar cuando salgas de la vista de las cotizaciones*/
-- Eliminar la tabla temporal al finalizar
DROP TEMPORARY TABLE IF EXISTS TempCotizaciones;

/*ejecutar cuando salgas de la vista de las cotizaciones*/
-- Eliminar la tabla temporal al finalizar
DROP TEMPORARY TABLE IF EXISTS TempCotizaciones;


/* monto carrito
calculos de todas las cotizaciones activas
*/

-- trigger para ir actualizando el monto de la cotizacion
-- son dos trigger por cada tipo de cotizacion ya sea persina, herreria, tapices y vidrios , 
-- un insert y un update por cada uno y tmabuen tien que tener si la cotizacion esta activa o inactiva 

/*TRIGGER COTIZACIONES_HERRERIAS 
INSERT*/
DELIMITER //

CREATE TRIGGER insertar_cotizacion_herreria_trigger
AFTER INSERT ON COTIZACIONES_HERRERIAS
FOR EACH ROW
BEGIN
    DECLARE monto_herreria DECIMAL(10, 2);
    SELECT SUM(alto * largo * cantidad) INTO monto_herreria
    FROM COTIZACIONES_HERRERIAS
    WHERE cotizacion = NEW.cotizacion AND activo = TRUE;
    
    IF monto_herreria IS NOT NULL THEN
        UPDATE COTIZACIONES SET monto = monto_herreria WHERE id_cotizacion = NEW.cotizacion;
    END IF;
END //

DELIMITER ;
-- Insertar una nueva cotización de herrería
INSERT INTO COTIZACIONES_HERRERIAS (cotizacion, herreria, alto, largo, cantidad)
VALUES (1, 1, 1.20, 1.00, 1);
-- Actualizar una cotización de herrería (por ejemplo, cambiar la cantidad)
UPDATE COTIZACIONES_HERRERIAS
SET cantidad = 2
WHERE id_cotizacion = 1;
-- Verificar el monto actualizado en la tabla COTIZACIONES para la cotización específica
SELECT id_cotizacion, monto
FROM COTIZACIONES
WHERE id_cotizacion = 1;
/*TRIGGER COTIZACIONES_HERRERIAS 
UPDATE*/
DELIMITER //

CREATE TRIGGER actualizar_cotizacion_herreria_trigger
AFTER UPDATE ON COTIZACIONES_HERRERIAS
FOR EACH ROW
BEGIN
    DECLARE monto_herreria DECIMAL(10, 2);
    SELECT SUM(alto * largo * cantidad) INTO monto_herreria
    FROM COTIZACIONES_HERRERIAS
    WHERE cotizacion = NEW.cotizacion AND activo = TRUE;
    
    IF monto_herreria IS NOT NULL THEN
        UPDATE COTIZACIONES SET monto = monto_herreria WHERE id_cotizacion = NEW.cotizacion;
    END IF;
END //
DELIMITER ;
/*TRIGGER COTIZACIONES_PERSIANAS 
INSERT*/
DELIMITER //

CREATE TRIGGER insertar_cotizacion_persiana_trigger
AFTER INSERT ON COTIZACIONES_PERSIANAS
FOR EACH ROW
BEGIN
    DECLARE monto_persiana DECIMAL(10, 2);
    SELECT SUM(alto * largo * cantidad) INTO monto_persiana
    FROM COTIZACIONES_PERSIANAS
    WHERE cotizacion = NEW.cotizacion AND activo = TRUE;
    
    IF monto_persiana IS NOT NULL THEN
        UPDATE COTIZACIONES SET monto = monto_persiana WHERE id_cotizacion = NEW.cotizacion;
    END IF;
END //

DELIMITER ;

/*TRIGGER COTIZACIONES_PERSIANAS 
UPDATE*/
DELIMITER //

CREATE TRIGGER actualizar_cotizacion_persiana_trigger
AFTER UPDATE ON COTIZACIONES_PERSIANAS
FOR EACH ROW
BEGIN
    DECLARE monto_persiana DECIMAL(10, 2);
    SELECT SUM(alto * largo * cantidad) INTO monto_persiana
    FROM COTIZACIONES_PERSIANAS
    WHERE cotizacion = NEW.cotizacion AND activo = TRUE;
    
    IF monto_persiana IS NOT NULL THEN
        UPDATE COTIZACIONES SET monto = monto_persiana WHERE id_cotizacion = NEW.cotizacion;
    END IF;
END //

DELIMITER ;

/*TRIGGER COTIZACIONES_TAPICES 
INSERT*/
DELIMITER //

CREATE TRIGGER insertar_cotizacion_tapiz_trigger
AFTER INSERT ON COTIZACIONES_TAPICES
FOR EACH ROW
BEGIN
    DECLARE monto_tapiz DECIMAL(10, 2);
    SELECT SUM(alto * largo * cantidad) INTO monto_tapiz
    FROM COTIZACIONES_TAPICES
    WHERE cotizacion = NEW.cotizacion AND activo = TRUE;
    
    IF monto_tapiz IS NOT NULL THEN
        UPDATE COTIZACIONES SET monto = monto_tapiz WHERE id_cotizacion = NEW.cotizacion;
    END IF;
END //

DELIMITER ;
/*TRIGGER COTIZACIONES_TAPICES 
UPDATE*/
DELIMITER //

CREATE TRIGGER actualizar_cotizacion_tapiz_trigger
AFTER UPDATE ON COTIZACIONES_TAPICES
FOR EACH ROW
BEGIN
    DECLARE monto_tapiz DECIMAL(10, 2);
    SELECT SUM(alto * largo * cantidad) INTO monto_tapiz
    FROM COTIZACIONES_TAPICES
    WHERE cotizacion = NEW.cotizacion AND activo = TRUE;
    
    IF monto_tapiz IS NOT NULL THEN
        UPDATE COTIZACIONES SET monto = monto_tapiz WHERE id_cotizacion = NEW.cotizacion;
    END IF;
END //

DELIMITER ;

/*TRIGGER COTIZACIONES_VIDRIOS
INSERT*/
DELIMITER //

CREATE TRIGGER insertar_cotizacion_vidrio_trigger
AFTER INSERT ON COTIZACIONES_VIDRIOS
FOR EACH ROW
BEGIN
    DECLARE monto_vidrio DECIMAL(10, 2);
    SELECT SUM(alto * largo * grosor * cantidad) INTO monto_vidrio
    FROM COTIZACIONES_VIDRIOS
    WHERE cotizacion = NEW.cotizacion AND activo = TRUE;
    
    IF monto_vidrio IS NOT NULL THEN
        UPDATE COTIZACIONES SET monto = monto_vidrio WHERE id_cotizacion = NEW.cotizacion;
    END IF;
END //

DELIMITER ;

/*TRIGGER COTIZACIONES_VIDRIOS
UPDATE*/
DELIMITER //

CREATE TRIGGER actualizar_cotizacion_vidrio_trigger
AFTER UPDATE ON COTIZACIONES_VIDRIOS
FOR EACH ROW
BEGIN
    DECLARE monto_vidrio DECIMAL(10, 2);
    SELECT SUM(alto * largo * grosor * cantidad) INTO monto_vidrio
    FROM COTIZACIONES_VIDRIOS
    WHERE cotizacion = NEW.cotizacion AND activo = TRUE;
    
    IF monto_vidrio IS NOT NULL THEN
        UPDATE COTIZACIONES SET monto = monto_vidrio WHERE id_cotizacion = NEW.cotizacion;
    END IF;
END //

DELIMITER ;

-- ---------------------------------------------------CALCULAR PRECIOS COTIZACIONES
-- NOTA: VERIFICAR CON EL EXCEL COTIZADOR ACTUAL DE LA CLIENTA PARA AJUSTAR CÁLCULOS
-- cotizacion_especifica imprimir los calculos en frontend pero no guardar el monto total todavía

/* subtotal
no se ocupa estar logeado */

DELIMITER //
CREATE PROCEDURE calcular_subtotal(
    IN var_tabla VARCHAR(50),
    in var_id varchar(15)
)
BEGIN
    SET @sql = CONCAT('
        SELECT 
          PRODUCTOS.nombre, 
          PRODUCTOS.descripcion, 
          PRODUCTOS.precio, 
          COTIZACIONES_',var_tabla, '.alto, 
          COTIZACIONES_',var_tabla, '.largo, 
          COTIZACIONES_',var_tabla, '.cantidad, 
          PRODUCTOS.precio * COTIZACIONES_',var_tabla, '.alto * COTIZACIONES_',var_tabla, '.largo * COTIZACIONES_',var_tabla, '.cantidad AS subtotal
        FROM 
          PRODUCTOS 
          INNER JOIN COTIZACIONES_', var_tabla, ' ON PRODUCTOS.id_producto = COTIZACIONES_', var_tabla, '.',var_id,'
          INNER JOIN VIDRIOS ON COTIZACIONES_', var_tabla, '.id_cotizacion =' , var_tabla,'.id_',var_id,';
    ');

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//
DELIMITER ;

CALL calcular_subtotal('vidrios', 'vidrio');
  
  -- guardar el resultado del subtotal
DELIMITER //
CREATE PROCEDURE guardar_subtotal(
    IN var_tabla VARCHAR(50),
    in var_id varchar(15)
)
BEGIN
    SET @sql = CONCAT('
        UPDATE 
        cotizaciones
        INNER JOIN COTIZACIONES_', var_tabla, ' on COTIZACIONES.id_cotizacion = COTIZACIONES_', var_tabla, '.cotizacion 
          INNER JOIN ',var_tabla,' ON COTIZACIONES_', var_tabla, '.',var_id,' = ', var_tabla, '.id_',var_id,' 
          INNER JOIN PRODUCTOS ON ', var_tabla, '.producto = PRODUCTOS.id_producto 
        SET 
          COTIZACIONES.monto = PRODUCTOS.precio * COTIZACIONES_', var_tabla, '.alto * COTIZACIONES_', var_tabla, '.largo * COTIZACIONES_', var_tabla, '.cantidad;
    ');

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//
DELIMITER ;

CALL guardar_subtotal('vidrios', 'vidrio');

-- ---------------------------------------------------SOBRE LAS CITAS
-- notificar cita cuando vaya a ser cierta fecha
DELIMITER //
CREATE TRIGGER trg_insert_notificacion_cita
BEFORE INSERT ON CITAS
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(DAY, CURDATE(), NEW.fecha) = 1 THEN
        INSERT INTO NOTIFICACIONES (tipo, cita, mensaje, usuario, fecha)
        VALUES ('cita', NEW.id_cita, 'Recordatorio de cita para mañana', NEW.usuario, NOW());
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_update_notificacion_cita
BEFORE UPDATE ON CITAS
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(DAY, CURDATE(), NEW.fecha) = 1 THEN
        INSERT INTO NOTIFICACIONES (tipo, cita, mensaje, usuario, fecha)
        VALUES ('cita', NEW.id_cita, 'Recordatorio de cita para mañana', NEW.usuario, NOW());
    END IF;
END//
DELIMITER ;

-- chcar las direcciones del usuario y depende de cual escoja insertarlo en el registro de la cita
DELIMITER //
CREATE TRIGGER trg_insert_cita_direccion
BEFORE INSERT ON CITAS
FOR EACH ROW
BEGIN
    DECLARE direccion_id INT;
    DECLARE usuario_id INT;

    SET usuario_id = NEW.usuario;

    -- Obtener las direcciones del usuario
    SELECT id_direccion INTO direccion_id
    FROM DIRECCIONES
    WHERE usuario = usuario_id
    ORDER BY id_direccion ASC
    LIMIT 1;

    -- Si no hay direcciones, lanzar un error
    IF direccion_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no tiene direcciones registradas';
    END IF;

    -- Asignar la dirección seleccionada a la cita
    SET NEW.direccion = direccion_id;
END//
DELIMITER ;

-- ---------------------------------------------------REGISTRAR Y CALCULAR ABONOS
-- que con cada nuevo abono cambie saldo
DELIMITER //
CREATE TRIGGER trg_update_venta_saldo
AFTER INSERT ON HISTORIAL_ABONOS
FOR EACH ROW
BEGIN
    UPDATE VENTAS
    SET saldo = saldo - NEW.cantidad_pagada
    WHERE id_venta = NEW.venta;
END//
DELIMITER ;

-- aplicar promo a la venta
DELIMITER //
CREATE TRIGGER after_insert_promocion_aplicada
AFTER INSERT ON PROMOCIONES_APLICADAS
FOR EACH ROW
BEGIN
    DECLARE promocion_tipo ENUM('porcentual','cantidad');
    DECLARE promocion_valor DECIMAL(10,2);
    DECLARE subtotal INT;

    -- Obtener el tipo y valor de la promoción
    SELECT tipo_promocion, valor INTO promocion_tipo, promocion_valor
    FROM PROMOCIONES
    WHERE id_promocion = NEW.promocion;

    -- Obtener el subtotal de la venta
    SELECT subtotal INTO subtotal
    FROM VENTAS
    WHERE id_venta = NEW.venta;

    -- Calcular el total de la promoción
    IF promocion_tipo = 'porcentual' THEN
        UPDATE VENTAS
        SET total_promocion = subtotal * promocion_valor,
            total = subtotal - (subtotal * promocion_valor),
            saldo = subtotal - (subtotal * promocion_valor)
        WHERE id_venta = NEW.venta;
    ELSEIF promocion_tipo = 'cantidad' THEN
        UPDATE VENTAS
        SET total_promocion = promocion_valor,
            total = subtotal - promocion_valor,
            saldo = subtotal - promocion_valor
        WHERE id_venta = NEW.venta;
    END IF;
END//
DELIMITER ;
    

-- ---------------------------------------------------RECIBOS
-- se crea una vista de todos los recibos existentes, como si fuera tabla
CREATE VIEW vista_recibos AS
SELECT 
    cotizaciones.fecha AS cotizacion_fecha,
    cotizaciones.monto AS cotizacion_monto,
    ventas.fecha_venta AS fecha_venta,
    ventas.subtotal AS subtotal,
    ventas.total_promocion AS total_promocion,
    ventas.extras AS extras,
    ventas.total AS total,
    historial_abonos.fecha_pago AS fecha_pago,
    historial_abonos.cantidad_pagada AS cantidad_pagada,
    ventas.saldo as saldo
FROM 
    cotizaciones
JOIN 
    ventas ON cotizaciones.id_cotizacion = ventas.cotizacion
LEFT JOIN 
    historial_abonos ON ventas.id_venta = historial_abonos.venta;
    
select * from vista_recibos;

-- se crea un procedimiento almacenado para consultar solo los recibos de determinado usuario
DELIMITER //
CREATE PROCEDURE consultar_recibos_por_usuario(IN nombre_completo VARCHAR(150))
BEGIN
  SELECT 
    vr.cotizacion_fecha,
    vr.cotizacion_monto,
    vr.fecha_venta,
    vr.subtotal,
    vr.total_promocion,
    vr.extras,
    vr.total,
    vr.fecha_pago,
    vr.cantidad_pagada,
    vr.saldo
FROM 
    vista_recibos vr
JOIN ventas v ON vr.fecha_venta = v.fecha_venta
JOIN cotizaciones c ON v.cotizacion = c.id_cotizacion
JOIN usuarios u ON c.usuario = u.id_usuario
JOIN persona p ON u.id_persona = p.id_persona
WHERE CONCAT(p.nombres, ' ', p.apellido_p, ' ', p.apellido_m) = nombre_completo;
END //

DELIMITER ;

CALL consultar_recibos_por_usuario('Carlos Arizpe Hernandez');

-- se crea un procedimiento almacenado para consultar solo los recibos de determinada fecha
DELIMITER //

CREATE PROCEDURE consultar_recibos_por_fecha(
	IN fecha_pago_1 datetime,
	IN fecha_pago_2 datetime
    )
BEGIN
    SELECT 
		vr.cotizacion_fecha,
		vr.cotizacion_monto,
		vr.fecha_venta,
		vr.subtotal,
		vr.total_promocion,
		vr.extras,
		vr.total,
		vr.fecha_pago,
		vr.cantidad_pagada,
		vr.saldo
    FROM 
        vista_recibos vr
    WHERE 
        vr.fecha_pago between fecha_pago_1 and fecha_pago_2;
END //
DELIMITER ;
CALL consultar_recibos_por_fecha('2024-06-01','2024-06-30');

SELECT * FROM usuarios WHERE id_usuario = 1;

SELECT * FROM persona WHERE id_persona  = 73;

INSERT INTO cotizaciones (usuario, fecha, monto)
VALUES (1, '2024-06-30', 1500.00);
-- Suponiendo que id_cotizacion = 1 (debes usar el ID real que se generó)
INSERT INTO ventas (fecha_venta, subtotal, total_promocion, extras, total, saldo, cotizacion)
VALUES ('2024-06-30', 1200.00, 100.00, 50.00, 1350.00, 1350.00, 49);
-- Suponiendo que id_venta = 1 (debes usar el ID real que se generó)
INSERT INTO historial_abonos (fecha_pago, cantidad_pagada, venta)
VALUES ('2024-06-30', 1350.00, 2);

-- se crea un procedimiento almacenado para que el usuario consulte sus recibos
DELIMITER //
CREATE PROCEDURE mostrar_mis_recibos()
BEGIN
    DECLARE usuario_id INT;
    SET usuario_id = (SELECT id_usuario FROM usuarios WHERE usuario = USER());
    
    SELECT 
		vista_recibos.cotizacion_fecha,
		vista_recibos.cotizacion_monto,
		vista_recibos.fecha_venta,
		vista_recibos.subtotal,
		vista_recibos.total_promocion,
		vista_recibos.extras,
		vista_recibos.total,
		vista_recibos.fecha_pago,
		vista_recibos.cantidad_pagada,
		vista_recibos.saldo
    FROM 
        vista_recibos
    JOIN 
        ventas ON vista_recibos.fecha_venta = ventas.fecha_venta
    JOIN 
        cotizaciones ON ventas.cotizacion = cotizaciones.id_cotizacion
    WHERE 
        cotizaciones.usuario = usuario_id;
END //
DELIMITER ;
-- Mostrar todos los recibos del usuario logeado
CALL mostrar_mis_recibos();
-- que el usuario solo pueda ver sus recibos de determianda fecha
DELIMITER //

CREATE PROCEDURE buscar_recibos_por_fecha(
    IN fecha_pago_1 datetime,
    IN fecha_pago_2 datetime
)
BEGIN
    DECLARE usuario_id INT;
    SET usuario_id = (SELECT id_usuario FROM usuarios WHERE usuario = USER());
    
    SELECT 
        vr.cotizacion_fecha,
        vr.cotizacion_monto,
        vr.fecha_venta,
        vr.subtotal,
        vr.total_promocion,
        vr.extras,
        vr.total,
        vr.fecha_pago,
        vr.cantidad_pagada,
        vr.saldo
    FROM 
        vista_recibos vr
    JOIN 
        ventas v ON vr.fecha_venta = v.fecha_venta
    JOIN 
        cotizaciones c ON v.cotizacion = c.id_cotizacion
    JOIN 
        usuarios u ON c.usuario = u.id_usuario
    WHERE 
        u.id_usuario = usuario_id
        AND vr.fecha_pago BETWEEN fecha_pago_1 AND fecha_pago_2;
END //

DELIMITER ;
CALL buscar_recibos_por_fecha('2024-06-01', '2024-06-30');

-- ---------------------------------------------------PARA EL ADMINISTRADOR
-- vistas: citas.fecha, citas.status
CREATE VIEW vista_citas_admin AS
SELECT c.fecha, c.status, c.id_cita, p.nombres, p.apellido_p, d.calle, d.numero, d.colonia, d.ciudad, d.referencias
FROM CITAS c
JOIN USUARIOS u ON c.usuario = u.id_usuario
JOIN PERSONA p ON u.id_persona = p.id_persona
JOIN DIRECCIONES d ON c.direccion = d.id_direccion;

SELECT * FROM vista_citas_admin;
-- casar ventas con promociones y se crea registro en promos aplicadas

-- escoger un usuario, luego una cotizaciones segun la fecha, rellenar extras y notas, lo demás se autocompleta
DELIMITER //

CREATE PROCEDURE crearVenta(
    IN usuario_id INT,
    IN cotizacion_id INT,
    IN extras INT,
    IN notas VARCHAR(300)
)
BEGIN
    DECLARE subtotal INT;
    DECLARE total INT;
    DECLARE saldo INT;
    DECLARE fecha_venta DATE;
    DECLARE rows_found INT; -- Variable para contar las filas afectadas por la consulta

    -- Obtener fecha y subtotal de la cotización
    SELECT fecha, monto INTO fecha_venta, subtotal
    FROM COTIZACIONES
    WHERE id_cotizacion = cotizacion_id;

    -- Obtener el número de filas afectadas por la consulta anterior
    SET rows_found = ROW_COUNT();

    -- Verificar si se encontró la cotización
    IF rows_found = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cotización especificada no existe.';
    END IF;

    -- Calcular total y saldo inicial (suponiendo que son iguales al subtotal para empezar)
    SET total = subtotal;
    SET saldo = subtotal;

    -- Insertar la nueva venta
    INSERT INTO VENTAS (cotizacion, fecha_venta, subtotal, extras, notas, total, saldo)
    VALUES (cotizacion_id, fecha_venta, subtotal, extras, notas, total, saldo);

    -- Confirmar la transacción
    COMMIT;
END //

DELIMITER ;
CALL crearVenta(4, 26, 500, 'La pared tiene que ser resanada');

-- consultar id de usuario en base al nombre
DELIMITER //

CREATE PROCEDURE GetUsuarioIdByNombre(
    IN var_nombre_usuario VARCHAR(70)
)
BEGIN
    DECLARE var_id_usuario INT;

    SET var_id_usuario = (
        SELECT id_usuario
        FROM USUARIOS INNER JOIN PERSONA ON USUARIOS.id_persona = PERSONA.id_persona
        WHERE var_nombre_usuario = CONCAT(PERSONA.nombres, ' ', PERSONA.apellido_p, ' ', PERSONA.apellido_m)
    );

    IF var_id_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Usuario no encontrado';
    ELSE
        SELECT var_id_usuario AS id_usuario;
    END IF;
END //

DELIMITER ;

CALL GetUsuarioIdByNombre('Carlos Arizpe Hernandez');
CALL GetUsuarioIdByNombre('Jefferson Gutierritos');

-- ---------------------------------------------------FALTA ACOMODAR

-- consultar id del producto en base al nombre
DELIMITER //
CREATE PROCEDURE GetProductoIdByNombre(
	IN p_nombre_producto VARCHAR(200)
)
BEGIN
    DECLARE v_id_producto INT;

    SELECT id_producto INTO v_id_producto
    FROM PRODUCTOS
    WHERE nombre = p_nombre_producto;

    IF v_id_producto IS NULL THEN
        SELECT 'Producto no encontrado' AS mensaje;
    ELSE
        SELECT v_id_producto AS id_producto;
    END IF;
END //
DELIMITER ;
CALL GetProductoIdByNombre('Persiana Moderna');

/*El procedimiento almacenado para direcciones que se le envía al instalador nada más 
con nombre del cliente fecha hora y dirección */
DELIMITER //

CREATE TRIGGER trg_insert_notificacion_instalador
AFTER UPDATE ON CITAS
FOR EACH ROW
BEGIN
    DECLARE instalador_id INT;
    DECLARE instalador_nombre VARCHAR(100);
    DECLARE mensaje VARCHAR(300);
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT u.id_usuario, p.nombre
        FROM USUARIOS u
        JOIN PERSONAS p ON u.id_persona = p.id_persona
        WHERE u.rol = 'instalador';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Verificar si la cita ha sido aceptada y es de tipo 'instalacion'
    IF NEW.status = 'aceptada' AND OLD.status <> 'aceptada' AND NEW.tipo = 'instalacion' THEN
        -- Construir el mensaje de notificación
        SET mensaje = CONCAT('Tiene una cita aceptada con ', NEW.usuario, ' el ', NEW.fecha, ' a las ', NEW.hora, ' en ', (SELECT nombre FROM DIRECCIONES WHERE id_direccion = NEW.direccion));

        -- Abrir el cursor
        OPEN cur;

        -- Recorrer todos los instaladores y enviar la notificación
        read_loop: LOOP
            FETCH cur INTO instalador_id, instalador_nombre;
            IF done THEN
                LEAVE read_loop;
            END IF;

            -- Insertar la notificación para cada instalador
            INSERT INTO NOTIFICACIONES (tipo, cita, mensaje, usuario, fecha)
            VALUES ('cita_aceptada', NEW.id_cita, mensaje, instalador_id, NOW());
        END LOOP;

        -- Cerrar el cursor
        CLOSE cur;
    END IF;
END //

DELIMITER ;

UPDATE CITAS
SET status = 'aceptada'
WHERE id_cita = 1;
SELECT * FROM NOTIFICACIONES;
