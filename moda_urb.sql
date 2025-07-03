USE moda_urbana_scz;

CREATE TABLE Sucursal (
  id_sucursal INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  ubicacion VARCHAR(255) NOT NULL,
  tipo_canales VARCHAR(100) NOT NULL
);

CREATE TABLE Producto (
  id_producto INT PRIMARY KEY AUTO_INCREMENT,
  codigo_unico VARCHAR(50) UNIQUE NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  descripcion TEXT,
  marca VARCHAR(100) NOT NULL,
  categoria VARCHAR(100) NOT NULL,
  precio_base DECIMAL(10,2) NOT NULL,
  activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE Coleccion (
  id_coleccion INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE
);

CREATE TABLE Producto_Coleccion (
  id_producto INT NOT NULL,
  id_coleccion INT NOT NULL,
  PRIMARY KEY (id_producto, id_coleccion),
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
  FOREIGN KEY (id_coleccion) REFERENCES Coleccion(id_coleccion)
);

CREATE TABLE Cliente (
  id_cliente INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100),
  email VARCHAR(150) UNIQUE,
  telefono VARCHAR(20),
  fidelidad VARCHAR(50)
);

CREATE TABLE Vendedor (
  id_vendedor INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100),
  turno ENUM('mañana','tarde','noche'),
  meta_mensual DECIMAL(10,2),
  id_sucursal INT NOT NULL,
  FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

CREATE TABLE Pedido (
  id_pedido INT PRIMARY KEY AUTO_INCREMENT,
  fecha_creacion DATETIME NOT NULL,
  fecha_pago DATETIME,
  estado ENUM('Pagado','En preparación','Enviado','Entregado','Devuelto') NOT NULL DEFAULT 'En preparación',
  canal ENUM('presencial','online','redes','whatsapp') NOT NULL,
  id_cliente INT NOT NULL,
  id_vendedor INT,
  id_sucursal INT NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor),
  FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

