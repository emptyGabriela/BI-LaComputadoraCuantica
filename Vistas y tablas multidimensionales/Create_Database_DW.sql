CREATE DATABASE HotelDW
USE HotelDW
GO

-- Tabla dbo.Cliente
CREATE TABLE dbo.Cliente (
    id_cliente INT PRIMARY KEY,
    nombre NVARCHAR(100),
    apellido NVARCHAR(100),
    email NVARCHAR(150),
    fecha_nacimiento DATE,
    genero VARCHAR(20),
    nacionalidad NVARCHAR(50)
); 

-- Tabla dbo.Habitacion
CREATE TABLE dbo.Habitacion (
    id_habitacion INT PRIMARY KEY,
    numero NVARCHAR(10),
    tipo_habitacion NVARCHAR(50),
    capacidad_base INT,
    capacidad INT,
    precio_base DECIMAL(10,2),
    estado_actual NVARCHAR(20),
    fecha_estado DATETIME
); 

-- Tabla dbo.Reserva
CREATE TABLE dbo.Reserva (
    id_reserva INT PRIMARY KEY,
    fecha_reserva DATETIME,
    check_in DATE,
    check_out DATE,
    id_cliente INT,
    cliente_nombre NVARCHAR(100),
    id_habitacion INT,
    habitacion_numero NVARCHAR(10),
    fuente_reserva NVARCHAR(100),
    estado_reserva NVARCHAR(20),
    fecha_estado DATETIME
);

-- Tabla dbo.Pago
CREATE TABLE dbo.Pago (
    id_pago INT PRIMARY KEY,
    fecha_pago DATE,
    monto DECIMAL(10,2),
    metodo_pago NVARCHAR(50),
    id_reserva INT,
    id_cliente INT,
    estado_pago NVARCHAR(20),
    fecha_estado DATETIME
);

-- Tabla dbo.Empleado
CREATE TABLE dbo.Empleado (
    id_empleado INT PRIMARY KEY,
    nombre NVARCHAR(100),
    apellido NVARCHAR(100),
    puesto NVARCHAR(100),
    departamento NVARCHAR(100),
    turno NVARCHAR(20),
    activo BIT,
    fecha_asignacion DATE
);

-- Tabla dbo.Tarea
CREATE TABLE dbo.Tarea (
    id_tarea INT PRIMARY KEY,
    descripcion NVARCHAR(255),
    fecha_asignacion DATE,
    evaluacion NVARCHAR(100),
    id_empleado INT,
    nombre_empleado NVARCHAR(100),
    hora_inicio TIME,
    hora_fin TIME
);

-- Tabla dbo.Mantenimiento
CREATE TABLE dbo.Mantenimiento (
    id_mantenimiento INT PRIMARY KEY,
    fecha_inicio DATE,
    fecha_fin DATE,
    descripcion NVARCHAR(255),
    costo DECIMAL(10,2),
    habitacion_numero NVARCHAR(10)
);

-- Tabla dbo.Producto
CREATE TABLE dbo.Producto (
    id_producto INT PRIMARY KEY,
    nombre NVARCHAR(100),
    unidad NVARCHAR(20),
    simbolo NVARCHAR(5),
    ubicacion NVARCHAR(100),
    costo_unitario DECIMAL(10,2),
    stock_actual INT,
    stock_minimo INT
);

-- Tabla dbo.MovimientoInventario
CREATE TABLE dbo.MovimientoInventario (
    id_movimiento INT PRIMARY KEY,
    fecha DATETIME,
    producto NVARCHAR(100),
    tipo_movimiento NVARCHAR(20),
    cantidad INT,
    observaciones NVARCHAR(255)
);

-- Tabla dbo.Encuesta
CREATE TABLE dbo.Encuesta (
    id_encuesta INT PRIMARY KEY,
    fecha DATETIME,
    puntaje INT,
    comentario NVARCHAR(500),
    id_reserva INT,
    fuente_encuesta NVARCHAR(100)
);

-- Tabla dbo.Visita
CREATE TABLE dbo.Visita (
    id_visita INT PRIMARY KEY,
    fecha_visita DATETIME,
    id_reserva INT,
    id_cliente INT
);
