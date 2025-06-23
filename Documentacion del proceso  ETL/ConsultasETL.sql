-- Script con consultas utilizadas para realizar el proceso de ETL 
-- Base de datos: HotelOLTP
-- Se utiliza SELECT INTO para poblar las tablas de la base de datos HotelDW sin tener que crear las tablas previamente.

-- Consulta para poblar la tabla dbo.Cliente
-- Contiene información consolidada de clientes con teléfonos y nacionalidad.
SELECT
    c.id_cliente,
    c.nombre,
    c.apellido,
    c.email,
    c.fecha_nacimiento,
    CASE c.genero
        WHEN 'M' THEN 'Masculino'
        WHEN 'F' THEN 'Femenino'
        WHEN 'O' THEN 'No respondió'
        ELSE 'Desconocido'
    END AS genero,
    n.nombre AS nacionalidad
FROM Cliente.Cliente c
LEFT JOIN Cliente.Nacionalidad n ON c.id_nacionalidad = n.id_nacionalidad
LEFT JOIN Cliente.Telefono t ON c.id_cliente = t.id_cliente
GROUP BY
    c.id_cliente, c.nombre, c.apellido, c.email, c.fecha_nacimiento, c.genero, n.nombre;

-- Consulta para poblar la tabla dbo.Habitacion
-- Datos consolidados de habitaciones con tipo y estado actual.

SELECT
    h.id_habitacion,
    h.numero,
    t.nombre AS tipo_habitacion,
    t.capacidad_base,
    h.capacidad,
    h.precio_base,
    e.nombre AS estado_actual,
    ea.fecha_actualizacion AS fecha_estado
FROM Habitacion.Habitacion h
INNER JOIN Habitacion.Tipo t ON h.id_tipo = t.id_tipo
LEFT JOIN Habitacion.EstadoActual ea ON h.id_habitacion = ea.id_habitacion
LEFT JOIN Habitacion.Estado e ON ea.id_estado = e.id_estado;

-- Consulta para poblar la tabla dbo.Reserva
-- Detalles completos de reservas, cliente, habitación, fuente y estado.

SELECT
    r.id_reserva,
    r.fecha_reserva,
    r.check_in,
    r.check_out,
    c.id_cliente,
    c.nombre AS cliente_nombre,
    h.id_habitacion,
    h.numero AS habitacion_numero,
    f.nombre AS fuente_reserva,
    e.nombre AS estado_reserva,
    ea.fecha_actualizacion AS fecha_estado
FROM Reserva.Reserva r
INNER JOIN Cliente.Cliente c ON r.id_cliente = c.id_cliente
INNER JOIN Habitacion.Habitacion h ON r.id_habitacion = h.id_habitacion
INNER JOIN Reserva.Fuente f ON r.id_fuente = f.id_fuente
LEFT JOIN Reserva.EstadoActual ea ON r.id_reserva = ea.id_reserva
LEFT JOIN Reserva.Estado e ON ea.id_estado = e.id_estado;

-- Consulta para poblar la tabla dbo.Pago
-- Información de pagos asociados a reservas y estados.

SELECT
    p.id_pago,
    p.fecha_pago,
    p.monto,
    p.metodo_pago,
    r.id_reserva,
    c.id_cliente,
    e.nombre AS estado_pago,
    ea.fecha_actualizacion AS fecha_estado
FROM Pago.Transaccion p
INNER JOIN Reserva.Reserva r ON p.id_reserva = r.id_reserva
INNER JOIN Cliente.Cliente c ON r.id_cliente = c.id_cliente
LEFT JOIN Pago.EstadoActual ea ON p.id_pago = ea.id_pago
LEFT JOIN Pago.Estado e ON ea.id_estado = e.id_estado;

-- Consulta para poblar la tabla dbo.Empleado
-- Datos de empleados con puestos y turnos asignados.

SELECT
    e.id_empleado,
    e.nombre,
    e.apellido,
    p.nombre AS puesto,
    p.departamento,
    t.nombre AS turno,
    ta.activo,
    ta.fecha_asignacion
FROM Empleado.Empleado e
INNER JOIN Empleado.Puesto p ON e.id_puesto = p.id_puesto
LEFT JOIN Empleado.TurnoAsignado ta ON e.id_empleado = ta.id_empleado
LEFT JOIN Empleado.Turno t ON ta.id_turno = t.id_turno;

-- Consulta para poblar la tabla dbo.Tarea
-- Tareas asignadas a empleados con horarios y evaluaciones.

SELECT
    a.id_tarea,
    a.descripcion,
    a.fecha_asignacion,
    a.evaluacion,
    e.id_empleado,
    e.nombre AS nombre_empleado,
    h.hora_inicio,
    h.hora_fin
FROM Tarea.Asignacion a
INNER JOIN Empleado.Empleado e ON a.id_empleado = e.id_empleado
LEFT JOIN Tarea.Horario h ON a.id_tarea = h.id_tarea;

-- Consulta para poblar la tabla dbo.Mantenimiento
-- Registros de mantenimiento de habitaciones con costos.

SELECT
    m.id_mantenimiento,
    m.fecha_inicio,
    m.fecha_fin,
    m.descripcion,
    c.costo,
    h.numero AS habitacion_numero
FROM Mantenimiento.Registro m
INNER JOIN Habitacion.Habitacion h ON m.id_habitacion = h.id_habitacion
LEFT JOIN Mantenimiento.Costo c ON m.id_mantenimiento = c.id_mantenimiento;

-- Consulta para poblar la tabla dbo.Producto
-- Productos con unidad de medida, ubicación y stock.

SELECT
    p.id_producto,
    p.nombre,
    u.nombre AS unidad,
    u.simbolo,
    p.ubicacion,
    p.costo_unitario,
    s.stock_actual,
    s.stock_minimo
FROM Producto.Producto p
INNER JOIN Producto.Unidad u ON p.id_unidad = u.id_unidad
LEFT JOIN Producto.Stock s ON p.id_producto = s.id_producto;

-- Consulta para poblar la tabla dbo.MovimientoInventario
-- Movimientos de inventario con tipo, cantidad y observaciones.

SELECT
    m.id_movimiento,
    m.fecha,
    p.nombre AS producto,
    tm.nombre AS tipo_movimiento,
    m.cantidad,
    m.observaciones
FROM Inventario.Movimiento m
INNER JOIN Producto.Producto p ON m.id_producto = p.id_producto
INNER JOIN Inventario.TipoMovimiento tm ON m.id_tipo = tm.id_tipo;

-- Consulta para poblar la tabla dbo.Encuesta
-- Encuestas de satisfacción de clientes relacionadas a reservas.

SELECT
    s.id_encuesta,
    s.fecha,
    s.puntaje,
    s.comentario,
    r.id_reserva,
    f.nombre AS fuente_encuesta
FROM Encuesta.Satisfaccion s
INNER JOIN Reserva.Reserva r ON s.id_reserva = r.id_reserva
INNER JOIN Encuesta.Fuente f ON s.id_fuente = f.id_fuente;

-- Consulta para poblar la tabla dbo.Visita
-- Registro de visitas relacionadas a reservas y clientes.

SELECT
    v.id_visita,
    v.fecha_visita,
    r.id_reserva,
    c.id_cliente
FROM Visita.Registro v
INNER JOIN Reserva.Reserva r ON v.id_reserva = r.id_reserva
INNER JOIN Cliente.Cliente c ON r.id_cliente = c.id_cliente;
