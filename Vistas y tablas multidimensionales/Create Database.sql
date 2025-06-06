CREATE DATABASE HotelOLTP;
USE HotelOLTP
GO

-- CRECION DE TODOS LOS SCHEMAS (INDISPENSABLE EJECUTAR UNO X UNO)
CREATE SCHEMA Cliente;
CREATE SCHEMA Habitacion;
CREATE SCHEMA Reserva;
CREATE SCHEMA Pago;
CREATE SCHEMA Empleado;
CREATE SCHEMA Tarea;
CREATE SCHEMA Mantenimiento;
CREATE SCHEMA Producto;
CREATE SCHEMA Inventario;
CREATE SCHEMA Encuesta;
CREATE SCHEMA Visita;


-- ESQUEMA: Cliente
CREATE TABLE Cliente.Nacionalidad (
    id_nacionalidad INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Cliente.Cliente (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    email NVARCHAR(150) UNIQUE,
    fecha_nacimiento DATE,
    genero CHAR(1) CHECK (genero IN ('M', 'F', 'O')),
    id_nacionalidad INT NOT NULL,
    fecha_registro DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT fk_cliente_nacionalidad FOREIGN KEY (id_nacionalidad) 
        REFERENCES Cliente.Nacionalidad(id_nacionalidad)
);

CREATE TABLE Cliente.Telefono (
    id_telefono INT PRIMARY KEY IDENTITY(1,1),
    id_cliente INT NOT NULL,
    telefono NVARCHAR(20) NOT NULL,
    principal BIT DEFAULT 1,
    
    CONSTRAINT fk_telefono_cliente FOREIGN KEY (id_cliente) 
        REFERENCES Cliente.Cliente(id_cliente)
);

-- ESQUEMA: Habitacion
CREATE TABLE Habitacion.Tipo (
    id_tipo INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(50) NOT NULL UNIQUE,
    capacidad_base INT NOT NULL CHECK (capacidad_base > 0)
);

CREATE TABLE Habitacion.Estado (
    id_estado INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Habitacion.Habitacion (
    id_habitacion INT PRIMARY KEY IDENTITY(1,1),
    numero NVARCHAR(10) NOT NULL UNIQUE,
    id_tipo INT NOT NULL,
    capacidad INT NOT NULL CHECK (capacidad > 0),
    precio_base DECIMAL(10, 2) NOT NULL CHECK (precio_base > 0),
    
    CONSTRAINT fk_habitacion_tipo FOREIGN KEY (id_tipo) 
        REFERENCES Habitacion.Tipo(id_tipo)
);

CREATE TABLE Habitacion.EstadoActual (
    id_estado_actual INT PRIMARY KEY IDENTITY(1,1),
    id_habitacion INT NOT NULL UNIQUE,
    id_estado INT NOT NULL,
    fecha_actualizacion DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT fk_estado_habitacion FOREIGN KEY (id_habitacion) 
        REFERENCES Habitacion.Habitacion(id_habitacion),
    CONSTRAINT fk_estado_catalogo FOREIGN KEY (id_estado) 
        REFERENCES Habitacion.Estado(id_estado)
);

-- ESQUEMA: Reserva
CREATE TABLE Reserva.Fuente (
    id_fuente INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Reserva.Estado (
    id_estado INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Reserva.Reserva (
    id_reserva INT PRIMARY KEY IDENTITY(1,1),
    id_cliente INT NOT NULL,
    id_habitacion INT NOT NULL,
    id_fuente INT NOT NULL,
    fecha_reserva DATETIME DEFAULT GETDATE(),
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (id_cliente) 
        REFERENCES Cliente.Cliente(id_cliente),
    CONSTRAINT fk_reserva_habitacion FOREIGN KEY (id_habitacion) 
        REFERENCES Habitacion.Habitacion(id_habitacion),
    CONSTRAINT fk_reserva_fuente FOREIGN KEY (id_fuente) 
        REFERENCES Reserva.Fuente(id_fuente),
    CONSTRAINT chk_fechas_reserva CHECK (check_in < check_out)
);

CREATE TABLE Reserva.EstadoActual (
    id_estado_actual INT PRIMARY KEY IDENTITY(1,1),
    id_reserva INT NOT NULL UNIQUE,
    id_estado INT NOT NULL,
    fecha_actualizacion DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT fk_estado_reserva FOREIGN KEY (id_reserva) 
        REFERENCES Reserva.Reserva(id_reserva),
    CONSTRAINT fk_estado_catalogo FOREIGN KEY (id_estado) 
        REFERENCES Reserva.Estado(id_estado)
);

-- ESQUEMA: Pago
CREATE TABLE Pago.Estado (
    id_estado INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Pago.Transaccion (
    id_pago INT PRIMARY KEY IDENTITY(1,1),
    id_reserva INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10, 2) NOT NULL CHECK (monto > 0),
    metodo_pago NVARCHAR(50),
    
    CONSTRAINT fk_pago_reserva FOREIGN KEY (id_reserva) 
        REFERENCES Reserva.Reserva(id_reserva)
);

CREATE TABLE Pago.EstadoActual (
    id_estado_actual INT PRIMARY KEY IDENTITY(1,1),
    id_pago INT NOT NULL UNIQUE,
    id_estado INT NOT NULL,
    fecha_actualizacion DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT fk_estado_pago FOREIGN KEY (id_pago) 
        REFERENCES Pago.Transaccion(id_pago),
    CONSTRAINT fk_estado_catalogo FOREIGN KEY (id_estado) 
        REFERENCES Pago.Estado(id_estado)
);

-- ESQUEMA: Empleado
CREATE TABLE Empleado.Puesto (
    id_puesto INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL UNIQUE,
    departamento NVARCHAR(100) NOT NULL
);

CREATE TABLE Empleado.Turno (
    id_turno INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Empleado.Empleado (
    id_empleado INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    id_puesto INT NOT NULL,
    fecha_contratacion DATE NOT NULL,
	estado BIT NOT NULL default 1
    
    CONSTRAINT fk_empleado_puesto FOREIGN KEY (id_puesto) 
        REFERENCES Empleado.Puesto(id_puesto)
);

CREATE TABLE Empleado.TurnoAsignado (
    id_asignacion INT PRIMARY KEY IDENTITY(1,1),
    id_empleado INT NOT NULL,
    id_turno INT NOT NULL,
    activo BIT DEFAULT 1,
    fecha_asignacion DATE DEFAULT GETDATE(),
    
    CONSTRAINT fk_turno_empleado FOREIGN KEY (id_empleado) 
        REFERENCES Empleado.Empleado(id_empleado),
    CONSTRAINT fk_turno_catalogo FOREIGN KEY (id_turno) 
        REFERENCES Empleado.Turno(id_turno)
);

-- ESQUEMA: Tarea
CREATE TABLE Tarea.Asignacion (
    id_tarea INT PRIMARY KEY IDENTITY(1,1),
    id_empleado INT NOT NULL,
    descripcion NVARCHAR(255) NOT NULL,
    fecha_asignacion DATE NOT NULL DEFAULT GETDATE(),
    evaluacion NVARCHAR(100),
    
    CONSTRAINT fk_tarea_empleado FOREIGN KEY (id_empleado) 
        REFERENCES Empleado.Empleado(id_empleado)
);

CREATE TABLE Tarea.Horario (
    id_horario INT PRIMARY KEY IDENTITY(1,1),
    id_tarea INT NOT NULL UNIQUE,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    
    CONSTRAINT fk_horario_tarea FOREIGN KEY (id_tarea) 
        REFERENCES Tarea.Asignacion(id_tarea),
    CONSTRAINT chk_horas_tarea CHECK (hora_inicio < hora_fin)
);

-- ESQUEMA: Mantenimiento
CREATE TABLE Mantenimiento.Registro (
    id_mantenimiento INT PRIMARY KEY IDENTITY(1,1),
    id_habitacion INT NOT NULL,
    fecha_inicio DATE NOT NULL DEFAULT GETDATE(),
    fecha_fin DATE,
    descripcion NVARCHAR(255) NOT NULL,
    
    CONSTRAINT fk_mantenimiento_habitacion FOREIGN KEY (id_habitacion) 
        REFERENCES Habitacion.Habitacion(id_habitacion),
    CONSTRAINT chk_fechas_mantenimiento CHECK (fecha_inicio <= fecha_fin)
);

CREATE TABLE Mantenimiento.Costo (
    id_costo INT PRIMARY KEY IDENTITY(1,1),
    id_mantenimiento INT NOT NULL UNIQUE,
    costo DECIMAL(10,2) NOT NULL CHECK (costo >= 0),
    
    CONSTRAINT fk_costo_mantenimiento FOREIGN KEY (id_mantenimiento) 
        REFERENCES Mantenimiento.Registro(id_mantenimiento)
);

-- ESQUEMA: Producto
CREATE TABLE Producto.Unidad (
    id_unidad INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(20) NOT NULL UNIQUE,
    simbolo NVARCHAR(5)
);

CREATE TABLE Producto.Producto (
    id_producto INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    id_unidad INT NOT NULL,
    ubicacion NVARCHAR(100),
    costo_unitario DECIMAL(10,2) NOT NULL CHECK (costo_unitario >= 0),
    
    CONSTRAINT fk_producto_unidad FOREIGN KEY (id_unidad) 
        REFERENCES Producto.Unidad(id_unidad)
);

CREATE TABLE Producto.Stock (
    id_stock INT PRIMARY KEY IDENTITY(1,1),
    id_producto INT NOT NULL UNIQUE,
    stock_actual INT NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),
    stock_minimo INT NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0),
    
    CONSTRAINT fk_stock_producto FOREIGN KEY (id_producto) 
        REFERENCES Producto.Producto(id_producto)
);

-- ESQUEMA: Inventario
CREATE TABLE Inventario.TipoMovimiento (
    id_tipo INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Inventario.Movimiento (
    id_movimiento INT PRIMARY KEY IDENTITY(1,1),
    id_producto INT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT GETDATE(),
    id_tipo INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    observaciones NVARCHAR(255),
    
    CONSTRAINT fk_movimiento_producto FOREIGN KEY (id_producto) 
        REFERENCES Producto.Producto(id_producto),
    CONSTRAINT fk_tipo_movimiento FOREIGN KEY (id_tipo) 
        REFERENCES Inventario.TipoMovimiento(id_tipo)
);

-- ESQUEMA: Encuesta
CREATE TABLE Encuesta.Fuente (
    id_fuente INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Encuesta.Satisfaccion (
    id_encuesta INT PRIMARY KEY IDENTITY(1,1),
    id_reserva INT NOT NULL UNIQUE,
    fecha DATETIME NOT NULL DEFAULT GETDATE(),
    puntaje INT NOT NULL CHECK (puntaje BETWEEN 1 AND 10),
    comentario NVARCHAR(500),
    id_fuente INT NOT NULL,
    
    CONSTRAINT fk_encuesta_reserva FOREIGN KEY (id_reserva) 
        REFERENCES Reserva.Reserva(id_reserva),
    CONSTRAINT fk_encuesta_fuente FOREIGN KEY (id_fuente) 
        REFERENCES Encuesta.Fuente(id_fuente)
);

-- ESQUEMA: Visita

CREATE TABLE Visita.Registro (
    id_visita INT PRIMARY KEY IDENTITY(1,1),
    id_reserva INT NOT NULL,
    fecha_visita DATETIME NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT fk_visita_reserva FOREIGN KEY (id_reserva) 
        REFERENCES Reserva.Reserva(id_reserva)
);