CREATE TABLE Promocion (
  id_promocion INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  tipo VARCHAR(50),
  valor_descuento DECIMAL(5,2),
  fecha_ini DATE NOT NULL,
  fecha_fin DATE,
  activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE Detalle_Pedido (
  id_pedido INT NOT NULL,
  id_producto INT NOT NULL,
  talla VARCHAR(10),
  color VARCHAR(20),
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  id_promocion INT,
  PRIMARY KEY (id_pedido, id_producto, talla, color),
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
  FOREIGN KEY (id_promocion) REFERENCES Promocion(id_promocion)
);

CREATE TABLE Movimiento_Stock (
  id_movimiento INT PRIMARY KEY AUTO_INCREMENT,
  id_producto INT NOT NULL,
  id_sucursal INT NOT NULL,
  fecha DATETIME NOT NULL,
  cantidad INT NOT NULL,
  tipo_movimiento ENUM('ingreso','venta','devolucion','traslado'),
  id_pedido INT,
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
  FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal),
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

ALTER TABLE Movimiento_Stock
  ADD talla VARCHAR(10),
  ADD color VARCHAR(20);


INSERT INTO Sucursal (nombre, ubicacion, tipo_canales)
VALUES
 ('Sucursal Centro', 'Av. 24 de septiembre #775, Santa Cruz', 'presencial,online,redes,whatsapp'),
 ('Sucursal Equipetrol', 'Av. Santos Dumont #856, Equipetrol', 'presencial,online'),
 ('Sucursal Ventura Mall', 'Ventura Mall, Nivel 2', 'presencial,online');
 
 INSERT INTO Producto (codigo_unico, nombre, descripcion, marca, categoria, precio_base, activo)
VALUES
 ('P001','Camisa Casual Blanca','Camisa manga larga algodon','MarcaX','Casual',49.90,TRUE),
 ('P002','Pantalon Deportivo','Pantalon deportivo nylon','FitSport','Deportivo',59.90,TRUE),
 ('P003','Vestido Oficina Azul','Vestido formal azul','OfficeStyle','Oficina',79.90,TRUE),
 ('P004','Zapatillas Urbano','Calzado urbano comodo','SneakCo','Calzado',89.90,TRUE),
 ('P005','Cartera Cuero','Bolso de cuero marron','LeatherLux','Accesorios',129.90,TRUE);

INSERT INTO Coleccion (nombre, fecha_inicio, fecha_fin)
VALUES
 ('Primavera 2025','2025-09-01','2025-11-30'),
 ('Verano 2025','2025-12-01','2026-02-28'),
 ('Otoño 2025','2025-03-01','2025-05-31'),
 ('Invierno 2025','2025-06-01','2025-08-31'),
 ('Edición Especial','2025-04-15','2025-06-15');
 
 INSERT INTO Cliente (nombre, apellido, email, telefono, fidelidad)
VALUES
 ('Ana','Gonzalez','ana.g@example.com','76502001','Gold'),
 ('Luis','Martínez','luis.m@example.com','79203002','Plata'),
 ('Carla','Perez','carla.p@example.com','78507003','Bronce'),
 ('Diego','Flores','diego.f@example.com','77400704','Plata'),
 ('Elena','Ramírez','elena.r@example.com','72508005','Gold');
 
 INSERT INTO Vendedor (nombre, apellido, turno, meta_mensual, id_sucursal)
VALUES
 ('Mary','Lopez','mañana',5000.00,1),
 ('Josue','Suárez','tarde',4500.00,1),
 ('Patty','Vargas','noche',4000.00,2),
 ('Camilo','Reyes','mañana',5500.00,2),
 ('Valeria','Cruz','tarde',6000.00,3);
 
 INSERT INTO Promocion (nombre, tipo, valor_descuento, fecha_ini, fecha_fin, activo)
VALUES
 ('Promo Verano','Porcentaje',10.00,'2025-12-01','2026-02-28',TRUE),
 ('Descuento Camisas','Monto',15.00,'2025-09-15','2025-10-15',TRUE),
 ('Black Friday','Porcentaje',20.00,'2025-11-25','2025-11-28',TRUE),
 ('Promo Fin de Semana','Porcentaje',5.00,'2025-09-05','2025-09-07',TRUE),
 ('Edición Especial','Monto',30.00,'2025-04-15','2025-06-15',TRUE);
 
 INSERT INTO Pedido (fecha_creacion, fecha_pago, estado, canal, id_cliente, id_vendedor, id_sucursal)
VALUES
 ('2025-06-10 10:30:00','2025-06-10 10:40:00','Pagado','presencial',1,1,1),
 ('2025-06-12 14:00:00',NULL,'En preparacion','online',2,NULL,1),
 ('2025-06-13 16:20:00','2025-06-13 16:45:00','Entregado','redes',3,5,3),
 ('2025-06-14 18:10:00','2025-06-14 18:20:00','Devuelto','whatsapp',4,NULL,2),
 ('2025-06-15 09:05:00','2025-06-15 09:10:00','Enviado','online',5,4,2);
 
 INSERT INTO Detalle_Pedido (id_pedido, id_producto, talla, color, cantidad, precio_unitario, id_promocion)
VALUES
 (1,1,'M','Blanco',2,49.90,2),
 (2,2,'L','Negro',1,59.90,NULL),
 (3,4,'42','Gris',1,89.90,1),
 (4,3,'S','Azul',1,79.90,5),
 (5,5,'Única','Marrón',1,129.90,NULL);
 
 INSERT INTO Movimiento_Stock (id_producto, id_sucursal, fecha, cantidad, tipo_movimiento, id_pedido, talla, color)
VALUES
  (1, 1, '2025-06-10 10:30:00', -2, 'venta', 1, 'M', 'Blanco'),
  (2, 1, '2025-06-12 14:00:00', -1, 'venta', 2, 'L', 'Negro'),
  (4, 3, '2025-06-13 16:20:00', -1, 'venta', 3, '42', 'Gris'),
  (3, 2, '2025-06-14 18:10:00', +1, 'devolucion', 4, 'S', 'Azul'),
  (5, 2, '2025-06-15 09:05:00', -1, 'venta', 5, 'Única', 'Marrón');


INSERT INTO Producto_Coleccion (id_producto, id_coleccion)
VALUES
  (1, 1),  -- Camisa Casual Blanca → Primavera 2025
  (2, 2),  -- Pantalón Deportivo → Verano 2025
  (3, 3),  -- Vestido Oficina Azul → Otoño 2025
  (4, 4),  -- Zapatillas Urbano → Invierno 2025
  (5, 5);  -- Cartera Cuero → Edición Especial

-- Reporte de Ventas por Sucursal, Categoría y Marca
SELECT
  s.nombre AS sucursal,
  p.marca,
  p.categoria,
  DATE(ped.fecha_creacion) AS fecha,
  COUNT(*) AS total_items,
  SUM(dp.cantidad * dp.precio_unitario) AS total_ventas
FROM Pedido ped
JOIN Detalle_Pedido dp ON dp.id_pedido = ped.id_pedido
JOIN Producto p ON p.id_producto = dp.id_producto
JOIN Sucursal s ON s.id_sucursal = ped.id_sucursal
WHERE ped.fecha_creacion BETWEEN '2025-06-10 10:30:00' AND '2025-06-15 09:05:00'
GROUP BY s.nombre, p.marca, p.categoria, DATE(ped.fecha_creacion);

-- Reporte de Pedidos Pendientes y Entregas
SELECT
  ped.id_pedido,
  ped.estado,
  c.nombre AS cliente,
  ped.canal,
  ped.fecha_creacion,
  ped.fecha_pago,
  COUNT(dp.id_producto) AS total_lineas,
  SUM(dp.cantidad) AS total_items,
  MIN(m.fecha) AS fecha_ultimo_mov,
  MAX(CASE 
      WHEN m.tipo_movimiento IN ('venta','devolucion') THEN m.fecha
      ELSE NULL
  END) AS fecha_entrega
FROM Pedido ped
JOIN Cliente c ON c.id_cliente = ped.id_cliente
LEFT JOIN Detalle_Pedido dp ON dp.id_pedido = ped.id_pedido
LEFT JOIN Movimiento_Stock m ON m.id_pedido = ped.id_pedido
GROUP BY ped.id_pedido, ped.estado, c.nombre, ped.canal, ped.fecha_creacion, ped.fecha_pago;

-- Reporte de Ingresos Mensuales
SELECT
  DATE_FORMAT(ped.fecha_creacion, '%Y-%m') AS anio_mes,
  ped.canal,
  SUM(dp.cantidad * dp.precio_unitario) AS ingresos,
  SUM(CASE WHEN dp.id_promocion IS NOT NULL THEN dp.cantidad * dp.precio_unitario ELSE 0 END) AS ingresos_promocion
FROM Pedido ped
JOIN Detalle_Pedido dp ON dp.id_pedido = ped.id_pedido
WHERE ped.estado IN ('Pagado','Entregado')
GROUP BY anio_mes, ped.canal
ORDER BY anio_mes, ped.canal;

-- Reporte: Comisiones por vendedor
SELECT
  v.nombre,
  DATE(ped.fecha_creacion) AS fecha,
  SUM(dp.cantidad * dp.precio_unitario) AS total_ventas,
  SUM(dp.cantidad * dp.precio_unitario) * 0.05 AS comision -- como un ejemplo 5%
FROM Pedido ped
JOIN Detalle_Pedido dp ON dp.id_pedido = ped.id_pedido
JOIN Vendedor v ON v.id_vendedor = ped.id_vendedor
WHERE ped.estado IN ('Pagado','Entregado')
  AND ped.fecha_creacion BETWEEN '2025-06-10 10:30:00' AND '2025-06-15 09:05:00'
GROUP BY v.nombre, DATE(ped.fecha_creacion);

-- Reporte de Stock e Inventario
SELECT
  p.codigo_unico,
  p.nombre,
  ms.talla,
  ms.color,
  s.nombre AS sucursal,
  COALESCE(SUM(
    CASE
      WHEN ms.tipo_movimiento = 'venta' THEN -ms.cantidad
      WHEN ms.tipo_movimiento = 'devolucion' THEN ms.cantidad
      ELSE ms.cantidad
    END
  ), 0) AS stock_actual
FROM Producto p
CROSS JOIN Sucursal s
LEFT JOIN Movimiento_Stock ms
  ON ms.id_producto = p.id_producto
 AND ms.id_sucursal = s.id_sucursal
GROUP BY
  p.codigo_unico,
  p.nombre,
  s.nombre,
  ms.talla,
  ms.color
HAVING stock_actual <= 10
ORDER BY
  p.codigo_unico,
  s.nombre;









