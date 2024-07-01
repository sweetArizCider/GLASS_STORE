use glass_store_v2;

-- claves unicas: correo, telefono
-- select favoritos.usuario 

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

-- consultar favoritos por usuario
-- es un select sencillo pero hay que usar el @session_user_id

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

/*echar un producto a un carro que no sabemos si existe o no*/
DELIMITER //
CREATE PROCEDURE HandleCotizacion(
    IN p_table_name VARCHAR(10),
    IN p_new_id INT
)
BEGIN
    DECLARE v_cotizacion_id INT;

    -- Llamar a la función CotizacionesSinVentaPorUsuario y guardar el resultado en v_cotizacion_id
    SET v_cotizacion_id = (SELECT CotizacionesSinVentaPorUsuario());

    -- Si no hay una cotización sin venta por usuario, crear una nueva
    IF v_cotizacion_id IS NULL THEN
        INSERT INTO COTIZACIONES (usuario, monto) VALUES (@session_user_id, 0);
        
	SET v_cotizacion_id = LAST_INSERT_ID();
    END IF;

    -- SQL dinámico para enlazar el nuevo registro con la cotización existente o con la nueva
    SET @enlazar_cotizaciones = CONCAT('UPDATE ', p_table_name, ' SET cotizacion = ', v_cotizacion_id, ' WHERE id_cotizacion = ', p_new_id);
    PREPARE stmt FROM @enlazar_cotizaciones;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER AfterInsertCotizacionesHerreria
AFTER INSERT ON COTIZACIONES_HERRERIAS
FOR EACH ROW
BEGIN
    CALL HandleCotizacion('COTIZACIONES_HERRERIAS', NEW.id_cotizacion);
END //
DELIMITER ;

-- probanding
/*
SELECT @session_user_id; 
'4'
call CotizacionesSinVentaPorUsuario; 
'8'

unica venta que tiene el usuario 4
# id_venta, cotizacion, fecha_venta, subtotal, total_promocion, extras, notas, total, saldo
'2', '7', '2024-06-30', '0', '0', '0', 'hola', '0', '0'

ahora digamos que usuario 4 hace quiere un pasamanos

insert into COTIZACIONES_HERRERIAS (cotizacion, herreria, alto, largo, cantidad)
values ('0', '37', '1.30', '4.00', '1');

El error que estás viendo indica que estás intentando insertar un valor en la columna cotizacion de la tabla COTIZACIONES_HERRERIAS que no existe en la tabla referenciada cotizaciones a través de la clave foránea COTIZACIONES_HERRERIAS_ibfk_1.

Esto generalmente sucede cuando intentas insertar un valor en una columna que está configurada como una clave foránea (FOREIGN KEY) y ese valor no existe en la tabla referenciada.

*/


/*sacar del carrito un producto que después podría ser echado otra vez*/



/*
si el carrito anterior ya se hizo venta
y quiero volver a poner como activo un producto enlazado a una cotizacion previa
entonces lo desenlaza de la anterior cotizacion y, o hace una nueva, o lo hecha al nuevo carrito
*/

-- ver carrito

-- ---------------------------------------------------CALCULAR PRECIOS COTIZACIONES
-- NOTA: VERIFICAR CON EL EXCEL COTIZADOR ACTUAL DE LA CLIENTA PARA AJUSTAR CÁLCULOS
-- cotizacion_especifica imprimir los calculos en frontend pero no guardar el monto total todavía
no se ocupa estar logeado
se escoge producto, lleva a la tabla de cotizacion adecuada
productos.precio * alto*largo * cantidad
resultado guardar en una variable en el frontend, se puede perder si se cierra la pestaña (procedimiento almacenado calcular)

USAR UNA TABLA TEMPORAL PARA GUARDAR LOS DATOS DE LA COTIZACION NO GUARDADA?????

Crear una tabla temporal: Puedes almacenar el valor en una tabla temporal que pueda ser accedida por otros procedimientos o triggers.
    
-- trigger para ir actualizando el monto de la cotizacion,
-- esta aparte de lo del carrito porque esto se usará cada vez que haya un cambio

-- ---------------------------------------------------SOBRE LAS CITAS
-- notificar cita cuando vaya a ser cierta fecha
-- chcar las direcciones del usuario y depende de cual escoja insertarlo en el registro de la cita

-- ---------------------------------------------------REGISTRAR Y CALCULAR ABONOS
-- historial abono

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
CREATE PROCEDURE consultar_recibos_por_usuario(
	IN nombre_completo VARCHAR(150)
    )
BEGIN
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
        USUARIOS ON ventas.usuario = usuarios.id_usuario
    JOIN 
        PERSONA ON usuarios.id_persona = persona.id_persona
    WHERE 
        CONCAT(persona.nombres, ' ', persona.apellido_p, ' ', persona.apellido_m) = nombre_completo;
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
        USUARIOS ON ventas.usuario = usuarios.id_usuario
    JOIN 
        PERSONA ON usuarios.id_persona = persona.id_persona
    WHERE 
        vista_recibos.fecha_pago between fecha_pago_1 and fecha_pago_2;
END //
DELIMITER ;

CALL consultar_recibos_por_fecha('2024-06-01','2024-06-30');

-- se crea un procedimiento almacenado para que el usuario consulte sus recibos
-- que el usuario solo pueda ver sus recibos de determianda fecha



-- ---------------------------------------------------RELACIONADO A LOS ABONOS Y PAGOS
-- trigger para que el saldo se actualice cada que haya un abono

-- ---------------------------------------------------PARA EL ADMINISTRADOR
-- vistas: citas.fecha, citas.status
-- casar ventas con promociones y se crea registro en promos aplicadas
-- juntar datos para irlos registrando: historial abono,
-- escoger un usuario, luego una cotizaciones segun la fecha, rellenar extras y notas, lo demás se autocompleta

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

-- el de arizpe
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
    